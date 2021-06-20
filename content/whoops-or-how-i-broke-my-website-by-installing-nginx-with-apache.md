Title: Whoops! Or how I broke my website by installing Nginx with Apache
Date: 2018-05-01 17:04
Author: ryan
Category: Musings
Tags: apache2, django, nginx
Slug: whoops-or-how-i-broke-my-website-by-installing-nginx-with-apache
Status: published

I’ve been working on a project to create a [Django](https://www.djangoproject.com) based website. Over the weekend (Saturday I think) I tried to get it up and running on my [Linode](https://www.djangoproject.com) server. However, after a couple of failed attempts I decided to use the free hosting coupon^[1](#fn1){#ffn1 .footnote}^ I had for [DigitalOcean](https://www.digitalocean.com) to see if that allowed me to reply more easily deploy … the short answer … meh.

What I didn’t realize over the weekend is that while I had been trying to deploy my Django site, I had installed [Nginx](http://nginx.org) on my Linode server that was also running [apache2](https://httpd.apache.org). This lead to them both trying to listen on port 80 but because Nginx was the last thing I had kicked off, it was *winning*.

While I was working on my Django site I should have realized that something was up when I tried to connect to the blog for the site (still a Wordpress site on my Linode server) and it returned a ‘Can not connect to the server message’. I didn’t pay much attention because I figured (incorrectly) that I had done something specific to that subdomain, and not that I had made all of the sites on my Linode server inaccessible.

Last night at about 9 I thought, “Well, it should’t take long for me to figure out the issue with the new blog. ”

By 10:15 I tried everything the internet had told me to try and I was still unable to get apache2 to reload.

I googled a bunch of stuff, but nothing was helping.

When I tried to get the status on apache2 I would get this:

    ● apache2.service - LSB: Apache2 web server
       Loaded: loaded (/etc/init.d/apache2; bad; vendor preset: enabled)
      Drop-In: /lib/systemd/system/apache2.service.d
               └─apache2-systemd.conf
       Active: inactive (dead) since Tue 2018-05-01 05:01:03 PDT; 5s ago
         Docs: man:systemd-sysv-generator(8)
      Process: 7718 ExecStop=/etc/init.d/apache2 stop (code=exited, status=0/SUCCESS)
      Process: 7703 ExecStart=/etc/init.d/apache2 start (code=exited, status=0/SUCCESS)

    May 01 05:01:03 milo apache2[7703]: (98)Address already in use: AH00072: make_sock: could not bind to address [::]:80
    May 01 05:01:03 milo apache2[7703]: (98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:80
    May 01 05:01:03 milo apache2[7703]: no listening sockets available, shutting down
    May 01 05:01:03 milo apache2[7703]: AH00015: Unable to open logs
    May 01 05:01:03 milo apache2[7703]: Action 'start' failed.
    May 01 05:01:03 milo apache2[7703]: The Apache error log may have more information.
    May 01 05:01:03 milo apache2[7703]:  *
    May 01 05:01:03 milo apache2[7718]:  * Stopping Apache httpd web server apache2
    May 01 05:01:03 milo apache2[7718]:  *
    May 01 05:01:03 milo systemd[1]: Started LSB: Apache2 web server.

This morning I started to google each line of the status message and finally got to this:

    no listening sockets available, shutting down

Googling for that lead me to trying this:

    sudo netstat -ltnp | grep ':80'

Which output this:

    tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      3324/nginx -g daemo
    tcp6       0      0 :::80                   :::*                    LISTEN      3324/nginx -g daemo

And finally, I saw the issue. Over the weekend while I was futzing around I had apparently installed Nginx and let it listen on port 80 AND kept it running.

Once I killed the Nginx process with this:

    sudo kill -9 3324

I was able to restart apache2 with no problems.

Thank goodness.

I find that when I mess something up like this it’s important to ask myself what I learned from the experience.

In that vein …

What did I learn from this experience?

1.  Can’t run apache2 and Nginx on the same server and have them listen on the same port. Seems obvious, but you know having to **actually** deal with it really seals the deal
2.  The output messages are super helpful … google each part of them and don’t give up
3.  A good night’s sleep can make all the difference
4.  Rolling your own web server is less expensive than having it be Turnkey (a la SquareSpace, or some other hosted solution) but you end up being your own Sys Admin and that’s actually pretty easy when things are going well, and a freaking nightmare when they’re not

```{=html}
<!-- -->
```
1.  [Thanks to the Talk Python to Me Course for Entrepreneurs [↩](#ffn1)]{#fn1}
