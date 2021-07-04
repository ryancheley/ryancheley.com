Title: Deploying a Django Site to Digital Ocean - A Series
Date: 2021-01-24 12:00
Author: ryan
Tags: Deployment
Series: Deploying your Django App to Digital Ocean
Slug: deploying-a-django-site-to-digital-ocean-a-series
Status: published

## Previous Efforts

When I first heard of Django I thought it looks like a really interesting, and Pythonic way, to get a website up and running. I spent a whole weekend putting together a site locally and then, using Digital Ocean, decided to push my idea up onto a live site.

One problem that I ran into, which EVERY new Django Developer will run into was static files. I couldn’t get static files to work. No matter what I did, they were just … missing. I proceeded to spend the next few weekends trying to figure out why, but alas, I was not very good (or patient) with reading documentation and gave up.

Fast forward a few years, and while taking the 100 Days of Code on the Web Python course from Talk Python to Me I was able to follow along on a part of the course that pushed up a Django App to Heroku.

I wrote about that effort [here](https://pybit.es/my-first-django-app.html). Needless to say, I was pretty pumped. But, I was wondering, is there a way I can actually get a Django site to work on a non-Heroku (PaaS) type infrastructure.

## Inspiration

While going through my Twitter timeline I cam across a retweet from TestDrive.io of [Matt Segal](https://mattsegal.dev/simple-django-deployment.html). He has an **amazing** walk through of deploying a Django site on the hard level (i.e. using Windows). It’s a mix of Blog posts and YouTube Videos and I highly recommend it. There is some NSFW language, BUT if you can get past that (and I can) it’s a great resource.

This series is meant to be a written record of what I did to implement these recommendations and suggestions, and then to push myself a bit further to expand the complexity of the app.

## Articles

A list of the Articles will go here. For now, here’s a rough outline of the planned posts:

-   [Setting up the Server (on Digital Ocean)](/setting-up-the-server-on-digital-ocean.html)
-   [Getting your Domain to point to Digital Ocean Your Server](/getting-your-domain-to-point-to-digital-ocean-your-server.html)
-   [Preparing the code for deployment to Digital Ocean](/preparing-the-code-for-deployment-to-digital-ocean.html)
-   [Automating the deployment](/automating-the-deployment.html)
-   Enhancements  

The ‘Enhancements’ will be multiple follow up posts (hopefully) as I catalog improvements make to the site. My currently planned enhancements are:

-   Creating the App
-   [Migrating from SQLite to Postgres](/using-postgresql.html)
-   Integrating Git
-   [Having Multiple Sites on a single Server](/setting-up-multiple-django-sites-on-a-digital-ocean-server.html)
-   Adding Caching
-   Integrating S3 on AWS to store Static Files and Media Files
-   Migrate to Docker / Kubernetes  
