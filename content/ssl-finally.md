Title: SSL ... Finally!
Date: 2018-04-07 20:16
Author: ryan
Category: Technology
Tags: SSL, Server
Slug: ssl-finally
Status: published

I’ve been futzing around with SSL on this site since last December. I’ve had about 4 attempts and it just never seemed to work.

Earlier this evening I was thinking about getting a second [Linode](https://www.linode.com) just to get a fresh start. I was *this* close to getting it when I thought, what the hell, let me try to work it out one more time.

And this time it actually worked.

I’m not really sure what I did differently, but using this [site](https://certbot.eff.org/lets-encrypt/ubuntuxenial-apache) seemed to make all of the difference.

The only other thing I had to do was make a change in the word press settings (from `http` to `https`) and enable a plugin [Really Simple SSL](https://really-simple-ssl.com) and it finally worked.

I even got an ‘A’ from SSL Labs!

![](/images/uploads/2018/04/Image-4-7-18-9-15-PM.png){.alignnone .size-full .wp-image-265 width="2732" height="2048"}

Again, not really sure why this seemed so hard and took so long.

I guess sometimes you just have to try over and over and over again
