Title: Automating the deployment
Date: 2021-02-21 12:00
Author: ryan
Tags: Deployment, digital ocean, Django
Series: Deploying your Django App to Digital Ocean
Slug: automating-the-deployment
Status: published

We got everything set up, and now we want to automate the deployment.

Why would we want to do this you ask? Let’s say that you’ve decided that you need to set up a test version of your site (what some might call UAT) on a new server (at some point I’ll write something up about about multiple Django Sites on the same server and part of this will still apply then). How can you do it?

Well you’ll want to write yourself some scripts!

I have a mix of Python and Shell scripts set up to do this. They are a bit piece meal, but they also allow me to run specific parts of the process without having to try and execute a script with ‘commented’ out pieces.

**Python Scripts**

create_server.py

destroy_droplet.py

**Shell Scripts**

copy_for_deploy.sh

create_db.sh

create_server.sh

deploy.sh

deploy_env_variables.sh

install-code.sh

setup-server.sh

setup_nginx.sh

setup_ssl.sh

super.sh

upload-code.sh

The Python script `create_server.py` looks like this:

```
# create_server.py

import requests
import os
from collections import namedtuple
from operator import attrgetter
from time import sleep

Server = namedtuple('Server', 'created ip_address name')

doat = os.environ['DIGITAL_OCEAN_ACCESS_TOKEN']

# Create Droplet
headers = {
    'Content-Type': 'application/json',
    'Authorization': f'Bearer {doat}',
}

data = <data_keys>
print('>>> Creating Server')
requests.post('https://api.digitalocean.com/v2/droplets', headers=headers, data=data)
print('>>> Server Created')
print('>>> Waiting for Server Stand up')
sleep(90)


print('>>> Getting Droplet Data')
params = (
    ('page', '1'),
    ('per_page', '10'),
)

get_droplets = requests.get('https://api.digitalocean.com/v2/droplets', headers=headers, params=params)

server_list = []

for d in get_droplets.json()['droplets']:
    server_list.append(Server(d['created_at'], d['networks']['v4'][0]['ip_address'], d['name']))

server_list = sorted(server_list, key=attrgetter('created'), reverse=True)

server_ip_address = server_list[0].ip_address
db_name = os.environ['DJANGO_PG_DB_NAME']
db_username = os.environ['DJANGO_PG_USER_NAME']
if server_ip_address != <production_server_id>:
    print('>>> Run server setup')
    os.system(f'./setup-server.sh {server_ip_address} {db_name} {db_username}')
    print(f'>>> Server setup complete. You need to add {server_ip_address} to the ALLOWED_HOSTS section of your settings.py file ')
else:
    print('WARNING: Running Server set up will destroy your current production server. Aborting process')
```

Earlier I said that I liked Digital Ocean because of it’s nice API for interacting with it’s servers (i.e. Droplets). Here we start to see some.

The First part of the script uses my Digital Ocean Token and some input parameters to create a Droplet via the Command Line. The `sleep(90)` allows the process to complete before I try and get the IP address. Ninety seconds is a bit longer than is needed, but I figure, better safe than sorry … I’m sure that there’s a way to call to DO and ask if the just created droplet has an IP address, but I haven’t figured it out yet.

After we create the droplet AND is has an IP address, we get it to pass to the bash script `server-setup.sh`.

