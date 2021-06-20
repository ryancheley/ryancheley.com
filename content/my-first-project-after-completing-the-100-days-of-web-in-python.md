Title: My first project after completing the 100 Days of Web in Python
Date: 2019-08-31 14:14
Author: ryan
Category: Django
Tags: django, Heroku, Stadia Tracker
Slug: my-first-project-after-completing-the-100-days-of-web-in-python
Status: published

As I mentioned in my last post, after completing the 100 Days of Web in Python I was moving forward with a Django app I wrote.

I pushed up my first version to Heroku on August 24. At that point it would allow users to add a game that they had seen, but when it disaplyed the games it would show a number (the game’s ID) instead of anything useful.

A few nights ago (Aug 28) I committed a version which allows the user to see which game they add, i.e. there are actual human readable details versus just a number!

The page can be found [here](https://www.stadiatracker.com). It feels really good to have it up in a place where people can actually see it. That being said I discovered a a couple of things on the publish that I’d like to fix.

I have a method that returns details about the game. One problem is that if any of the elements return `None` then the front page returns a Server 500 error ... this is not good.

It took a bit of googling to see what the issue was. The way I found the answer was to see an idea to turn Debug to True on my ‘prod’ server and see the output. That helped me identify the issue.

To ‘fix’ it in the short term I just deleted all of the data for the games seen in the database.

I’m glad that it happened because it taught me some stuff that I knew I needed to do, but maybe didn’t pay enough attention to ... like writing unit tests.

Based on that experience I wrote out a roadmap of sorts for the updates I want to get into the app:

-   Tests for all classes and methods
-   Ability to add minor league games
-   Create a Stadium Listing View
-   More robust search tool that allows a single team to be selected
-   Logged in user view for only their games
-   Create a List View of games logged per stadium
-   Create a List View of attendees (i.e. users) at games logged
-   Add more user features:
    -   Ability to add a picture
    -   Ability to add Twitter handle
    -   Ability to add Instagram handle
    -   Ability to add game notes
-   Create a Heroku Pipeline to ensure that pushes to PROD are done through a UAT site
-   Create a blog (as a pelican standalone sub domain)

It’s a lot of things but I’ve already done some things that I wanted to:

-   Added SSL
-   Set up to go to actual domain instead of Heroku subdomain

I’ll write up how I did the set up for the site so I can do it again. It’s not well documented when your registrar is Hover and you’ve got your site on Heroku. Man ... it was an tough.
