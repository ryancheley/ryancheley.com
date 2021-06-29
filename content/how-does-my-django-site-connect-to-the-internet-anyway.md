Title: How does my Django site connect to the internet anyway?
Date: 2021-05-31 12:49
Author: ryan
Category: Technology
Tags: digital ocean, django, nginx
Slug: how-does-my-django-site-connect-to-the-internet-anyway
Status: published

I created a Django site to troll my cousin Barry who is a big [San Diego Padres](https://www.mlb.com/padres "San Diego Padres") fan. Their Shortstop is a guy called [Fernando Tatis Jr.](https://www.baseball-reference.com/players/t/tatisfe02.shtml "Fernando “Error Maker” Tatis Jr. ") and he’s really good. Like **really** good. He’s also young, and arrogant, and is everything an old dude like me doesn’t like about the ‘new generation’ of ball players that are changing the way the game is played.

In all honesty though, it’s fun to watch him play (anyone but the Dodgers).

The thing about him though, is that while he’s really good at the plate, he’s less good at playing defense. He currently leads the league in errors. Not just for all shortstops, but for ALL players!

Anyway, back to the point. I made this Django site call [Does Tatis Jr Have an Error Today?](https://www.doestatisjrhaveanerrortoday.com "Not Yet")It is a simple site that only does one thing ... tells you if Tatis Jr has made an error today. If he hasn’t, then it says `No`, and if he has, then it says `Yes`.

It’s a dumb site that doesn’t do anything else. At all.

But, what it did do was lead me down a path to answer the question, “How does my site connect to the internet anyway?”

Seems like a simple enough question to answer, and it is, but it wasn’t really what I thought when I started.

## How it works

I use a MacBook Pro to work on the code. I then deploy it to a Digital Ocean server using GitHub Actions. But they say, a picture is worth a thousand words, so here's a chart of the workflow:

![Workflow](https://raw.githubusercontent.com/ryancheley/tatis/main/custom_resources/workflow.png)

This shows the development cycle, but that doesn’t answer the question, how does the site connect to the internet!

How is it that when I go to the site, I see anything? I thought I understood it, and when I tried to actually draw it out, turns out I didn't!

After a bit of Googling, I found [this](https://serverfault.com/a/331263 "How does Gunicorn interact with NgInx?") and it helped me to create this:

![](https://raw.githubusercontent.com/ryancheley/tatis/main/custom_resources/internal_working.png)

My site runs on an Ubuntu 18.04 server using Nginx as proxy server. Nginx determines if the request is for a static asset (a css file for example) or dynamic one (something served up by the Django App, like answering if Tatis Jr. has an error today).

If the request is static, then Nginx just gets the static data and server it. If it’s dynamic data it hands off the request to Gunicorn which then interacts with the Django App.

So, what actually handles the HTTP request? From the [serverfault.com answer above](https://serverfault.com/a/331263):

> \[T\]he simple answer is Gunicorn. The complete answer is both Nginx and Gunicorn handle the request. Basically, Nginx will receive the request and if it's a dynamic request (generally based on URL patterns) then it will give that request to Gunicorn, which will process it, and then return a response to Nginx which then forwards the response back to the original client.

In my head, I thought that Nginx was ONLY there to handle the static requests (and it is) but I wasn’t clean on how dynamic requests were handled ... but drawing this out really made me stop and ask, “Wait, how DOES that actually work?”

Now I know, and hopefully you do to!

## Notes:

These diagrams are generated using the amazing library [Diagrams](https://github.com/mingrammer/diagrams "Diagrams"). The code used to generate them is [here](https://github.com/ryancheley/tatis/blob/main/generate_diagram.py).
