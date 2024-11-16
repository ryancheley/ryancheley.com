Title: Migrating django-tailwind-cli to Django Commons
Date: 2024-11-19
Author: ryan
Tags: django, oss, django-commons
Slug: migrating-django-tailwind-cli-to-django-commons
Status: published

On Tuesday October 29 I worked with [Oliver Andrich](https://github.com/oliverandrich/), [Daniel Moran](https://github.com/cunla/) and [Storm Heg](https://github.com/Stormheg) to migrate Oliver's project [django-tailwind-cli](https://github.com/django-commons/django-tailwind-cli) from Oliver's GitHub project to Django Commons.

This was the 5th library that has been migrated over, but the first one that I 'lead'. I was a bit nervous. The Django Commons docs are great and super helpful, but the first time you do something, it can be nerve wracking.

One thing that was super helpful was knowing that Daniel and Storm were there to help me out when any issues came up.

The first set up steps are pretty straight forward and we were able to get through them pretty quickly. Then we ran into an issue that none of us had seen previously.

`django-tailwind-cli` had initially set up GitHub Pages set up for the docs, but migrated to use [Read the Docs](https://about.readthedocs.com/). However, the GitHub pages were still set in the repo so when we tried to migrate them over we ran into an error. Apparently you can't remove GitHub pages using Terraform (the process that we use to manage the organization).

We spent a few minutes trying to parse the error, make some changes, and try again (and again) and we were able to finally successfully get the migration completed 🎉

Some other things that came up during the migration was a maintainer that was set in the front end, but not in the terraform file. Also, while I was making changes to the Terraform file locally I ran into an issue with an update that had been done in the GitHub UI on my branch which caused a conflict for me locally.

I've had to deal with this kind of thing before, but ... never with an audience! Trying to work through the issue was a bit stressful to say the least 😅

But, with the help of Daniel and Storm I was able to resolve the conflicts and get the code pushed up.

As of this writing we have [6 libraries](https://github.com/orgs/django-commons/repositories?type=source&q=language%3APython+-topic%3Atemplate) that are part of the Django Commons organization and am really excited for the next time that I get to lead a migration. Who knows, at some point I might actually be able to do one on my own ... although our hope is that this can be automated much more ... so maybe that's what I can work on next

Working on a project like this has been really great. There are such great opportunities to learn various technologies (terraform, GitHub Actions, git) and getting to work with great collaborators.

What I'm hoping to be able to work on this coming weekend is[ref]Now will I actually be able to 🤷🏻[/ref]:

1. Get a better understanding of Terraform and how to use it with GitHub
2. Use Terraform to do something with GitHub Actions
3. Try and create a merge conflict and then use the git cli, or Git Tower, or VS Code to resolve the merge conflict

For number 3 in particular I want to have more comfort for fixing those kinds of issues so that if / when they come up again I can resolve them.
