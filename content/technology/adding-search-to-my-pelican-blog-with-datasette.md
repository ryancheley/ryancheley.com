Title: Adding Search to My Pelican Blog with Datasette
Date: 2022-01-16 19:30
Author: ryan
Tags: Datasette, pelican
Slug: adding-search-to-my-pelican-blog-with-datasette
Status: published

Last summer I migrated my blog from [Wordpress](https://wordpress.com) to [Pelican](https://getpelican.com). I did this for a couple of reasons (see my post [here](https://www.ryancheley.com/2021/07/02/migrating-to-pelican-from-wordpress/)), but one thing that I was a bit worried about when I migrated was that Pelican's offering for site search didn't look promising.

There was an outdated plugin called [tipue-search](https://github.com/pelican-plugins/tipue-search) but when I was looking at it I could tell it was on it's last legs.

I thought about it, and since my blag isn't super high trafficked AND you can use google to search a specific site, I could wait a bit and see what options came up.

After waiting a few months, I decided it would be interesting to see if I could write a SQLite utility to get the data from my blog, add it to a SQLite database and then use [datasette](https://datasette.io) to serve it up.

I wrote the beginning scaffolding for it last August in a utility called [pelican-to-sqlite](https://pypi.org/project/pelican-to-sqlite/0.1/), but I ran into several technical issues I just couldn't overcome. I thought about giving up, but sometimes you just need to take a step away from a thing, right?

After the first of the year I decided to revisit my idea, but first looked to see if there was anything new for Pelican search. I found a tool plugin called [search](https://github.com/pelican-plugins/search) that was released last November and is actively being developed, but as I read through the documentation there was just **A LOT** of stuff:

- stork
- requirements for the structure of your page html
- static asset hosting
- deployment requires updating your `nginx` settings

These all looked a bit scary to me, and since I've done some work using [datasette](https://datasette.io) I thought I'd revisit my initial idea.

## My First Attempt

As I mentioned above, I wrote the beginning scaffolding late last summer. In my first attempt I tried to use a few tools to read the `md` files and parse their `yaml` structure and it just didn't work out. I also realized that `Pelican` can have [reStructured Text](https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html) and that any attempt to parse just the `md` file would never work for those file types.


## My Second Attempt

### The Plugin

During the holiday I thought a bit about approaching the problem from a different perspective. My initial idea was to try and write a `datasette` style package to read the data from `pelican`. I decided instead to see if I could write a `pelican` plugin to get the data and then add it to a SQLite database. It turns out, I can, and it's not that hard.

Pelican uses `signals` to make plugin in creation a pretty easy thing. I read a [post](https://blog.geographer.fr/pelican-plugins) and the [documentation](https://docs.getpelican.com/en/latest/plugins.html) and was able to start my effort to refactor `pelican-to-sqlite`.

From [The missing Pelican plugins guide](https://blog.geographer.fr/pelican-plugins) I saw lots of different options, but realized that the signal `article_generator_write_article` is what I needed to get the article content that I needed.

I then also used `sqlite_utils` to insert the data into a database table.

```
def save_items(record: dict, table: str, db: sqlite_utils.Database) -> None:  # pragma: no cover
    db[table].insert(record, pk="slug", alter=True, replace=True)
```

Below is the method I wrote to take the content and turn it into a dictionary which can be used in the `save_items` method above.

```
def create_record(content) -> dict:
    record = {}
    author = content.author.name
    category = content.category.name
    post_content = html2text.html2text(content.content)
    published_date = content.date.strftime("%Y-%m-%d")
    slug = content.slug
    summary = html2text.html2text(content.summary)
    title = content.title
    url = "https://www.ryancheley.com/" + content.url
    status = content.status
    if status == "published":
        record = {
            "author": author,
            "category": category,
            "content": post_content,
            "published_date": published_date,
            "slug": slug,
            "summary": summary,
            "title": title,
            "url": url,
        }
    return record
```

Putting these together I get a method used by the Pelican Plugin system that will generate the data I need for the site AND insert it into a SQLite database

```
def run(_, content):
    record = create_record(content)
    save_items(record, "content", db)

def register():
    signals.article_generator_write_article.connect(run)
```

### The html template update

I use a custom implementation of [Smashing Magazine](https://www.smashingmagazine.com/2009/08/designing-a-html-5-layout-from-scratch/). This allows me to do some edits, though I mostly keep it pretty stock. However, this allowed me to make a small edit to the `base.html` template to include a search form.

In order to add the search form I added the following code to `base.html` below the `nav` tag:

```
    <section class="relative h-8">
    <section class="absolute inset-y-0 right-10 w-128">
    <form
    class = "pl-4"
    <
    action="https://search-ryancheley.vercel.app/pelican/article_search?text=name"
    method="get">
            <label for="site-search">Search the site:</label>
            <input type="search" id="site-search" name="text"
                    aria-label="Search through site content">
            <button class="rounded-full w-16 hover:bg-blue-300">Search</button>
    </form>
    </section>
```

### Putting it all together with datasette and Vercel

Here's where the **magic** starts. Publishing data to Vercel with `datasette` is extremely easy with the `datasette` plugin [`datasette-publish-vercel`](https://pypi.org/project/datasette-publish-vercel/).

You do need to have the [Vercel cli installed](https://vercel.com/cli), but once you do, the steps for publishing your SQLite database is really well explained in the `datasette-publish-vercel` [documentation](https://github.com/simonw/datasette-publish-vercel/blob/main/README.md).

One final step to do was to add a `MAKE` command so I could just type a quick command which would create my content, generate the SQLite database AND publish the SQLite database to Vercel. I added the below to my `Makefile`:

```
vercel:
	{ \
	echo "Generate content and database"; \
	make html; \
	echo "Content generation complete"; \
	echo "Publish data to vercel"; \
	datasette publish vercel pelican.db --project=search-ryancheley --metadata metadata.json; \
	echo "Publishing complete"; \
	}
```

The line

```
datasette publish vercel pelican.db --project=search-ryancheley --metadata metadata.json; \
```

has an extra flag passed to it (`--metadata`) which allows me to use `metadata.json` to create a saved query which I call `article_search`. The contents of that saved query are:

```
select summary as 'Summary', url as 'URL', published_date as 'Published Data' from content where content like '%' || :text || '%' order by published_date
```

This is what allows the `action` in the `form` above to have a URL to link to in `datasette` and return data!

With just a few tweaks I'm able to include a search tool, powered by datasette for my pelican blog. Needless to say, I'm pretty pumped.

## Next Steps

There are still a few things to do:

1. separate search form html file (for my site)
2. formatting `datasette` to match site (for my vercel powered instance of `datasette`)
3. update the README for `pelican-to-sqlite` package to better explain how to fully implement
4. Get `pelican-to-sqlite` added to the [pelican-plugins page](https://github.com/pelican-plugins/)
