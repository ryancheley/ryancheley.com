#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from pymdownx.superfences import fence_code_format

AUTHOR = "Ryan Cheley"
SITENAME = "RyanCheley.com"
SITESUBTITLE = "My Place on the Internet"
SITEURL = ""

IGNORE_FILES = ["dsf-candidate-statement"]

PATH = "content"

THEME = "pelican-clean-blog"

TIMEZONE = "America/Los_Angeles"

DEFAULT_LANG = "en"

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None
STATIC_PATHS = [
    "images",
    "static/robots.txt",
    "static/favicon.ico",
    ".well-known/webfinger",
    "static/rss-style.xsl",
    "static/dsf-candidate-statement",
]

EXTRA_PATH_METADATA = {
    "static/robots.txt": {"path": "robots.txt"},
    "static/favicon.ico": {"path": "favicon.ico"},
    "static/rss-style.xsl": {"path": "rss-style.xsl"},
    ".well-known/webfinger": {"path": ".well-known/webfinger"},
    "static/dsf-candidate-statement/index.html": {"path": "dsf-candidate-statement/index.html"},
}

DISPLAY_CATEGORIES_ON_MENU = False
DISPLAY_PAGES_ON_MENU = False
MENUITEMS = [
    ("About", "/pages/about"),
    ("Categories", "/pages/categories"),
    ("Curriculum Vitae", "/pages/cv"),
    ("Brag Doc", "/pages/brag-doc"),
    ("Archives", "/pages/archives"),
]


ARTICLE_URL = "{date:%Y}/{date:%m}/{date:%d}/{slug}/"
ARTICLE_SAVE_AS = "{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html"
PAGE_URL = "pages/{slug}/"
PAGE_SAVE_AS = "pages/{slug}.html"
ARCHIVES_SAVE_AS = "pages/archives.html"
ARCHIVES_URL = "pages/archives"
CATEGORIES_SAVE_AS = "pages/categories.html"
YEAR_ARCHIVE_URL = "archive/{date:%Y}/"
YEAR_ARCHIVE_SAVE_AS = "archive/{date:%Y}/index.html"

# Blogroll
LINKS = (
    ("Simon Wilison", "https://simonwillison.net"),
    ("Matt Layman", "https://www.mattlayman.com"),
    ("PyBites", "https://pybit.es"),
)

# Social widget
SOCIAL = (
    ("Mastodon", "https://mastodon.social/@ryancheley"),
    ("GitHub", "https://github.com/ryancheley"),
    ("LinkedIn", "https://www.linkedin.com/in/ryan-cheley/"),
)

SHOW_SOCIAL_ON_INDEX_PAGE_HEADER = True

DEFAULT_PAGINATION = 10

COLOR_SCHEME_CSS = "github.css"

SHOW_FULL_ARTICLE = True

# Uncomment following line if you want document-relative URLs when developing
# RELATIVE_URLS = True

DISABLE_CUSTOM_THEME_JAVASCRIPT = True

SITEMAP = {
    "format": "xml",
    "priorities": {"articles": 0.75, "indexes": 0.5, "pages": 0.5},
    "changefreqs": {"articles": "monthly", "indexes": "daily", "pages": "monthly"},
}

WITH_FUTURE_DATES = False

FEED_ATOM = "feeds/atom"
FEED_RSS = "feeds/rss"
FEED_FILTER = {
    "feeds/*": {
        "exclude.categories": [
            "microblog",
        ]
    }
}

MARKDOWN = {
    "extension_configs": {
        "markdown.extensions.codehilite": {"css_class": "highlight"},
        # "extra" minus fenced_code: superfences replaces it so fences work inside lists
        "markdown.extensions.abbr": {},
        "markdown.extensions.attr_list": {},
        "markdown.extensions.def_list": {},
        "markdown.extensions.footnotes": {},
        "markdown.extensions.md_in_html": {},
        "markdown.extensions.tables": {},
        "pymdownx.superfences": {
            "custom_fences": [
                {
                    "name": "mermaid",
                    "class": "mermaid",
                    "format": fence_code_format,
                }
            ]
        },
        "markdown.extensions.meta": {},
        "markdown.extensions.toc": {
            "permalink": True,  # optional: adds a clickable ¶ next to each heading
        },
    },
    "output_format": "html5",
}
