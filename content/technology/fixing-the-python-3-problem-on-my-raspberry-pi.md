Title: Fixing the Python 3 Problem on my Raspberry Pi
Date: 2018-02-13 21:00
Author: ryan
Tags: linux, python, unlink, Python
Slug: fixing-the-python-3-problem-on-my-raspberry-pi
Status: published

In my last post I indicated that I may need to

> reinstalling everything on the Pi and starting from scratch

While speaking about my issues with `pip3` and `python3`. Turns out that the fix was easier than I though. I checked to see what where `pip3` and `python3` where being executed from by running the `which` command.

The `which pip3` returned `/usr/local/bin/pip3` while `which python3` returned `/usr/local/bin/python3`. This is exactly what was causing my problem.

To verify what version of python was running, I checked `python3 --version` and it returned `3.6.0`.

To fix it I just ran these commands to *unlink* the new, broken versions:

`sudo unlink /usr/local/bin/pip3`

And

`sudo unlink /usr/local/bin/python3`

I found this answer on [StackOverflow](https://stackoverflow.com/questions/7679674/changing-default-python-to-another-version "Of Course the answer was on Stack Overflow!") and tweaked it slightly for my needs.

Now, when I run `python --version` I get `3.4.2` instead of `3.6.0`

Unfortunately I didn’t think to run the `--version` flag on pip before and after the change, and I’m hesitant to do it now as it’s back to working.
