Title: Upgrading to PostgreSQL 14
Date: 2022-08-28
Author: ryan
Tags: postgres
Slug: upgrading-to-postgresql-14
Status: published

[Django 4.1 was released on August 3, 2022](https://docs.djangoproject.com/en/4.1/releases/4.1/) and I was excited to upgrade to it. I did the testing locally and then pushed my changes up to GitHub to deploy. The deployment was succesful, but when I went to visit my sites ... womp womp. I got a Server Error 5XX.

What happened? Well, it turns out that Django 4.1 [dropped support for Postgres 10](https://docs.djangoproject.com/en/4.1/releases/4.1/#dropped-support-for-postgresql-10) and that just so happens to be the version I was running on my production server (but not on my local dev machine ... I was running Postgres 14).

OK, so I am going to need to upgrade in order to get the features of anything above Django 4.0 ... and honestly, I've needed to upgrade past Postgres 10 for a [while](https://www.ryancheley.com/2021/07/09/contributing-to-django-sql-dashboard/).

I found [this StackOverflow question and answer](https://stackoverflow.com/questions/60409585/how-to-upgrade-postgresql-database-from-10-to-12-without-losing-data-for-openpro) and it helped me a ton! It was to upgrade from Psotgres 10 to 12, but the ideas were the same (but replace 12 with 14). There is also a step that indicates you need to run `./analyze_new_cluster.sh` but that seems to be only for version 12(maybe 13) and lower.

Everything was fine until I visited my site and got a Server Error 5XX AGAIN!

What gives?

My first assumption was that maybe the postgres server didn't start back up properly after the upgrade. I checked the service to verify that it was running, and it was

```
ps -aux | grep postgres
```

which returned

```
postgres   988  0.0  1.3 321668 27588 ?        Ss   16:55   0:01 /usr/lib/postgresql/14/bin/postgres -D /var/lib/postgresql/14/main -c config_file=/etc/postgresql/14/main/postgresql.conf
postgres  1034  0.0  0.2 321788  6112 ?        Ss   16:55   0:00 postgres: 14/main: checkpointer
postgres  1035  0.0  0.2 321800  5996 ?        Ss   16:55   0:00 postgres: 14/main: background writer
postgres  1036  0.0  0.4 321668  9388 ?        Ss   16:55   0:00 postgres: 14/main: walwriter
postgres  1039  0.0  0.3 322356  8080 ?        Ss   16:55   0:00 postgres: 14/main: autovacuum launcher
postgres  1040  0.0  0.2 176828  5108 ?        Ss   16:55   0:00 postgres: 14/main: stats collector
postgres  1041  0.0  0.3 322224  6628 ?        Ss   16:55   0:00 postgres: 14/main: logical replication launcher
root      4868  0.0  0.0  14860  1072 pts/0    S+   18:47   0:00 grep --color=auto postgres
```

I also checked

```
systemctl status postgresql
```

which returned as expected

```
● postgresql.service - PostgreSQL RDBMS
   Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor preset: enabled)
   Active: active (exited) since Sun 2022-08-28 16:55:32 UTC; 1h 54min ago
  Process: 1169 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
 Main PID: 1169 (code=exited, status=0/SUCCESS)

Aug 28 16:55:32 server-name systemd[1]: Starting PostgreSQL RDBMS...
Aug 28 16:55:32 server-name systemd[1]: Started PostgreSQL RDBMS.
```

One last thing to try

```
python manage.py makemigrations
```

This gave me a hint as to what the issue was:

```
RuntimeWarning: Got an error checking a consistent migration history performed for database connection 'default': connection to server at "127.0.0.1", port 5432 failed: FATAL:  password authentication failed for user "user" connection to server at "127.0.0.1", port 5432 failed: FATAL:
```

Hmmm ... a quick google search doesn't specifically answer it, but it helps me to get the to answer.

The 'user' isn't able to connect to the database. Maybe the upgrade process resets the password of users in the database or it just doesn't keep the users.

A quick look at the users on the database showed me that the users were still there, so the only thing left to do at this point was to set the user passwords to be what my settings are expecting.

To do that I ran

```psql
ALTER USER user WITH PASSWORD 'password';
```

I did this for the databases that were associated with my websites that were returning 5XX errors and voila! That fixed the issue.

I'm sure that there is a way to keep the passwords for the users after the upgrade, but I haven't been able to find it.

The next time I need to upgrade PostgreSQL I am going to refer back to this post to remind myself what I did last time 😀
