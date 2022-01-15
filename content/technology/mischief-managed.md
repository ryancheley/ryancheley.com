Title: Mischief Managed
Date: 2020-02-10 05:36
Author: ryan
Tags: PyCharm, python, macOS
Slug: mischief-managed
Status: published

A few weeks back I decided to try and update my Python version with Homebrew. I had already been through an issue where the an update like this was going to cause an issue, but I also knew what the fix [was](/fixing-a-pycharm-issue-when-updating-python-made-via-homebrew/ "Homebrew and PyCharm don’t mix").

With this knowledge in hand I happily performed the update. To my surprise, 2 things happened:

1.  The update seemed to have me go from Python 3.7.6 to 3.7.3
2.  When trying to reestablish my `Virtual Environment` two packages wouldn’t installed: `psycopg2` and `django-heroku`

Now, the update/backdate isn’t the end of the world. Quite honestly, next weekend I’m going to just ditch homebrew and go with the standard download from [Python.org](https://www.python.org "Python") because I’m hoping that this non-sense won’t be an issue anymore

The second issue was a bit more irritating though. I spent several hours trying to figure out what the problem was, only to find out, there wasn’t one really.

The ‘fix’ to the issue was to

1.  Open PyCharm
2.  Go to Setting
3.  Go to ‘Project Interpreter’
4.  Click the ‘+’ to add a package
5.  Look for the package that wouldn’t install
6.  Click ‘Install Package’
7.  Viola ... [mischief managed](https://www.hp-lexicon.org/magic/mischief-managed/)

The next time this happens I’m just buying a new computer
