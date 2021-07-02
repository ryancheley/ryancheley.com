Title: Getting your Domain to point to Digital Ocean Your Server
Date: 2021-02-07 12:00
Author: ryan
Tags: digital ocean, series, server, setup, web
Slug: getting-your-domain-to-point-to-digital-ocean-your-server
Status: published

I use Hover for my domain purchases and management. Why? Because they have a clean, easy to use, not-slimy interface, and because I listed to enough Tech Podcasts that I’ve drank the Kool-Aid.

When I was trying to get my Hover Domain to point to my Digital Ocean server it seemed much harder to me than it needed to be. Specifically, I couldn’t find any guide on doing it! Many of the tutorials I did find were basically like, it’s all the same. We’ll show you with GoDaddy and then you can figure it out.

Yes, I can figure it out, but it wasn’t as easy as it could have been. That’s why I’m writing this up.

## Digital Ocean

From Droplet screen click ‘Add a Domain’

```{=html}
<figure class="aligncenter">
```
![Add a Domain](/images/uploads/2021/02/DraggedImage.png){.wp-image-470}

```{=html}
</p>
```
Add 2 ‘A’ records (one for www and one without the www)

![A record](/images/uploads/2021/02/DraggedImage-1.png){.wp-image-469}

Make note of the name servers

![Nameserver](/images/uploads/2021/02/DraggedImage-2.png){.wp-image-471}

## Hover

In your account at Hover.com change your Name Servers to Point to Digital Ocean ones from above.

![Hover](/images/uploads/2021/02/DraggedImage-3.png){.wp-image-468}

## Wait

DNS … does anyone *really* know how it works?^[1](#fn1){#ffn1 .footnote}^ I just know that sometimes when I make a change it’s out there almost immediately for me, and sometimes it takes hours or days.

At this point, you’re just going to potentially need to wait. Why? Because DNS that’s why. Ugh!

## Setting up directory structure

While we’re waiting for the DNS to propagate, now would be a good time to set up some file structures for when we push our code to the server.

For my code deploy I’ll be using a user called `burningfiddle`. We have to do two things here, create the user, and add them to the `www-data` user group on our Linux server.

We can run these commands to take care of that:

``` {.wp-block-code}
adduser --disabled-password --gecos "" yoursite
```

The first line will add the user with no password and disable them to be able to log in until a password has been set. Since this user will NEVER log into the server, we’re done with the user creation piece!

Next, add the user to the proper group

``` {.wp-block-code}
adduser yoursite www-data
```

Now we have a user and they’ve been added to the group we need them to be added. In creating the user, we also created a directory for them in the `home` directory called `yoursite`. You should now be able to run this command without error

``` {.wp-block-code}
ls /home/yoursite/
```

If that returns an error indicating no such directory, then you may not have created the user properly.

Now we’re going to make a directory for our code to be run from.

``` {.wp-block-code}
mkdir /home/yoursite/yoursite
```

To run our Django app we’ll be using virtualenv. We can create our virtualenv directory by running this command

``` {.wp-block-code}
python3 -m venv /home/yoursite/venv
```

## Configuring Gunicorn

There are two files needed for Gunicorn to run:

-   gunicorn.socket
-   gunicorn.service  

For our setup, this is what they look like:

``` {.wp-block-code}
# gunicorn.socket

[Unit]
Description=gunicorn socket

[Socket]
ListenStream=/run/gunicorn.sock

[Install]
WantedBy=sockets.target
```

``` {.wp-block-code}
# gunicorn.service

[Unit]
Description=gunicorn daemon
Requires=gunicorn.socket
After=network.target

[Service]
User=yoursite
EnvironmentFile=/etc/environment
Group=www-data
WorkingDirectory=/home/yoursite/yoursite
ExecStart=/home/yoursite/venv/bin/gunicorn   
         --access-logfile -   
         --workers 3   
         --bind unix:/run/gunicorn.sock   
         yoursite.wsgi:application


[Install]
WantedBy=multi-user.target
```

For more on the details of the sections in both `gunicorn.service` and `gunicorn.socket` see this [article](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files "Understanding systemd units and unit files").

## Environment Variables

The only environment variables we have to worry about here (since we’re using SQLite) are the DJANGO_SECRET_KEY and DJANGO_DEBUG

We’ll want to edit `/etc/environment` with our favorite editor (I’m partial to `vim` but use whatever you like

``` {.wp-block-code}
vim /etc/environment
```

In this file you’ll add your DJANGO_SECRET_KEY and DJANGO_DEBUG. The file will look something like this once you’re done:

``` {.wp-block-code}
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
DJANGO_SECRET_KEY=my_super_secret_key_goes_here
DJANGO_DEBUG=False
```

## Setting up Nginx

Now we need to create our `.conf` file for Nginx. The file needs to be placed in `/etc/nginx/sites-available/$sitename` where `$sitename` is the name of your site. [fn](# "In my case I'm leaving off the tld but you could just as easily name it with the tld")

The final file will look (something) like this [fn](# "Note that my site is called yoursite in this example")

``` {.wp-block-code}
server {
    listen 80;
    server_name www.yoursite.com yoursite.com;

    location = /favicon.ico { access_log off; log_not_found off; }
    location /static/ {
        root /home/yoursite/yoursite/;
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/run/gunicorn.sock;
    }
}
```

The `.conf` file above tells Nginx to listen for requests to either `www.buringfiddle.com` or `buringfiddle.com` and then route them to the location `/home/yoursite/yoursite/` which is where our files are located for our Django project.

With that in place all that’s left to do is to make it enabled by running replacing `$sitename` with your file

``` {.wp-block-code}
ln -s /etc/nginx/sites-available/$sitename /etc/nginx/sites-enabled
```

You’ll want to run

``` {.wp-block-code}
nginx -t
```

to make sure there aren’t any errors. If no errors occur you’ll need to restart Nginx

``` {.wp-block-code}
systemctl restart nginx
```

The last thing to do is to allow full access to Nginx. You do this by running

``` {.wp-block-code}
ufw allow 'Nginx Full'
```

1.  [Probably just [Julia Evans](https://jvns.ca/blog/how-updating-dns-works/) [↩](#ffn1)]{#fn1}
