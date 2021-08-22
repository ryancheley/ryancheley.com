Title: djhtml and justfile
Date: 2021-08-22
Tags: django, djhtml, just
Slug: djhtml-and-justfile
Authors: ryan
Status: draft

I had read about a project called djhtml and wanted to use it on one of my projects. The documentation is really good for adding it to precommit-ci, but I wasn't sure what I needed to do to just run it on the command line. 

It took a bit of googling, but I was finally able to get the right incantation of commands to be able to get it to run on my templates:

    djhtml -i $(find templates -name '*.html' -print)

But of course because I have the memory of a goldfish and this is more than 3 commands to try to remember to string together, instead of telling myself I would remember it, I simply added it to a just file and now have this recipe:

    # applies djhtml linting to templates
    djhtml:
        djhtml -i $(find templates -name '*.html' -print)

This means that I can now run `just djhtml` and I can apply djhtml's linting to my templates. 

Pretty darn cool if you ask me. But then I got to thinking, I can make this a bit more general for 'linting' type activities. I include all of these in my precommit-ci, but I figured, what the heck, might as well have a just recipe for all of them! 

So I refactored the recipe to be this:

    # applies linting to project (black, djhtml, flake8)
    lint:
        djhtml -i $(find templates -name '*.html' -print)
        black .
        flake8 .

And now I can run all of these linting style libraries with a single command `just lint`