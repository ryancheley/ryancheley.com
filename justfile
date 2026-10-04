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

@sync:
    make sync

@lock:
    make lock

@check:
    pre-commit run --all-files

@codespell:
    codespell content -i 3 --ignore-words=ignore-words.txt

# Generate resume and cover letter PDFs from the Markdown in resume-resources/
@resume:
    #!/usr/bin/env bash
    set -euo pipefail
    cd resume-resources
    header=$(mktemp)
    printf '\\AtBeginDocument{\\raggedright}\n' > "$header"
    pandoc resume.md -o "Ryan Cheley Resume.pdf" --pdf-engine=xelatex -V geometry:margin=1in -V linkcolor:blue -H "$header"
    pandoc cover-letter.md -o "Ryan Cheley Cover Letter.pdf" --pdf-engine=xelatex -V geometry:margin=1in -V linkcolor:blue -H "$header"
    rm -f "$header"

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
