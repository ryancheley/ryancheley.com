#!/usr/bin/env python
# -*- coding: utf-8 -*- #

AUTHOR = "Ryan Cheley"
SITENAME = "RyanCheley.com"
SITESUBTITLE = "My Place on the Internet"
SITEURL = ""

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
STATIC_PATHS = ["images"]

DISPLAY_CATEGORIES_ON_MENU = False
DISPLAY_PAGES_ON_MENU = False
MENUITEMS = [
    ("About", "/about.html"),
    ("Categories", "/categories.html"),
    ("Curriculum Vitae", "/curriculum-vitae.html"),
    ("Brag Doc", "/brag-doc.html"),
    ("Archives", "/archives.html"),
]


ARTICLE_URL = "{date:%Y}/{date:%m}/{date:%d}/{slug}/"
ARTICLE_SAVE_AS = "{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html"
PAGE_URL = "{slug}/"
PAGE_SAVE_AS = "{slug}/index.html"
ARCHIVES_SAVE_AS = "archives.html"
ARCHIVES_URL = "archives"
CATEGORIES_SAVE_AS = "categories.html"
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
    ("Twitter", "https://twitter.com/ryancheley/"),
    ("GitHub", "https://github.com/ryancheley"),
    ("LinkedIn", "https://www.linkedin.com/in/ryan-cheley/"),
)

SHOW_SOCIAL_ON_INDEX_PAGE_HEADER = True

DEFAULT_PAGINATION = 10

TWITTER_USERNAME = "ryancheley"

COLOR_SCHEME_CSS = "github.css"

SHOW_FULL_ARTICLE = True

# Uncomment following line if you want document-relative URLs when developing
# RELATIVE_URLS = True

DISABLE_CUSTOM_THEME_JAVASCRIPT = True
