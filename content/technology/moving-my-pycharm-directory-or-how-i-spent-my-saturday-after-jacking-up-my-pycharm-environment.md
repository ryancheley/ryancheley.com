Title: Moving my Pycharm Directory or How I spent my Saturday after jacking up my PyCharm environment
Date: 2018-08-12 15:00
Author: ryan
Tags: MacBook Pro, python, macOS
Slug: moving-my-pycharm-directory-or-how-i-spent-my-saturday-after-jacking-up-my-pycharm-environment
Status: published

Every once in a while I get a wild hair and decide that I need to ‘clean up’ my directories. This **never** ends well and I almost always mess up something, but I still do it.

Why? I’m not sure, except that I *forget* that I’ll screw it up. 🤦‍♂️

Anyway, on a Saturday morning when I had nothing but time I decided that I’d move my PyCharm directory from /Users/ryan/PyCharm to /Users/ryan/Documents/PyCharm for no other reason than **because**.

I proceeded to use the command line to move the folder

    mv /Users/ryan/PyCharm/ /Users/ryan/Documents/PyCharm/

Nothing too big, right. Just a simple file movement.

Not so much. I then tried to open a project in PyCharm and it promptly freaked out. Since I use virtual environments for my Python Project AND they tend to have paths that reference where they exist, suddenly ALL of my virtual environments were kind of just *gone*.

Whoops!

OK. No big deal. I just undid my move

    mv /Users/ryan/Documents/PyCharm/ /Users/ryan/PyCharm

That should fix me up, right?

Well, mostly. I had to re-register the virtual environments and reinstall all of the packages in my projects (mostly not a big deal with PyCharm) but holy crap it was scary. I thought I had hosed my entire set of projects (not that I have anything that’s critical … but still).

Anyway, this is mostly a note to myself.

> > The next time you get a wild hair to move stuff around, just keep it where it is. There’s no reason for it (unless there is).

But seriously, ask yourself first, “If I don’t move this what will happen?” If the answer is anything less than “Something awful” go watch a baseball game, or go to the pool, or write some code. Don’t mess with your environment unless you really want to spend a couple of hours unmasking it up!
