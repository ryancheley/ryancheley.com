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

DISPLAY_CATEGORIES_ON_MENU = False
DISPLAY_PAGES_ON_MENU = False
MENUITEMS = [
    ('About', 'about'),
    ('Categories', 'categories'),
    ('Curriculum Vitae', 'curriculum-vitae'),
    ('Archives', 'archives'),
]


ARTICLE_URL = '{date:%Y}/{date:%m}/{date:%d}/{slug}/'
ARTICLE_SAVE_AS = '{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'
PAGE_URL = '{slug}/'
PAGE_SAVE_AS = '{slug}/index.html'
ARCHIVES_SAVE_AS = 'archives.html'
ARCHIVES_URL = 'archives'
YEAR_ARCHIVE_URL = 'archives/{date:%Y}/'
YEAR_ARCHIVE_SAVE_AS = 'archives/{date:%Y}/index.html'

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