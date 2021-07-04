Title: Setting up the Server (on Digital Ocean)
Date: 2021-01-31 12:00
Author: ryan
Tags: Deployment, Server
Series: Deploying your Django App to Digital Ocean
Slug: setting-up-the-server-on-digital-ocean
Status: published

## The initial setup

Digital Ocean has a pretty nice API which makes it easy to automate the creation of their servers (which they call `Droplets`. This is nice when you’re trying to work towards automation of the entire process (like I was).

I won’t jump into the automation piece just yet, but once you have your DO account setup (sign up [here](https://m.do.co/c/cc5fdad15654) if you don’t have one), it’s a simple interface to [Setup Your Droplet](https://www.digitalocean.com/docs/droplets/how-to/create/).

I chose the Ubuntu 18.04 LTS image with a \$5 server (1GB Ram, 1CPU, 25GB SSD Space, 1000GB Transfer) hosted in their San Francisco data center (SFO2[ref]SFO2 is disabled for new customers and you will now need to use SFO3 unless you already have resources on SFO2, but if you’re following along you probably don’t. What’s the difference between the two? Nothing 😁[/ref]).

## We’ve got a server … now what?

We’re going to want to update, upgrade, and install all of the (non-Python) packages for the server. For my case, that meant running the following:

``` {.wp-block-code}
apt-get update
apt-get upgrade
apt-get install python3 python3-pip python3-venv tree postgresql postgresql-contrib nginx
```

That’s it! We’ve now got a server that is ready to be setup for our Django Project.

In the next post, I’ll walk through how to get your Domain Name to point to the Digital Ocean Server.
