Title: Adding my Raspberry Pi Project code to GitHub
Date: 2018-11-25 19:30
Author: ryan
Tags: Raspberry Pi, version control, GitHub, hummingbird
Slug: adding-my-raspberry-pi-project-code-to-github
Status: published

Over the long holiday weekend I had the opportunity to play around a bit with some of my Raspberry Pi scripts and try to do some fine tuning.

I mostly failed in getting anything to run better, but I did discover that not having my code in version control was a bad idea. (Duh)

I spent the better part of an hour trying to find a script that I had accidentally deleted somewhere in my blog. Turns out it was (mostly) there, but it didn’t ‘feel’ right … though I’m not sure why.

I was able to restore the file from my blog archive, but I decided that was a dumb way to live and given that

1.  I use version control at work (and have for the last 15 years)
2.  I’ve used it for other personal projects

However, I’ve only ever used a GUI version of either subversion (at work) or GitHub (for personal projects via PyCharm). I’ve never used it from the command line.

And so, with a bit of time on my hands I dove in to see what needed to be done.

Turns out, not much. I used this [GitHub](https://help.github.com/articles/adding-an-existing-project-to-github-using-the-command-line/) resource to get me what I needed. Only a couple of commands and I was in business.

The problem is that I have a terrible memory and this isn’t something I’m going to do very often. So, I decided to write a bash script to encapsulate all of the commands and help me out a bit.

The script looks like this:

    echo "Enter your commit message:"

    read commit_msg

    git commit -m "$commit_msg"

    git remote add origin path/to/repository

    git remote -v

    git push -u origin master

    git add $1

    echo ”enter your commit message:”

    read commit_msg

    git commit -m ”$commit_msg”

    git push

I just recently learned about user input in bash scripts and was really excited about the opportunity to be able to use it. Turns out it didn’t take long to try it out! (God I love learning things!)

What the script does is commits the files that have been changed (all of them), adds it to the origin on the GitHub repo that has been specified, prints verbose logging to the screen (so I can tell what I’ve messed up if it happens) and then pushes the changes to the master.

This script doesn’t allow you to specify what files to commit, nor does it allow for branching and tagging … but I don’t need those (yet).

I added this script to 3 of my projects, each of which can be found in the following GitHub Repos:

-   [rpicamera-hummingbird](https://github.com/ryancheley/rpicamera-hummingbird)
-   [rpi-dodgers](https://github.com/ryancheley/rpi-dodgers)
-   [rpi-kings](https://github.com/ryancheley/rpi-kings)

I had to make the commit.sh executable (with `chmod +x commit.sh`) but other than that it’s basically plug and play.

## Addendum

I made a change to my Kings script tonight (Nov 27) and it wouldn’t get pushed to git. After a bit of Googling and playing around, I determined that the original script would only push changes to an empty repo ... not one with stuff, like I had.  Changes made to the post (and the GitHub repo!)
