Title: Installing the osmnx package for Python
Date: 2016-11-24 16:44
Author: ryan
Category: Python
Tags: osmnx, package, python
Slug: installing-the-osmnx-package-for-python
Status: published

I read about a cool gis package for Python and decided I wanted to play around with it. This post isn't about any of the things I've learned about the package, it's so I can remember how I installed it so I can do it again if I need to. The package is described by it's author in his [post](http://geoffboeing.com/2016/11/osmnx-python-street-networks/)

To install `osmnx` I needed to do the following:

1.  Install [Home Brew](http://geoffboeing.com/2016/11/osmnx-python-street-networks/) if it's not already installed by running this command (as an administrator) in the `terminal`:

    > > `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

2.  Use [Home Brew to install the `spatialindex` dependency](https://github.com/kjordahl/SciPy-Tutorial-2015/issues/1). From the `terminal` (again as an administrator):

    > > `brew install spatialindex`

3.  In python run pip to install `rtree`:

    > > `pip install rtree`

4.  In python run pip to install `osmnx`

    > > `pip install osmnx`

I did this on my 2014 iMac but didn't document the process. This lead to a problem when I tried to run some code on my 2012 MacBook Pro.

Step 3 may not be required, but I'm **not** sure and I don't want to not have it written down and then wonder why I can't get `osmnx` to install in 3 years when I try again!

Remember, you're not going to remember what you did, so you need to write it down!
