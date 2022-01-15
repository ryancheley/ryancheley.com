Title: Prototyping with Datasette
Date: 2021-08-09 18:26
Tags: Datasette
Slug: prototyping-with-datasette
Authors: ryan

At my job I work with some really talented Web Developers that are saddled with a pretty creaky legacy system.

We're getting ready to start on a new(ish) project where we'll be taking an old project built on this creaky legacy system (`VB.net`) and re-implementing it on a `C#` backend and an `Angular` front end. We'll be working on a lot of new features and integrations so it's worth rebuilding it versus shoehorning the new requirements into the legacy system.

The details of the project aren't really important. What is important is that as I was reviewing the requirements with the Web Developer Supervisor he said something to the effect of, "We can create a proof of concept and just hard code the data in a json file to fake th backend."

The issue is ... we already have the data that we'll need in a MS SQL database (it's what is running the legacy version) it's just a matter of getting it into the right json "shape".

Creating a 'fake' json object that kind of/maybe mimics the real data is something we've done before, and it ALWAYS seems to bite us in the butt. We don't account for proper pagination, or the real lengths of data in the fields or NULL values or whatever shenanigans happen to befall real world data!

This got me thinking about [Simon Willison](https://simonwillison.net)'s project [Datasette](https://datasette.io) and using it to prototype the API end points we would need.

I had been trying to figure out how to use the `db-to-sqlite` to extract data from a MS SQL database into a SQLite database and was successful (see my PR to `db-to-sqlite` [here](https://github.com/ryancheley/db-to-sqlite/tree/ryancheley-patch-1-document-updates#using-db-to-sqlite-with-ms-sql))

With this idea in hand, I reviewed it with the Supervisor and then scheduled a call with the web developers to review `datasette`.

During this meeting, I wanted to review:

1. The motivation behind why we would want to use it
2. How we could leverage it to do [Rapid Prototying](https://datasette.io/for/rapid-prototyping)
3. Give a quick demo data from the stored procedure that did the current data return for the legacy project.

In all it took less than 10 minutes to go from nothing to a local instance of `datasette` running with a prototype JSON API for the web developers to see.

I'm hoping to see the Web team use this concept more going forward as I can see huge benefits for Rapid Prototyping of ideas, especially if you already have the data housed in a database. But even if you don't, `datasette` has tons of [tools](https://datasette.io/tools) to get the data from a variety of sources into a SQLite database to use and then you can do the rapid prototyping!
