Title: Upgrading Python in a Virtual Environment
Date: 2019-04-25 05:05
Author: ryan
Category: Technology
Tags: Heroku, PyCharm, venv, Virtual Environment, Python
Slug: upgrading-python-in-a-virtual-environment
Status: published

I have been wanting to use my Heroku account for a while with something a little more interesting than a [Jupiter Notebook](https://ryan-jupyter.herokuapp.com).

I was hoping to try and do something with Django … but there’s a lot to using Django. I have some interesting things I’m doing on my local machine, but it’s not quite ready yet.

I had googled to find other Python Web frameworks and saw that Bottle was an even more light weight framework than Flask, so I thought, hey, maybe I can do something with that.

I found [this](https://github.com/chucknado/bottle_heroku_tutorial/blob/master/README.md#reqs) tutorial on how to do something relatively simple with Bottle and deploying to Heroku. Just what I wanted!

I got through to the end of the tutorial and deployed to Heroku. The terminal output from the Heroku command indicated that a newer version of Python (3.7.3) was available than the one I was on (3.7.1).

I figured it would be easy enough to upgrade to the newest version of Python on my Mac because I had done it [before](/keeping-python-up-to-date-on-macos.html).

I don’t know why I thought the virtual environment would be different than the local install of Python 3 but it turns out they are more tightly coupled than I thought.

Upgrading to 3.7.3 broke the virtual environment I had in PyCharm. I did a bit a googling to see how to upgrade a virtual environment and found nothing. Like literally nothing.

It was ... disheartening. But after a good night’s sleep I had a thought! What if I just delete the virtual environment directory and then recreated it.

I ran this command to remove the virtual environment:

    rm -R venv

Then created a virtual environment in PyCharm and now I have 3.7.3 in my virtual environment.

I had to make some changes to the files for deployment to Heroku, but that’s all covered in the tutorial mentioned above.

Sometimes the answer is to [just restart it](/did-you-try-restarting-it.html) … and sometimes the answer is delete it and start over.

## Update

I was listening to an [episode of Python Bytes](https://overcast.fm/+HjKUtfFUQ/13:45) and heard [Michael Kennedy](https://mobile.twitter.com/mkennedy) (of [Talk Python to Me](https://talkpython.fm/home) fame) describing basically the same issue I had. Turns out, he solved it the same way I did. Nice to know i’m In good company.