```
# server-setup.sh

#!/bin/bash

# Create the server on Digital Ocean
export SERVER=$1

# Take secret key as 2nd argument
if [[ -z "$1" ]]
then
    echo "ERROR: No value set for server ip address1"
    exit 1
fi

echo -e "\n>>> Setting up $SERVER"
ssh root@$SERVER /bin/bash << EOF
    set -e

    echo -e "\n>>> Updating apt sources"
    apt-get -qq update

    echo -e "\n>>> Upgrading apt packages"
    apt-get -qq upgrade

    echo -e "\n>>> Installing apt packages"
    apt-get -qq install python3 python3-pip python3-venv tree supervisor postgresql postgresql-contrib nginx

    echo -e "\n>>> Create User to Run Web App"
    if getent passwd burningfiddle
    then
      echo ">>> User already present"
    else
      adduser --disabled-password --gecos "" burningfiddle
      echo -e "\n>>> Add newly created user to www-data"
      adduser burningfiddle www-data
    fi

    echo -e "\n>>> Make directory for code to be deployed to"

    if [[ ! -d "/home/burningfiddle/BurningFiddle" ]]
    then
        mkdir /home/burningfiddle/BurningFiddle
    else
        echo ">>> Skipping Deploy Folder creation - already present"
    fi


    echo -e "\n>>> Create VirtualEnv in this directory"
    if [[ ! -d "/home/burningfiddle/venv" ]]
    then
      python3 -m venv /home/burningfiddle/venv
    else
        echo ">>> Skipping virtualenv creation - already present"
    fi

    # I don't think i need this anymore
    echo ">>> Start and Enable gunicorn"
    systemctl start gunicorn.socket
    systemctl enable gunicorn.socket


EOF

./setup_nginx.sh $SERVER
./deploy_env_variables.sh $SERVER
./deploy.sh $SERVER
```

All of that stuff we did before, logging into the server and running commands, we’re now doing via a script. What the above does is attempt to keep the server in an idempotent state (that is to say you can run it as many times as you want and you don’t get weird artifacts … if you’re a math nerd you may have heard idempotent in Linear Algebra to describe the multiplication of a matrix by itself and returning the original matrix … same idea here!)

The one thing that is new here is the part

```
ssh root@$SERVER /bin/bash << EOF
    ...
EOF
```

A block like that says, “take everything in between `EOF` and run it on the server I just ssh’d into using bash.

At the end we run 3 shell scripts:

-   `setup_nginx.sh`
-   `deploy_env_variables.sh`
-   `deploy.sh`

Let’s review these scripts

The script `setup_nginx.sh` copies several files needed for the `nginx` service:

-   `gunicorn.service`
-   `gunicorn.sockets`
-   `nginx.conf`

It then sets up a link between the `available-sites` and `enabled-sites` for `nginx` and finally restarts `nginx`

```
# setup_nginx.sh

export SERVER=$1
export sitename=burningfiddle
scp -r ../config/gunicorn.service root@$SERVER:/etc/systemd/system/
scp -r ../config/gunicorn.socket root@$SERVER:/etc/systemd/system/
scp -r ../config/nginx.conf root@$SERVER:/etc/nginx/sites-available/$sitename

ssh root@$SERVER /bin/bash << EOF

  echo -e ">>> Set up site to be linked in Nginx"
  ln -s /etc/nginx/sites-available/$sitename /etc/nginx/sites-enabled
  echo -e ">>> Restart Nginx"
  systemctl restart nginx
  echo -e ">>> Allow Nginx Full access"
  ufw allow 'Nginx Full'

EOF
```

The script `deploy_env_variables.sh` copies environment variables. There are packages (and other methods) that help to manage environment variables better than this, and that is one of the enhancements I’ll be looking at.

This script captures the values of various environment variables (one at a time) and then passes them through to the server. It then checks to see if these environment variables exist on the server and will place them in the `/etc/environment` file

