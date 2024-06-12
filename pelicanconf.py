#!/usr/bin/env python
# -*- coding: utf-8 -*- #

AUTHOR = "Ryan Cheley"
SITENAME = "RyanCheley.com"
SITESUBTITLE = "My Place on the Internet"
SITEURL = ""

PATH = "content"

THEME = "pelican-clean-blog"

FEED_STYLESHEET = "/rss-style.xsl"

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
]

EXTRA_PATH_METADATA = {
    "static/robots.txt": {"path": "robots.txt"},
    "static/favicon.ico": {"path": "favicon.ico"},
    "static/rss-style.xsl": {"path": "rss-style.xsl"},
    ".well-known/webfinger": {"path": ".well-known/webfinger"},
}

DISPLAY_CATEGORIES_ON_MENU = False
DISPLAY_PAGES_ON_MENU = False
MENUITEMS = [
    ("About", "about"),
    ("Categories", "categories"),
    ("Curriculum Vitae", "cv"),
    ("Brag Doc", "brag-doc"),
    ("Archives", "archives"),
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
