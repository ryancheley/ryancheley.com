Title: Issues with psycopg2 … again
Date: 2020-05-03 14:00
Author: ryan
Category: Python
Tags: package, python
Slug: issues-with-psycopg2-again
Status: published

In a [previous post](/mischief-managed/) I had written about an issue I’d had with upgrading, installing, or just generally maintaining the python package `psycopg2` ([link](https://www.psycopg.org)).

I ran into that issue again today, and thought to myself, “Hey, I’ve had this problem before AND wrote something up about it. Let me go see what I did last time.”

I searched my site for `psycopg2` and tried the solution, but I got the same [forking](https://thegoodplace.fandom.com/wiki/Censored_Curse_Words) error.

OK … let’s turn to the experts on the internet.

After a while I came across [this](https://stackoverflow.com/questions/26288042/error-installing-psycopg2-library-not-found-for-lssl) article on StackOverflow but this [specific answer](https://stackoverflow.com/a/56146592) helped get me up and running.

A side effect of all of this is that I upgraded from Python 3.7.5 to Python 3.8.1. I also updated all of my brew packages, and basically did a lot of cleaning up that I had neglected.

Not how I expected to spend my morning, but productive nonetheless.
