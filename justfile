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

@vercel: html
    rsync -av pelican.db metadata.json search.ryancheley@do-web-p-003:~

@toot:
    make toot

@post title category:
    make newpost title="{{title}}" category="{{category}}"

@reqs:
    make reqs

@check:
    pre-commit run --all-files
