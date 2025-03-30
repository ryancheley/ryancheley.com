Title: Setting up the site with SSL
Date: 2017-12-15 02:00
Author: ryan
Tags: Server
Slug: setting-up-the-site-with-ssl
Status: published

I’ve written about my migration from Squarespace to Wordpress earlier this year. One thing I lost with that migration when I went to Wordpress in AWS was having SSL available. While I’m sure Van Hoet will “well actually” me on this, I never could figure out how to set it up ( not that I tried particularly hard ).

The thing is now that I’m hosting on Linode I’m finding some really useful tutorials. This [one](# "Setting up SSL on Linode") showed me exactly what I needed to do to get it set up.

Like any good planner I read the how to several times and convinced myself that it was actually relatively straight forward to do and so I started.

## Step 1 Creating the cert files

Using [this tutorial](https://www.linode.com/docs/security/ssl/create-a-self-signed-certificate-on-debian-and-ubuntu "Creating Self Signed Certificates on Ubuntu")I was able to create the required certificates to set up SSL. Of course, I ran into an issue when trying to run this command

`chmod 400 /etc/ssl/private/example.com.key`

I did not have persmision to chmod on that file. After a bit of Googling I found that I can switch to interactive root mode by running the command

`sudo -i`

It feels a bit dangerous to be able to just do that (I didn’t have to enter a password) but it worked.

## Step 2

OK, so the tutorial above got me most(ish) of the way there, but I needed to sign my own certificate. For that I used this [tutorial](https://www.linode.com/docs/security/ssl/install-lets-encrypt-to-create-ssl-certificates "SSL"). I followed the directions but kept coming up with an error:

`Problem binding to port 443: Could not bind to the IPv4 or IPv6`

I rebooted my Linode server. I restarted apache. I googled and I couldn’t find the answer I was looking for.

I wanted to give up, but tried Googling one more time. Finally! An answer so simple it couldn’t work. But then it did.

Stop Apache, run the command to start Apache back up and boom. The error went away and I had a certificate.

However, when I tested the site using [SSL Labs](https://www.ssllabs.com/ssltest/analyze.html "Analyze my SSL")I was still getting an error / warning for an untrusted site.

🤦🏻‍♂️

—

OK ... take 2

I nuked my linode host to start over again.

First things first ... we need to needed to [secure my server](https://linode.com/docs/security/securing-your-server/ "Securing Your Server"). Next, we need to set up the server as a LAMP and Linode has [this tutorial](https://linode.com/docs/web-servers/lamp/install-lamp-stack-on-ubuntu-16-04/ "LAMP on Linode") to walk me through the steps of setting it up.

I ran into an issue when I restarted the Apache service and realized that I had set my host name but hadn’t update the hosts file. No problem though. Just fire up `vim` and make the additional line:

`127.0.0.1   milo`

Next, I used [this tutorial](https://www.linode.com/docs/security/ssl/create-a-self-signed-certificate-on-debian-and-ubuntu/ "Self Signed Certificate on Ubuntu") to create a self signed certificate and [this to get the SSL to be set up](https://www.linode.com/docs/security/ssl/ssl-apache2-debian-ubuntu/ "SSL Apache2 Ubuntu").

One thing that I expected was that it would just work. After doing some more reading what I realized was that a self signed certificate is useful for internal applications. Once I realized this I decided to not redirect to SSL (i.e. part 443) for my site but instead to just use the ssl certificate it post from Ulysses securely.

Why go to all this trouble just too use a third party application to post to a WordPress site? Because [Ulysses](https://www.ulyssesapp.com "Ulysses") is an awesome writing app and I love it. If you’re writing and not using it, I’d give it a try. It really is a nice app.

So really, no *good* reason. Just that. And, I like to figure stuff out.

OK, so Ulysses is great. But why the need for an SSL certificate? Mostly because when I tried to post to Wordpress from Ulysses without any certificates ( self signed or not ) I would get a warning that my traffic was unencrypted and could be snooped. I figured, better safe than sorry.

Now with the ssl cert all I had to do was trust my self signed certificate and I was set[ref]Mostly. I still needed to specify the domain with www otherwise it didn’t work.[/ref]
