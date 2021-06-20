Title: Fixing a PyCharm issue when updating Python made via HomeBrew
Date: 2019-11-14 13:24
Author: ryan
Category: Python
Tags: homebrew, macOS, techsupport
Slug: fixing-a-pycharm-issue-when-updating-python-made-via-homebrew
Status: published

I’ve written before about how easy it is to update your version of Python using homebrew. And it totally is easy.

The thing that isn’t super clear is that when you do update Python via Homebrew, it seems to break your virtual environments in PyCharm. 🤦‍♂️

I did a bit of searching to find this nice [post on the JetBrains forum](https://intellij-support.jetbrains.com/hc/en-us/community/posts/360000306410-Cannot-use-system-interpreter-in-PyCharm-Pro-2018-1) which indicated

> > unfortunately it's a known issue: <https://youtrack.jetbrains.com/issue/PY-27251> . Please close Pycharm and remove jdk.table.xml file from \~/Library/Preferences/.PyCharm2018.1/options directory, then start Pycharm again.

OK. I removed the file, but then you have to rebuild the virtual environments because that file is what stores PyCharms knowledge of those virtual environments.

In order to get you back to where you need to be, do the following (after removing the `jdk.table.xml` file:

1.  pip-freeze \> requirements.txt
2.  Remove old virtual environment `rm -r venv`
3.  Create a new Virtual Environemtn with PyCharm
    1.  Go to Preferences
    2.  Project \> Project Interpreter
    3.  Show All
    4.  Click ‘+’ button
4.  `pip install -r requirements.txt`
5.  Restart PyCharm
6.  You're back

This is a giant PITA but thankfully it didn’t take too much to find the issue, nor to fix it. With that being said, I totally shouldn’t have to do this. But I’m writing it down so that once Python 3.8 is available I’ll be able to remember what I did to fix going from Python 3.7.1 to 3.7.5.
