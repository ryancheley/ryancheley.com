Title: Setting up Jupyter Notebook on my Linode
Date: 2018-05-27 12:32
Author: ryan
Category: Python
Tags: jupyter, linux, python, Remote servers, Shell Script
Slug: setting-up-jupyter-notebook-on-my-linode
Status: published

A [Jupyter Notebook](http://jupyter.org) is an open-source web application that allows you to create and share documents that contain live code, equations, visualizations and narrative text.

Uses include:

1.  data cleaning and transformation
2.  numerical simulation
3.  statistical modeling
4.  data visualization
5.  machine learning
6.  and other stuff

I’ve been interested in how to set up a Jupyter Notebook on my [Linode](https://www.linode.com) server for a while, but kept running into a roadblock (either mental or technical I’m not really sure).

Then I came across this ‘sweet’ solution to get them set up at<http://blog.lerner.co.il/five-minute-guide-setting-jupyter-notebook-server/>

My main issue was what I needed to to do keep the Jupyter Notebook running once I disconnected from command line. The solution above gave me what I needed to solve that problem

    nohup jupyter notebook

`nohup` allows you to disconnect from the terminal but keeps the command running in the background (which is exactly what I wanted).

The next thing I wanted to do was to have the `jupyter` notebook server run from a directory that wasn’t my home directory.

To do this was way easier than I thought. You just run `nohup jupyter notebook` from the directory you want to run it from.

The last thing to do was to make sure that the notebook would start up with a server reboot. For that I wrote a shell script

    # change to correct directory
    cd /home/ryan/jupyter

    nohup jupyter notebook &> /home/ryan/output.log

The last command is a slight modification of the line from above. I really wanted the output to get directed to a file that wasn’t in the directory that the `Jupyter` notebook would be running from. Not any reason (that I know of anyway) … I just didn’t like the `nohup.out` file in the working directory.

Anyway, I now have a running Jupyter Notebook at <http://python.ryancheley.com:8888>^[1](#fn1){#ffn1 .footnote}^

1.  [I’d like to update this to be running from a port other than 8888 AND I’d like to have it on SSL, but one thing at a time! [↩](#ffn1)]{#fn1}
