Title: My First Python Package
Date: 2021-06-06 18:11
Author: ryan
Tags: datasette, Python, python package
Slug: my-first-python-package
Status: published

A few months ago I was inspired by [Simon Willison](https://simonwillison.net "Simon, creator of Datasette") and his project [Datasette](https://datasette.io "Datasette - An awesome tool for data exploration and publishing") and it’s related ecosystem to write a Python Package for it.

I use [toggl](https://toggl.com "Toggl - a time tracking tool") to track my time at work and I thought this would be a great opportunity use that data with [Datasette](https://datasette.io "Datasette - An awesome tool for data exploration and publishing") and see if I couldn’t answer some interesting questions, or at the very least, do some neat data discovery.

The purpose of this package is to:

> Create a SQLite database containing data from your [toggl](https://toggl.com "Toggl - a time tracking tool") account

I followed the [tutorial for committing a package to PyPi](https://packaging.python.org/tutorials/packaging-projects/ "How do I add a package to PyPi?") and did the first few pushes manually. Then, using a GitHub action from one of Simon’s [Datasette](https://datasette.io "Datasette - An awesome tool for data exploration and publishing") projects, I was able to automate it when I make a release on GitHub!

Since the initial commit on March 7 (my birthday BTW) I’ve had 10 releases, with the most recent one coming yesterday which removed an issue with one of the tables reporting back an API key which, if published on the internet could be a bad thing ... so hooray for security enhancements!

Anyway, it was a fun project, and got me more interested in authoring Python packages. I’m hoping to do a few more related to [Datasette](https://datasette.io) (although I’m not sure what to write honestly!).

Be sure to check out the package on [PyPi.org](https://pypi.org/project/toggl-to-sqlite/ "toggl-to-SQLite") and the source code on [GitHub](https://github.com/ryancheley/toggl-to-sqlite/ "GitHub repo of toggl-to-sqlite").
