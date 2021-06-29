#!/usr/bin/env python
# -*- coding: utf-8 -*- #

AUTHOR = 'Ryan Cheley'
SITENAME = 'My Place on the Internet'
SITEURL = ''

PATH = 'content'

TIMEZONE = 'America/Los_Angeles'

DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None
STATIC_PATHS = ['images']

DISPLAY_CATEGORIES_ON_MENU = True

ARTICLE_URL = 'index.php/{date:%Y}/{date:%m}/{date:%d}/{slug}/'
ARTICLE_SAVE_AS = 'index.php/{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'
PAGE_URL = 'index.php/{slug}/'
PAGE_SAVE_AS = 'index.php/{slug}/index.html'

# Blogroll
LINKS = (('Simon Wilison', 'https://simonwillison.net'),
         ('Matt Layman', 'https://www.mattlayman.com'),
         ('PyBites', 'https://pybit.es'),)

# Social widget
SOCIAL = (('Twitter', 'https://twitter.com/ryancheley/'),
          ('GitHub', 'https://github.com/ryancheley'),
          ('LinkedIn', 'https://www.linkedin.com/in/ryan-cheley/'),)

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True