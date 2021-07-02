Title: Preparing the code for deployment to Digital Ocean
Date: 2021-02-14 12:00
Author: ryan
Tags: Deployment, digital ocean, series
Slug: preparing-the-code-for-deployment-to-digital-ocean
Status: published

OK, we’ve got our server ready for our Django App. We set up Gunicorn and Nginx. We created the user which will run our app and set up all of the folders that will be needed.

Now, we work on deploying the code!

## Deploying the Code

There are 3 parts for deploying our code:

1.  Collect Locally
2.  Copy to Server
3.  Place in correct directory  

Why don’t we just copy to the spot on the server we want o finally be in? Because we’ll need to restart Nginx once we’re fully deployed and it’s easier to have that done in 2 steps than in 1.

### Collect the Code Locally

My project is structured such that there is a `deploy` folder which is on the Same Level as my Django Project Folder. That is to say

![](/images/uploads/2021/02/DraggedImage-4.png){.wp-image-475}

We want to clear out any old code. To do this we run from the same level that the Django Project Folder is in

``` {.wp-block-code}
rm -rf deploy/*
```

This will remove ALL of the files and folders that were present. Next, we want to copy the data from the `yoursite` folder to the deploy folder:

``` {.wp-block-code}
rsync -rv --exclude 'htmlcov' --exclude 'venv' --exclude '*__pycache__*' --exclude '*staticfiles*' --exclude '*.pyc'  yoursite/* deploy
```

Again, running this form the same folder. I’m using `rsync` here as it has a really good API for allowing me to exclude items (I’m sure the above could be done better with a mix of Regular Expressions, but this gets the jobs done)

### Copy to the Server

We have the files collected, now we need to copy them to the server.

This is done in two steps. Again, we want to remove ALL of the files in the deploy folder on the server (see rationale from above)

``` {.wp-block-code}
ssh root@$SERVER "rm -rf /root/deploy/"
```

Next, we use `scp` to secure copy the files to the server

``` {.wp-block-code}
scp -r deploy root@$SERVER:/root/
```

Our files are now on the server!

### Installing the Code

We have several steps to get through in order to install the code. They are:

1.  Activate the Virtual Environment
2.  Deleting old files
3.  Copying new files
4.  Installing Python packages
5.  Running Django migrations
6.  Collecting static files
7.  Reloading Gunicorn  

Before we can do any of this we’ll need to `ssh` into our server. Once that’s done, we can proceed with the steps below.

Above we created our virtual environment in a folder called `venv` located in `/home/yoursite/`. We’ll want to activate it now (1)

``` {.wp-block-code}
source /home/yoursite/venv/bin/activate
```

Next, we change directory into the yoursite home directory

``` {.wp-block-code}
cd /home/yoursite/
```

Now, we delete the old files from the last install (2):

``` {.wp-block-code}
rm -rf /home/yoursite/yoursite
```

Copy our new files (3)

``` {.wp-block-code}
cp -r /root/deploy/ /home/yoursite/yoursite
```

Install our Python packages (4)

``` {.wp-block-code}
pip install -r /home/yoursite/yoursite/requirements.txt
```

Run any migrations (5)

``` {.wp-block-code}
python /home/yoursite/yoursite/manage.py migrate
```

Collect Static Files (6)

``` {.wp-block-code}
python /home/yoursite/yoursite/manage.py collectstatic
```

Finally, reload Gunicorn

``` {.wp-block-code}
systemctl daemon-reload
systemctl restart gunicorn
```

When we visit our domain we should see our Django Site [fn](# "There are other steps that are neccesary like creating a superuser")
