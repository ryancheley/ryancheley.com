@html:
    make html

@clean:
    make clean

@regenerate:
    make regenerate

@serve:
    pelican --listen --autoreload

@publish:
    make publish

@vercel:
    make vercel

@toot:
    make toot

@post title category:
    make newpost title="{{title}}" category="{{category}}"

@reqs:
    make reqs

@check:
    pre-commit run --all-files
