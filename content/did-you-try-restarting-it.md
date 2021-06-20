Title: Did you try restarting it?
Date: 2019-04-07 18:54
Author: ryan
Category: Musings
Tags: Reboot, Tech Support
Slug: did-you-try-restarting-it
Status: published

The number of times an issue is resolved with a simple reboot is amazing. It’s why when you call tech support (for anything) it’s always the first thing they ask you.

Even with my experience in tech I can forget this one little trick when troubleshooting my own stuff. I don’t have a tech support line to call so I have to google, and google and google, and since the assumption is that I’ve already rebooted, it’s not a standard answer that’s put out there. (I mean, of course I rebooted to see if that fixed the problem).

I’ve written before about my [ITFDB and the announcement from Vin Scully “It’s Time for Dodger Baseball!”](/setting-up-itfdb-with-a-voice.html). With the start of the 2019 season the mp3 stopped playing.

I tried all sorts of fixes. I made sure the Pi was up to date with `apt-get update` and `apt-get upgrade`. I thought maybe the issue was due to the version of Python running on the Pi (3.4.2). I thought maybe the mp3 had become corrupt and tried to regenerate it.

None of these things worked. Finally I found [this post](#) and the answer was so obvious. To quote the answer:

> Have you tried rebooting?
>
> It's a total shot in the dark, but I just transitioned from XBMC to omxplayer and lost sound. What I did:
>
> # apt-get remove xbmc
>
> # apt-get autoremove
>
> # apt-get update
>
> # apt-get upgrade
>
> After that I lost sound. 10 minutes of frustration later I rebooted and everything worked again.

It wasn’t exactly my problem, but upon seeing it I decided “What the hell?” And you know what, it totally worked.

I wish I would have checked to see when the last time a reboot had occurred, but it didn’t occur to me until I started writing this post. Oh well … it doesn’t really matter because it works now.
