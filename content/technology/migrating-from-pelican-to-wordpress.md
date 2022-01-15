Title: Migrating to Pelican from Wordpress
Date: 2021-07-02
Author: ryan
Tags: WordPress, Pelican
Series: Migrating to Pelican
Slug: migrating-to-pelican-from-wordpress
Status: published

## A little back story

In October of 2017 I [wrote about how I migrated from SquareSpace to Wordpress][1]. After almost 4 years I’ve decided to migrate again, this time to [Pelican][2]. I did a bit of work with Pelican during my [100 Days of Web Code][3] back in 2019.

A good question to ask is, “why migrate to a new platform” The answer, is that while writing my post [Debugging Setting up a Django Project][4] I had to go back and make a change. It was the first time I’d ever had to use the WordPress Admin to write anything ... and it was awful.

My writing and posting workflow involves [Ulysses][5] where I write everything in MarkDown. Having to use the WYSIWIG interface and the ‘blocks’ in WordPress just broke my brain. That meant what should have been a slight tweak ended up taking me like 45 minutes.

I decided to give Pelican a shot in a local environment to see how it worked. And it turned out to work very well for my brain and my writing style.

## Setting it up

I set up a local instance of Pelican using the [Quick Start][6] guide in the docs.

Pelican has a CLI utility that converts the xml into Markdown files. This allowed me to export my Wordpress blog content to it’s XML output and save it in the Pelican directory I created.

I then ran the command:

	pelican-import --wp-attach -o ./content ./wordpress.xml

This created about 140 .md files

Next, I ran a few `Pelican` commands to generate the output:

	pelican content

and then the local web server:

	pelican --listen

I reviewed the page and realized there was a bit of clean up that needed to be done. I had categories of Blog posts that only had 1 article, and were really just a different category that needed to be tagged appropriately. So, I made some updates to the categorization and tagging of the posts.

I also had some broken links I wanted to clean up so I took the opportunity to check the links on all of the pages and make fixes where needed. I used the library [LinkChecker][7] which made the process super easy. It is a CLI that generates HTML that you can then review. Pretty neat.

## Deploying to a test server

The first thing to do was to update my DNS for a new subdomain to point to my UAT server. I use Hover and so it was pretty easy to add the new entry.

I set uat.ryancheley.com to the IP Address 178.128.188.134

Next, in order to have UAT serve requests for my new site I need to have a configuration file for Nginx. This [post][8] gave me what I needed as a starting point for the config file. Specifically it gave me the location blocks I needed:

		location = / {
	        # Instead of handling the index, just
	        # rewrite / to /index.html
	        rewrite ^ /index.html;
	    }

	    location / {
	        # Serve a .gz version if it exists
	        gzip_static on;
	        # Try to serve the clean url version first
	        try_files $uri.htm $uri.html $uri =404;
	    }

With that in hand I deployed my pelican site to the server

The first thing I noticed was that the URLs still had `index.php` in them. This is a hold over from how my WordPress URL schemes were set up initially that I never got around to fixing but it’s always something that’s bothered me.

My blog may not be something that is linked to a ton (or at all?), but I didn’t want to break any links if I didn’t have to, so I decided to investigate Nginx rewrite rules.

I spent a bit of time trying to get my url to from this:

	https://www.ryancheley.com/index.php/2017/10/01/migrating-from-square-space-to-word-press/

to this:

	https://www.ryancheley.com/migrating-from-square-space-to-word-press/

using rewrite rules.

I gave up after several hours of trying different things. This did lead me to some awesome settings for Pelican that would allow me to retain the legacy Wordpress linking structure, so I updated the settings file to include this line:

	ARTICLE_URL = 'index.php/{date:%Y}/{date:%m}/{date:%d}/{slug}/'
	ARTICLE_SAVE_AS = 'index.php/{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'

OK. I still have the `index.php` issue, but at least my links won’t break.

### 404 Not Found

I starting testing the links on the site just kind of clicking here and there and discovered a couple of things:

1. The menu links didn’t always work
2. The 404 page wasn’t styled like I wanted it to me styled

The pelican documentation has an example for creating your own [404 pages][9] which also includes what to update the Nginx config file location block.

And this is what lead me to discover what I had been doing wrong for the rewrites earlier!

There are two location blocks in the example code I took, but I didn’t see how they were different.

The first location block is:

		location = / {
	        # Instead of handling the index, just
	        # rewrite / to /index.html
	        rewrite ^ /index.html;
	    }

Per the Nginx documentation the `=`

> > If an equal sign is used, this block will be considered a match if the request URI exactly matches the location given.

BUT since I was trying to use a regular expression, it wasn’t matching exactly and so it wasn’t ‘working’

The second location block was not an exact match (notice there is no `=` in the first line:

	location / {
	        # Serve a .gz version if it exists
	        gzip_static on;
	        # Try to serve the clean url version first
	        try_files $uri.htm $uri.html $uri =404;
	    }

When I added the error page setting for Pelican I also added the URL rewrite rules to remove the `index.php` and suddenly my dream of having the redirect rules worked!

Additionally, I didn’t need the first location block at all. The final location block looks like this:

	    location / {
	        # Serve a .gz version if it exists
	        gzip_static on;
	        # Try to serve the clean url version first
	        # try_files $uri.htm $uri.html $uri =404;
	        error_page 404 /404.html;
	        rewrite ^/index.php/(.*) /$1  permanent;
	    }

I was also able to update my Pelican settings to this:

	ARTICLE_URL = '{date:%Y}/{date:%m}/{date:%d}/{slug}/'
	ARTICLE_SAVE_AS = '{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'

Victory!

## What I hope to gain from moving

In my post outlining the move from SquareSpace to Wordpress I said,

> > As I wrote earlier my main reason for leaving Square Space was the difficulty I had getting content in. So, now that I’m on a WordPress site, what am I hoping to gain from it?

> > 1. Easier to post my writing
> > 2. See Item 1

> > Writing is already really hard for me. I struggle with it and making it difficult to get my stuff out into the world makes it that much harder. My hope is that not only will I write more, but that my writing will get better because I’m writing more.

So, what am I hoping to gain from this move:

1. Just as easy to write my posts
2. Easier to edit my posts

Writing is still hard for me (nearly 4 years later) and while moving to a new shiny tool won’t make the thinking about writing any easier, maybe it will make the process of writing a little more fun and that may lead to more words!

## Addendum

There are already a lot of words here and I have more to say on this. I plan on writing a couple of more posts about the migration:

1. Setting up the server to host Pelican
2. The writing workflow used


[1]:	https://www.ryancheley.com/2017/10/01/migrating-from-square-space-to-word-press/
[2]:	https://blog.getpelican.com
[3]:	https://www.ryancheley.com/2019/08/31/my-first-project-after-completing-the-100-days-of-web-in-python/
[4]:	https://www.ryancheley.com/2021/06/13/debugging-setting-up-a-django-project/
[5]:	https://ulysses.app
[6]:	https://docs.getpelican.com/en/latest/quickstart.html "Quick Start"
[7]:	https://pypi.org/project/LinkChecker/
[8]:	https://michael.lustfield.net/nginx/blog-with-pelican-and-nginx
[9]:	https://docs.getpelican.com/en/latest/tips.html?highlight=404#custom-404-pages
