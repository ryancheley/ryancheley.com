Title: Django and Legacy Databases
Date: 2022-06-15
Author: ryan
Tags: django, mssql,
Slug: django-and-legacy-databases
Series: Django and Microsoft SQL Server
Status: published

I work at a place that is heavily investing in the Microsoft Tech Stack. Windows Servers, c#.Net, Angular, VB.net, Windows Work Stations, Microsoft SQL Server ... etc

When not at work, I **really** like working with Python and Django. I've never really thought I'd be able to combine the two until I discovered the package mssql-django which was released Feb 18, 2021 in alpha and as a full-fledged version 1 in late July of that same year.

Ever since then I've been trying to figure out how to incorporate Django into my work life.

I'm going to use this series as an outline of how I'm working through the process of getting Django to be useful at work. The issues I run into, and the solutions I'm (hopefully) able to achieve.

I'm also going to use this as a more in depth analysis of an accompanying talk I'm hoping to give at [Django Con 2022](https://2022.djangocon.us) later this year.

I'm going to break this down into a several part series that will roughly align with the talk I'm hoping to give. The parts will be:

1. Introduction/Background
2. Overview of the Project
3. Wiring up the Project Models
4. Database Routers
5. Django Admin Customization
6. Admin Documentation
7. Review & Resources

My intention is to publish one part every week or so. Sometimes the posts will come fast, and other times not. This will mostly be due to how well I'm doing with writing up my findings and/or getting screenshots that will work.

The tool set I'll be using is:

* docker
* docker-compose
* Django
* MS SQL
* SQLite
