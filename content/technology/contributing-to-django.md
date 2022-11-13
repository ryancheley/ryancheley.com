Title: Contributing to Django or how I learned to stop worrying and just try to fix an ORM Bug
Date: 2022-11-12
Author: ryan
Tags: django, open source
Slug: contributing-to-django
Status: published

I went to [DjangoCon US](https://2022.djangocon.us) a few weeks ago and [hung around for the sprints](https://twitter.com/pauloxnet/status/1583350887375773696). I was particularly interested in working on open tickets related to the ORM. It so happened that [Simon Charette](https://github.com/charettes) was at Django Con and was able to meet with several of us to talk through the inner working of the ORM.

With Simon helping to guide us, I took a stab at an open ticket and settled on [10070](https://code.djangoproject.com/ticket/10070). After reviewing it on my own, and then with Simon, it looked like it wasn't really a bug anymore, and so we agreed that I could mark it as [done](https://code.djangoproject.com/ticket/10070#comment:22).

Kind of anticlimactic given what I was **hoping** to achieve, but a closed ticket is a closed ticket! And so I [tweeted out my accomplishment](https://twitter.com/ryancheley/status/1583206004744867841) for all the world to see.

A few weeks later though, a [comment](https://code.djangoproject.com/ticket/10070#comment:22) was added that it actually was still a bug and it was reopened.

I was disappointed ... but I now had a chance to actually fix a real bug! [I started in earnest](https://github.com/ryancheley/public-notes/issues/1#issue-1428819941).

A suggestion / pattern for working through learning new things that [Simon Willison](https://simonwillison.net) had mentioned was having a `public-notes` repo on GitHub. He's had some great stuff that he's worked through that you can see [here](https://github.com/simonw/public-notes/issues?q=is%3Aissue).

Using this as a starting point, I decided to [walk through what I learned while working on this open ticket](https://github.com/ryancheley/public-notes/issues/1).

Over the course of 10 days I had a 38 comment 'conversation with myself' and it was **super** helpful!

A couple of key takeaways from working on this issue:

- [Carlton Gibson](https://github.com/carltongibson) [said](https://overcast.fm/+QkIrhujD0/21:00) essentially once you start working a ticket from  [Trac](https://code.djangoproject.com/), you are the world's foremost export on that ticket ... and he's right!
- ... But, you're not working the ticket alone! During the course of my work on the issue I had help from [Simon Charette](https://github.com/charettes), [Mariusz Felisiak](https://github.com/felixxm), [Nick Pope](https://github.com/ngnpope), and [Shai Berger](https://github.com/shaib)
- The ORM can seem big and scary ... but remember, it's *just* Python

I think that each of these lesson learned is important for anyone thinking of contributing to Django (or other open source projects).

That being said, the last point is one that I think can't be emphasized enough.

The ORM has a reputation for being this big black box that only 'really smart people' can understand and contribute to. But, it really is *just* Python.

If you're using Django, you know (more likely than not) a little bit of Python. Also, if you're using Django, and have written **any** models, you have a conceptual understanding of what SQL is trying to do (well enough I would argue) that you can get in there AND make sense of what is happening.

And if you know a little bit of Python a great way to learn more is to get into a project like Django and try to fix a bug.

[My initial solution](https://code.djangoproject.com/ticket/10070#comment:27) isn't [the final one that got merged](https://github.com/django/django/pull/16243) ... it was a collaboration with 4 people, 2 of whom I've never met in real life, and the other 2 I only just met at DjangoCon US a few weeks before.

While working through this I learned just as much from the feedback on my code as I did from trying to solve the problem with my own code.

All of this is to say, contributing to open source can be hard, it can be scary, but honestly, I can't think of a better place to start than Django, and there are [lots of places to start](https://code.djangoproject.com/query?owner=nobody&status=assigned&status=new&col=id&col=summary&col=owner&col=status&col=component&col=type&col=version&desc=1&order=id).

And for those of you feeling a bit adventurous, there are plenty of [ORM](https://code.djangoproject.com/query?status=assigned&status=new&owner=nobody&component=Database+layer+(models%2C+ORM)&col=id&col=summary&col=status&col=component&col=owner&col=type&col=version&desc=1&order=id) tickets just waiting for you to try and fix them!
