Title: Using different .env files
Date: 2021-01-16 14:53
Author: ryan
Tags: DevOps, JustFile
Slug: using-different-env-files
Status: published

In a Django project I’m working on I use a library called `Django-environ` which

> allows you to utilize 12factor inspired environment variables to configure your Django application.

It’s a pretty sweet library as well. You create a .env file to store your variable that you don’t want in a public repo for your `settings.py`.

The big issue I have is that my `.env` file for my local development isn’t what I want on my production server (obviously ... never set `DEBIG=True` in production!)

I had tried to use a different `.env` file using an assortment of methods, but to no avail. And the documentation wasn’t much of a help for using Multiple env file

> It is possible to have multiple env files and select one using environment variables.
>
> Now `ENV_PATH=other-env ./manage.py runserver` uses `other-env` while `./manage.py runserver` uses `.env`.

But there’s no example about how to actually set that up 🤦🏻‍♂️[ref]I’d like to figure out how to set up multiple `.env` files, create an example and contribute to the docs ... but honestly I have *no freaking clue* how to do it. If I am able to figure it out, you can bet I’m going to write up a PR for the docs![/ref].

In fact, this bit in the documentation reminded me of this[video](https://youtu.be/MAlSjtxy5ak "Every Programming Tutorial") on YouTube.

Instead of trying to figure out the use of multiple `.env` files I instead used a [just](https://github.com/casey/just) recipe in my `justfile` to get the job done.

``` {.wp-block-code}
# checks the deployment for prod settings; will return error if the check doesn't pass
check:
    cp core/.env core/.env_staging
    cp core/.env_prod core/.env
    -python manage.py check --deploy
    cp core/.env_staging core/.env
```

OK. What does this recipe do?

First, we copy the development `.env` file to a `.env_staging` file to keep the original development settings ‘somewhere’

``` {.wp-block-code}
 cp core/.env core/.env_staging
```

Next, we copy the `.env_prod` to the `.env` so that we can use it when we run `-python manage.py check --deploy`.

``` {.wp-block-code}
cp core/.env_prod core/.env
-python manage.py check --deploy
```

Why do we use the `-`? That allows the `justfile` to keep going if it runs into an error. Since we’re updating our main `.env` file I want to make sure it gets restored to its original state … just in case!

Finally, we copy the original contents of the `.env` file from the `.env_staging` back to the `.env` to restore it to its development settings.

Now, I can simply run

``` {.wp-block-code}
just check
```

And I’ll know if I have passed the 12 factor checking for my Django project or somehow introduced something that makes the check not pass.

I’d like to figure out how to set up multiple `.env` files, create an example and contribute to the docs ... but honestly I have *no freaking clue* how to do it. If I am able to figure it out, you can bet I’m going to write up a PR for the docs!

