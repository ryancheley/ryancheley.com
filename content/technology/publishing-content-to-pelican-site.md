Title: Publishing content to Pelican site
Date: 2021-07-07
Author: ryan
Tags: Pelican, Server
Series: Migrating to Pelican
Slug: publishing-content-to-pelican-site
Status: published

There are a lot of different ways to get the content for your Pelican site onto the internet. The [Docs show](https://docs.getpelican.com/en/latest/publish.html) an example using `rsync`.

For automation they talk about the use of either `Invoke` or `Make` (although you could also use [`Just`](https://github.com/casey/just) instead of `Make` which is my preferred command runner.)

I didn't go with any of these options, instaed opting to use GitHub Actions instead.

I have [two GitHub Actions](https://github.com/ryancheley/ryancheley.com/tree/main/.github/workflows) that will publish updated content. One action publishes to a UAT version of the site, and the other to the Production version of the site.

Why two actions you might ask?

Right now it's so that I can work through making my own theme and deploying it without disrupting the content on my production site. Also, it's a workflow that I'm pretty used to:

1. Local Development
2. Push to Development Branch on GitHub
3. Pull Request into Main on GitHub

It kind of complicates things right now, but I feel waaay more comfortable with having a UAT version of my site that I can just undo if I need to.

Below is the code for the [Prod Deployment](https://raw.githubusercontent.com/ryancheley/ryancheley.com/main/.github/workflows/publish.yml)

    #!yml
    name: Pelican Publish

    on:
    push:
        branches:
        - main

    jobs:
    deploy:
        runs-on: ubuntu-18.04
        steps:
        - name: deploy code
            uses: appleboy/ssh-action@v0.1.2
            with:
            host: ${{ secrets.SSH_HOST }}
            key: ${{ secrets.SSH_KEY }}
            username: ${{ secrets.SSH_USERNAME }}

            script: |
                rm -rf ryancheley.com
                git clone git@github.com:ryancheley/ryancheley.com.git

                source /home/ryancheley/venv/bin/activate

                cp -r ryancheley.com/* /home/ryancheley/

                cd /home/ryancheley

                pip install -r requirements.txt

                pelican content -s publishconf.py


Let's break it down a bit

Lines 3 - 6 are just indicating when the actually perform the actions in the lines below.

In line 13 I invoke the `appleboy/ssh-action@v0.1.2` which allows me to ssh into my server and then run some command line functions.

On line 20 I remove the folder where the code was previously cloned from, and in line 21 I run the `git clone` command to download the code

Line 23 I activate my virtual environemnt

Line 25 I copy the code from the cloned repo into the directory of my site

Line 27 I change directory into the source for the site

Line 29 I make any updates to requirements with `pip install`

Finally, in line 31 I run the command to publish the content (which takes my `.md` files and turns them into HTML files to be seen on the internet)
