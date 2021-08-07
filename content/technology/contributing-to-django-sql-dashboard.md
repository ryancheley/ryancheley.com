Title: Contributing to django-sql-dashboard
Date: 2021-07-09
Tags: oss, contributing, Django
Slug: contributing-to-django-sql-dashboard
Author: ryan
Draft: True

Last Saturday (July 3rd) while on vacation, I dubbed it “Security update Saturday”. I took the opportunity to review all of the GitHub bot alerts about out of date packages, and make the updates I needed to. 

This included updated `django-sql-dashboard` to [version 1.0][1] … which I was really excited about doing. It included two things I was eager to see:

1. Implemented a new column cog menu, with options for sorting, counting distinct items and counting by values. [\#57][2]
2. Admin change list view now only shows dashboards the user has permission to edit. Thanks, [Atul Varma][3]. [\#130][4]

I made the updates on my site StadiaTracker.com using my normal workflow:

1. Make the change locally on my MacBook Pro
2. Run the tests
3. Push to UAT
4. Push to PROD

The next day, on July 4th, I got the following error message via my error logging:

	Internal Server Error: /dashboard/games-seen-in-person/
	
	ProgrammingError at /dashboard/games-seen-in-person/
	could not find array type for data type information_schema.sql_identifier

So I copied the [url][5] `/dashboard/games-seen-in-person/` to see if I could replicate the issue as an authenticated user and sure enough, I got a 500 Server error. 

## Troubleshooting process

The first thing I did was to fire up the local version and check the url there. Oddly enough, it worked without issue. 

OK … well that’s odd. What are the differences between the local version and the uat / prod version? 

The local version is running on macOS 10.15.7 while the uat / prod versions are running Ubuntu 18.04. That could be one source of the issue. 

The local version is running Postgres 13.2 while the uat / prod versions are running Postgres 10.17

OK, two differences. Since the error is `could not find array type for data type information_schema.sql_identifier` I’m going to start with taking a look at the differences on the Postgres versions.

First, I looked at the [Change Log][6] to see what changed between version 0.16 and version 1.0. Nothing jumped out at me, so I looked at the [diff][7] between several files between the two versions looking specifically for `information_schema.sql_identifier` which didn’t bring up anything. 

Next I checked for either `information_schema` or `sql_identifier` and found a chance in the `views.py` file. On line 151 (version 0.16) this change was made:

	string_agg(column_name, ', ' order by ordinal_position) as columns

to this:

	array_to_json(array_agg(column_name order by ordinal_position)) as columns

Next, I extracted the entire SQL statement from the `views.py` file to run in Postgres on the UAT server

	            with visible_tables as (
	              select table_name
	                from information_schema.tables
	                where table_schema = 'public'
	                order by table_name
	            ),
	            reserved_keywords as (
	              select word
	                from pg_get_keywords()
	                where catcode = 'R'
	            )
	            select
	              information_schema.columns.table_name,
	              array_to_json(array_agg(column_name order by ordinal_position)) as columns
	            from
	              information_schema.columns
	            join
	              visible_tables on
	              information_schema.columns.table_name = visible_tables.table_name
	            where
	              information_schema.columns.table_schema = 'public'
	            group by
	              information_schema.columns.table_name
	            order by
	              information_schema.columns.table_name

Running this generated the same error I was seeing from the logs! 

Next, I picked apart the various select statements, testing each one to see what failed, and ended on this one:

	select information_schema.columns.table_name,
	array_to_json(array_agg(column_name order by ordinal_position)) as columns
	from information_schema.columns

Which generated the same error message. Great! 

In order to determine how to proceed next I googled `sql_identifier` to see what it was. Turns out it’s a field type in Postgres! (I’ve been working in MSSQL for more than 10 years and as far as I know, this isn’t a field type over there, so I learned something)

Further, there were [changes made to that field type in Postgres 12][8]! 

OK, since there were changes made to that afield type in Postgres 12, I’ll probably need to cast the field to another field type that won’t fail. 

That led me to try this:

	select information_schema.columns.table_name,
	array_to_json(array_agg(cast(column_name as text) order by ordinal_position)) as columns
	from information_schema.columns

Which returned a value without error! 

## Submitting the updated code

With the solution in hand, I read the [Contribution Guide][9] and submitting my patch. And the most awesome part? Within less than an hour Simon Willison (the project’s maintainer) had replied back and merged by code! 

And then, the icing on the cake was getting a [shout out in a post that Simon wrote][10] up about the update that I submitted! 

Holy smokes that was sooo cool. 

I love solving problems, and I love writing code, so this kind of stuff just really makes my day. 

Now, I’ve contributed to an open source project (that makes 3 now!) and the issue with the `/dashboard/` has been fixed. 

All

[1]:	https://github.com/simonw/django-sql-dashboard/releases/tag/1.0
[2]:	https://github.com/simonw/django-sql-dashboard/issues/57
[3]:	https://github.com/atverma
[4]:	https://github.com/simonw/django-sql-dashboard/issues/130
[5]:	https://stadiatracker.com/dashboard/games-seen-in-person/
[6]:	https://github.com/simonw/django-sql-dashboard/releases
[7]:	https://github.com/simonw/django-sql-dashboard/compare/acb3752..b8835
[8]:	https://bucardo.org/postgres_all_versions#version_12.0
[9]:	https://github.com/simonw/django-sql-dashboard/blob/main/docs/contributing.md
[10]:	https://simonwillison.net/2021/Jul/6/django-sql-dashboard/