Title: Contributing to Tryceratops
Date: 2021-08-07
Tags: oss, contributing
Slug: contributing-to-tryceratops
Author: ryan

I read about a project called [Tryceratops](https://pypi.org/project/tryceratops/) on Twitter when it was [tweeted about by Jeff Triplet](https://twitter.com/webology/status/1414233648534933509)

I checked it out and it seemed interesting. I decided to use it on my [simplest Django project](https://doestatisjrhaveanerrortoday.com) just to give it a test drive running this command:

    tryceratops .

and got this result:

    Done processing! 🦖✨
    Processed 16 files
    Found 0 violations
    Failed to process 1 files
    Skipped 2340 files

This is nice, but what is the file that failed to process?

This left me with two options:

1. Complain that this awesome tool created by someone didn't do the thing I thought it needed to do

OR

2. Submit an issue to the project and offer to help.

I went with option 2 😀

My initial commit was made in a pretty naive way. It did the job, but not in the best way for maintainability. I had a really great exchange with the maintainer [Guilherme Latrova](https://github.com/guilatrova) about the change that was made and he helped to direct me in a different direction.

The biggest thing I learned while working on this project (for Python at least) was the `logging` library. Specifically I learned how to add:

* a formatter
* a handler
* a logger

For my change, I added a simple format with a verbose handler in a custom logger. It looked something like this:

The formatter:

    "simple": {
        "format": "%(message)s",
    },

The handler:

    "verbose_output": {
        "class": "logging.StreamHandler",
        "level": "DEBUG",
        "formatter": "simple",
        "stream": "ext://sys.stdout",
    },

The logger:

    "loggers": {
        "tryceratops": {
            "level": "INFO",
            "handlers": [
                "verbose_output",
            ],
        },
    },

This allows the `verbose` flag to output the message to Standard Out and give and `INFO` level of detail.

Because of what I learned, I've started using the [logging library](https://docs.python.org/3/library/logging.html) on some of my work projects where I had tried to roll my own logging tool. I should have known there was a logging tool in the Standard Library BEFORE I tried to roll me own 🤦🏻‍♂️

The other thing I (kind of) learned how to do was to squash my commits. I had never had a need (or desire?) to squash commits before, but the commit message is what Guilherme uses to generate the change log. So, with his guidance and help I tried my best to squash those commits. Although in the end he had to do it (still not entiredly sure what I did wrong) I was exposed to the idea of squashing commits and why they might be done. A win-win!

The best part about this entire experience was getting to work with Guilherme Latrova. He was super helpful and patient and had great advice without telling me what to do. The more I work within the Python ecosystem the more I'm just blown away by just how friendly and helpful everyone is and it's what make me want to do these kinds of projects.

If you haven't had a chance to work on an open source project, I highly recommend it. It's a great chance to learn and to meet new people.
