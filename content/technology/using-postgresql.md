Title: Using PostgreSQL
Date: 2021-02-28 12:00
Author: ryan
Tags: postgres, series
Slug: using-postgresql
Status: published

Once you’ve deployed your code to a web server, you’ll be pretty stoked. I know I was. One thing you’ll need to start thinking about though is converting your SQLite database to a ‘real’ database. I say ‘real’ because SQLite is a great engine to start off with, but once you have more than 1 user, you’ll really need to have a database that can support concurrency, and can scale when you need it to.

Enter PostgreSQL. Django offers built-in database support for several different databases, but Postgres is the preferred engine.

We’ll take care of this in stages:

1.  Create the database
2.  Prep project for use of Postgres
    1.  Install needed package
    2.  Update `settings.py` to change to Postgres
    3.  Run the migration locally
3.  Deploy updates to server
4.  Script it all out

## Create the database

I’m going to assume that you already have Postgres installed locally. If you don’t, there are many good tutorials to walk you through it.

You’ll need three things to create a database in Postgres

1.  Database name
2.  Database user
3.  Database password for your user

For this example, I’ll be as generic as possible and choose the following:

-   Database name will be `my_database`
-   Database user will be `my_database_user`
-   Database password will be `my_database_user_password`

From our terminal we’ll run a couple of commands:

``` {.wp-block-code}
# This will open the Postgres Shell

psql

# From the psql shell

CREATE DATABASE my_database;
CREATE USER my_database_user WITH PASSWORD 'my_database_user_password';
ALTER ROLE my_database_user SET client_encoding TO 'utf8';
ALTER ROLE my_database_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE my_database_user SET timezone TO 'UTC'
```

The last 3 `ALTER` commands are based on Django recommendations for Postgres user.

One thing to note, before you go creating databases and users, you should make sure that they don’t already exist. The `\l` will list the various databases present. If this is your first time in the psql shell you’ll see three databases list:

``` {.wp-block-code}
postgres
template0
template1
```

To see a list of the users `\du` will display that. If this is your first time in the psql shell you’ll see one user listed:

``` {.wp-block-code}
postgres
```

OK … the database has been created. Next, we start updating our project to use this new database engine

## Prep project for use of Postgres

### Install Needed Package

The only python package needed to use Postgres is `psycopg2-binary` so we’ll

``` {.wp-block-code}
pip install psycopg2-binary
```

### Update `settings.py`

The `DATABASES` portion of the `settings.py` is set to use SQLite by default and will look (something) like this:

``` {.wp-block-code}
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': 'mydatabase',
    }
}
```

The Django documentation is really good on what changes need to be made. From the [documentation](https://docs.djangoproject.com/en/3.0/ref/settings/#databases) we see that we need to update the `DATABASES` section to be something like this:

``` {.wp-block-code}
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'mydatabase',
        'USER': 'mydatabaseuser',
        'PASSWORD': 'mypassword',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}
```

With our database from above, ours will look like this:

``` {.wp-block-code}
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'my_database',
        'USER': 'my_database_user',
        'PASSWORD': 'my_database_user_password',
        'HOST': 'localhost',
        'PORT': '',
    }
}
```

The `HOST` is changed to `localhost` and we remove the value for `PORT`

Once we get ready to push this to our web server we’ll want to replace the `NAME`, `USER`, and `PASSWORD` with environment variables, but we’ll get to that later

### Run migrations

OK, we’ve got our database set up, we’ve got our settings updated to use the new database, now we can run set that database up.

All that we need to do is to:

``` {.wp-block-code}
python manage.py migrate
```

This will run any migrations that we had created previously on our new Postgres database.

A few things to note:

1.  You will need to create a new `superuser`
2.  You will need to migrate over any data from the old SQLite database^[1](#fn1){#ffn1 .footnote}^

Congratulations! You’ve migrated from SQLite to Postgres!

1.  [This can be done with the `datadump` and `dataload` commands available in `manage.py` [↩](#ffn1)]{#fn1}