```
export SERVER=$1

DJANGO_SECRET_KEY=printenv | grep DJANGO_SECRET_KEY
DJANGO_PG_PASSWORD=printenv | grep DJANGO_PG_PASSWORD
DJANGO_PG_USER_NAME=printenv | grep DJANGO_PG_USER_NAME
DJANGO_PG_DB_NAME=printenv | grep DJANGO_PG_DB_NAME
DJANGO_SUPERUSER_PASSWORD=printenv | grep DJANGO_SUPERUSER_PASSWORD
DJANGO_DEBUG=False

ssh root@$SERVER /bin/bash << EOF
    if [[ "\$DJANGO_SECRET_KEY" != "$DJANGO_SECRET_KEY" ]]
    then
        echo "DJANGO_SECRET_KEY=$DJANGO_SECRET_KEY" >> /etc/environment
    else
        echo ">>> Skipping DJANGO_SECRET_KEY - already present"
    fi

    if [[ "\$DJANGO_PG_PASSWORD" != "$DJANGO_PG_PASSWORD" ]]
    then
        echo "DJANGO_PG_PASSWORD=$DJANGO_PG_PASSWORD" >> /etc/environment
    else
        echo ">>> Skipping DJANGO_PG_PASSWORD - already present"
    fi

    if [[ "\$DJANGO_PG_USER_NAME" != "$DJANGO_PG_USER_NAME" ]]
    then
        echo "DJANGO_PG_USER_NAME=$DJANGO_PG_USER_NAME" >> /etc/environment
    else
        echo ">>> Skipping DJANGO_PG_USER_NAME - already present"
    fi

    if [[ "\$DJANGO_PG_DB_NAME" != "$DJANGO_PG_DB_NAME" ]]
    then
        echo "DJANGO_PG_DB_NAME=$DJANGO_PG_DB_NAME" >> /etc/environment
    else
        echo ">>> Skipping DJANGO_PG_DB_NAME - already present"
    fi

    if [[ "\$DJANGO_DEBUG" != "$DJANGO_DEBUG" ]]
    then
        echo "DJANGO_DEBUG=$DJANGO_DEBUG" >> /etc/environment
    else
        echo ">>> Skipping DJANGO_DEBUG - already present"
    fi
EOF
```

The `deploy.sh` calls two scripts itself:

```
# deploy.sh

#!/bin/bash
set -e
# Deploy Django project.
export SERVER=$1
#./scripts/backup-database.sh
./upload-code.sh
./install-code.sh
```

The final two scripts!

The `upload-code.sh` script uploads the files to the `deploy` folder of the server while the `install-code.sh` script move all of the files to where then need to be on the server and restart any services.

```
# upload-code.sh

#!/bin/bash
set -e

echo -e "\n>>> Copying Django project files to server."
if [[ -z "$SERVER" ]]
then
    echo "ERROR: No value set for SERVER."
    exit 1
fi
echo -e "\n>>> Preparing scripts locally."
rm -rf ../../deploy/*
rsync -rv --exclude 'htmlcov' --exclude 'venv' --exclude '*__pycache__*' --exclude '*staticfiles*' --exclude '*.pyc'  ../../BurningFiddle/* ../../deploy

echo -e "\n>>> Copying files to the server."
ssh root@$SERVER "rm -rf /root/deploy/"
scp -r ../../deploy root@$SERVER:/root/

echo -e "\n>>> Finished copying Django project files to server."
```

And finally,

```
# install-code.sh

#!/bin/bash
# Install Django app on server.
set -e
echo -e "\n>>> Installing Django project on server."
if [[ -z "$SERVER" ]]
then
    echo "ERROR: No value set for SERVER."
    exit 1
fi
echo $SERVER
ssh root@$SERVER /bin/bash << EOF
  set -e

  echo -e "\n>>> Activate the Virtual Environment"
  source /home/burningfiddle/venv/bin/activate


  cd /home/burningfiddle/

  echo -e "\n>>> Deleting old files"
  rm -rf /home/burningfiddle/BurningFiddle

  echo -e "\n>>> Copying new files"
  cp -r /root/deploy/ /home/burningfiddle/BurningFiddle

  echo -e "\n>>> Installing Python packages"
  pip install -r /home/burningfiddle/BurningFiddle/requirements.txt

  echo -e "\n>>> Running Django migrations"
  python /home/burningfiddle/BurningFiddle/manage.py migrate

  echo -e "\n>>> Creating Superuser"
  python /home/burningfiddle/BurningFiddle/manage.py createsuperuser --noinput --username bfadmin --email rcheley@gmail.com || true

  echo -e "\n>>> Load Initial Data"
  python /home/burningfiddle/BurningFiddle/manage.py loaddata /home/burningfiddle/BurningFiddle/fixtures/pages.json

  echo -e "\n>>> Collecting static files"
  python /home/burningfiddle/BurningFiddle/manage.py collectstatic

  echo -e "\n>>> Reloading Gunicorn"
  systemctl daemon-reload
  systemctl restart gunicorn

EOF

echo -e "\n>>> Finished installing Django project on server."
```
