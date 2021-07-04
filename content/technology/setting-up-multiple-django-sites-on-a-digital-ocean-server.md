Title: Setting up multiple Django Sites on a Digital Ocean server
Date: 2021-03-07 12:00
Author: ryan
Tags: digital ocean
Series: Deploying your Django App to Digital Ocean
Slug: setting-up-multiple-django-sites-on-a-digital-ocean-server
Status: published

If you want to have more than 1 Django site on a single server, you can. It’s not too hard, and using the Digital Ocean tutorial as a starting point, you can get there.

Using [this tutorial](https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-ubuntu-18-04) as a start, we set up so that there are multiple Django sites being served by `gunicorn` and `nginx`.

## Creating `systemd` Socket and Service Files for Gunicorn

The first thing to do is to set up 2 Django sites on your server. You’ll want to follow the tutorial referenced above and just repeat for each.

Start by creating and opening two systemd socket file for Gunicorn with sudo privileges:

Site 1

``` {.wp-block-code}
sudo vim /etc/systemd/system/site1.socket
```

Site 2

``` {.wp-block-code}
sudo vim /etc/systemd/system/site2.socket
```

The contents of the files will look like this:

``` {.wp-block-code}
[Unit]
Description=siteX socket

[Socket]
ListenStream=/run/siteX.sock

[Install]
WantedBy=sockets.target
```

Where `siteX` is the site you want to server from that socket

Next, create and open a systemd service file for Gunicorn with sudo privileges in your text editor. The service filename should match the socket filename with the exception of the extension

``` {.wp-block-code}
sudo vim /etc/systemd/system/siteX.service
```

The contents of the file will look like this:

``` {.wp-block-code}
[Unit]
Description=gunicorn daemon
Requires=siteX.socket
After=network.target

[Service]
User=sammy
Group=www-data
WorkingDirectory=path/to/directory
ExecStart=path/to/gunicorn/directory   
         --access-logfile -   
         --workers 3   
         --bind unix:/run/gunicorn.sock   
         myproject.wsgi:application

[Install]
WantedBy=multi-user.target
```

Again `siteX` is the socket you want to serve

Follow tutorial for testing Gunicorn

## Nginx

``` {.wp-block-code}
server {
    listen 80;
    server_name server_domain_or_IP;

    location = /favicon.ico { access_log off; log_not_found off; }
    location /static/ {
        root /path/to/project;
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/run/siteX.sock;
    }
}
```

Again `siteX` is the socket you want to serve

Next, link to enabled sites

Test Nginx

Open firewall

Should now be able to see sites at domain names
