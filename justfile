@_default:
    just --list

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

@micro title:
    make newpost title="{{title}}" category="microblog"

@reqs:
    make reqs

@check:
    pre-commit run --all-files

@codespell:
    codespell content -i 3 --ignore-words=ignore-words.txt

# Bring up Docker containers
[group('docker')]
@up *ARGS:
    docker compose -f docker-compose.dev.yml up {{ ARGS }}

# Bring down Docker containers
[group('docker')]
@down *ARGS:
    docker compose down {{ ARGS }}


# Builds the Docker Images with optional arguments
[group('docker')]
@build *ARGS:
    docker compose {{ ARGS }} build
