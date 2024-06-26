Title: Colophon

This site is made using [Pelican](https://getpelican.com/) which is a [Python](https://www.python.org/) [Static Site Generator](https://en.wikipedia.org/wiki/Static_site_generator)

I use [Digital Ocean](https://www.digitalocean.com/) to host the site.

I have a [Makefile](https://raw.githubusercontent.com/ryancheley/ryancheley.com/main/Makefile) file that allows me to generate new posts. It also allows me to publish the post.

I like [just](https://github.com/casey/just) more though as a command runner, so there is also a [justfile](https://raw.githubusercontent.com/ryancheley/ryancheley.com/main/justfile) that is just a wrapper for the Makefile

I use a [SQLite database](https://sqlite.org/) hosted at [Vercel](https://vercel.com/) which runs [datasette](https://datasette.io/) to serve up search results. I wrote a custom Pelican Plugin called [pelican-to-sqlite](https://pypi.org/project/pelican-to-sqlite/) to generate the content of the entry for the SQLite database.
