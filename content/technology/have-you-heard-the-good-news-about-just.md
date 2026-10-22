Title: Have you heard the good news about just?
Date: 2026-10-26
Author: ryan
Tags: just, justfile
Slug: have-you-heard-the-good-news-about-just
Series: learnings-on-leave
Status: published

Because of my current cancer treatment I'm on medical leave from work. I spend a LOT of my day resting, or doing very non-active things ...  like watching TV Shows. I'm currently binging [Star Trek: Strange New Worlds](https://en.wikipedia.org/wiki/Star_Trek:_Strange_New_Worlds) and it's really good.

In order to help stave off brain rot I decided that I would spend some time learning about various technologies that I use or would like to use, and finding out more about them. In this week's installment, I'm taking a look at [just](https://just.systems/man/en/), a command runner that is so good.

## justfile

I've been using `justfile`s in my projects for a while now thanks to [Jeff Triplett](https://jefftriplett.com/), but there's just so much to them. I read through the docs this week and found 19 things that look useful to incorporate into my just files.

### 1. default-list

When you run `just` in your terminal it will run the first recipe listed in your file. One way I had overcome this was by adding the following recipe:

```just
@_default:
    just --list
```

This would cause `just` to list all of the commands available (with comments if they exist)

However, there's a different way to do this. You can add

```just
set default-list := true
```

at the top of the justfile and get the same behavior.

### 2. Variadic parameters

One of the recipes I rely on frequently is

```just
# Bring up Docker containers
[group('docker')]
@up *ARGS:
    docker compose -f docker-compose.dev.yml up {{ ARGS }}
```

The `*ARGS` is what's known as a variadic parameter. These can accept a (potentially) infinite number of parameters passed to them. You can either use `+` to indicate 1 or more parameters, or a `*` to indicate 0 or more parameters.

The recipe above allows the following invocations

```bash
# Bring the Docker container up in the foreground
just up
```



```bash
# Bring the Docker container up in detached mode
just up -d
```

```bash
# Build the Docker container and then bring the Docker container up in the detached mode
just up --build -d
```

The new thing I learned is that they can also accept defaults. This means that I could update the recipe to be

```just
# Bring up Docker containers
[group('docker')]
@up *ARGS='-d':
    docker compose -f docker-compose.dev.yml up {{ ARGS }}
```

This would cause

```
just up
```

and

```bash
just up -d
```

to behave the same.

I could also just update the recipe to be

```just
# Bring up Docker containers
[group('docker')]
@up *ARGS:
    docker compose -f docker-compose.dev.yml up -d {{ ARGS }}
```

I'm trying to figure out the best use case for this, but it did seem like an interesting concept to try out

### 3. Variadic parameters limits

You may want to limit the number of parameters you allow on a variadic parameter. Just allows you to control this by using `[arg('ARGS', min='1', max='4')]` like this

```just
# Bring up Docker containers
[group('docker')]
[arg('ARGS', min='1', max='4')]
@up *ARGS:
    docker compose -f docker-compose.dev.yml up {{ ARGS }}
```

In order for this to work, you do need to add the following to your justfile

```just
set unstable
set lists
```

> Quick Aside ...
> The [docs](https://just.systems/man/en/recipe-parameters.html) give a better example using `scp` which likely makes more sense, but I wanted to keep the same example going here

### 4. Parameter constraints

You can constrain parameters using `[arg('ARGS', pattern='--help|--version')]`.

Per the [docs](https://just.systems/man/en/recipe-parameters.html)

> Regular expressions are provided by the [Rust regex crate](https://docs.rs/regex/latest/regex/). See the [syntax documentation](https://docs.rs/regex/latest/regex/#syntax) for usage examples.

We again can update the just recipe from before to be

```just
# Bring up Docker containers
[group('docker')]
[arg('ARGS', pattern='-d|--build')]
@up *ARGS:
    docker compose -f docker-compose.dev.yml up {{ ARGS }}
```

Again, not helpful in this case necessarily, but there are applications with other recipes I'm sure

### 5. Usage information

Usage information for a recipe may be printed with the `--usage` subcommand. I have the following recipe that creates new posts for this site (please excuse the mix of `make` with `just`)

```just
@post title category:
    make newpost title="{{title}}" category="{{category}}"
```

If I run `just --usage post` I get this returned

```bash
Usage: just post title category

Arguments:
  title
  category
```

This can be helpful when you aren't sure what the arguments are for a just recipe (if they exist at all!)

### 6. Run recipes at the end

You can have recipes run at the end of a recipe, not just the beginning. Typically when running a `just` recipe any dependencies will run before the invoked recipe.

For example, assume you have these recipes:

```just
test: build
    run tests

build:
    build project
```

If you run `just test` it will first run the `build` recipe and then the `test` recipe.

Let's assume you also have a deployment recipe that you want to run AFTER the build recipe runs successfully. You could have the following `justfile`:

```just
test: build && deploy
    run tests

build:
    build project

deploy:
    deploy project
```

Running the command `just test` would do the following

1. Run the `build` recipe
2. Run the `test` recipe
3. Run the `deploy` recipe

See the [docs](https://just.systems/man/en/dependencies.html#running-recipes-at-the-end-of-a-recipe) for more examples

### 7. Parallel Tasks

You can run parallel tasks with the `[parallel]` invocation above a recipe. This could be helpful if you have a project with a front end and a back end and you want to run the tests at the same time:

```just
[parallel]
test: fe be

fe:
    test front-end-project

be:
    test back-end-project
```


See the [docs](https://just.systems/man/en/parallelism.html#parallelism) for more details


### 8. Recipe documentation

Who doesn't love good documentation, right? `just` allows for a few options for docs

1. The `#` symbol
2. The `[doc('Your Comment Here')]` attribute

Why choose one over the other? The `#` only allows for single line documentation, while the `[doc()]` attribute allows for multi-line documentation.

One thing to note on multi-line documentation is that it can look a bit off

This just recipe

```just
[group('docker')]
[doc('
Bring up Docker containers
A second line
and a third
')]
@up *ARGS:
    docker compose -f docker-compose.dev.yml up {{ ARGS }}
```

will generate this documentation

```bash
    # Bring up Docker containers
    # A second line
    # and a third
    up *ARGS
```

See the [docs](https://just.systems/man/en/documentation-comments.html) for more details

### 9. Groups

In the previous example there was `[group('docker')]`. This attribute allows you to group recipes together. For a really good example, see the [Django Packages justfile](https://raw.githubusercontent.com/djangopackages/djangopackages/refs/heads/main/justfile)

Running `just` will return

```bash
Available recipes:
    [database]
    pg_dump file='db.dump'           # Dump database to file
    pg_restore file='db.dump'        # Restore database from dump file

    [django]
    collectstatic *ARGS="--no-input" # Collect static files
    createsuperuser USERNAME EMAIL   # Create a Django superuser
    cron                             # Run scheduled data import tasks
    run ARGS                         # Run a Django management command
    shell *ARGS                      # Run Django shell

    [docker]
    build *ARGS                      # Builds the Docker Images with optional arguments
    cibuild                          # Build Docker images for CI
    console                          # Drop into a bash shell in the Django container
    down *ARGS                       # Bring down Docker containers
    logs *ARGS                       # View output from running containers
    remove                           # Remove all application services and volumes
    restart *ARGS                    # Restart all services
    start *ARGS="--detach"           # Start all services
    status                           # Show status of running containers
    stop                             # Stop all services
    tail                             # Tail service logs
    up *ARGS                         # Start Docker containers

    [docs]
    docs-build *ARGS                 # Build the documentation to docs/site
    docs-down *ARGS                  # Stop documentation services
    docs-up *ARGS="--detach"         # Start documentation services

    [linting]
    lint *ARGS                       # Run all prek linting and code quality checks
    perflint                         # Check for performance anti-patterns

    [production]
    purge_cache                      # Purge Cloudflare cache

    [testing]
    coverage *ARGS                   # Run tests with pytest and generate coverage reports
    pytest *ARGS                     # Run tests with pytest
    test *ARGS                       # Run tests using Django test runner

    [utils]
    bootstrap *ARGS                  # Perform initial setup: create venv, .env.local, and build Docker images
    bump *ARGS                       # Update the version; Used before release to production
    fmt                              # Format the justfile
    lock *ARGS                       # Compile Python dependencies with hashes [alias: pip-compile]
    setup                            # Alias for bootstrap - perform initial setup
    upgrade                          # Upgrade existing Python dependencies to their latest versions
```

You can list the groups by running `just --groups`. However, in order to list the recipes in a specific group you need to run `just --list --group <group-name>`, for example, `just --list --group docker`.

It would be nice if running `just --group docker` would work, but as of just 1.59.0 it generates an error

```bash
error: the following required arguments were not provided:
  --list [<MODULE>...]

Usage: just --list [<MODULE>...] --group <GROUP> [ARGUMENTS]...

For more information, try '--help'.
```

### 10. Private Recipes

There is a concept of private recipes by using the `[private]` attribute. The main use is **helper recipes that exist only to be dependencies or building blocks.**

For example, in the Django Packages justfile the recipe

```just
# Format the justfile
[group('utils')]
@fmt:
    just --fmt --unstable
```

could be changed to

```just
# Format the justfile
[private]
[group('utils')]
@fmt:
    just --fmt --unstable
```

This would cause the `fmt` recipe to not be listed when showing all of the recipes.

### 11. Shell expanded strings

Per the [docs](https://just.systems/man/en/strings.html#shell-expanded-strings)

> Strings prefixed with `x` are shell expanded (as of version 1.27.0)

One interesting thing that can be done here is that you can keep common recipes in one place and pull them into every project’s `justfile` like this:

```just
import x'~/.config/just/common.just'
```

More on common `justfile`s a little later

### 12. Set your shell

You can set the shell that `just` will use. This can be especially helpful on Windows where you are running Powershell instead of WSL.

On Windows you can set it like this:

```just
[windows]
set shell := ["powershell.exe", "-NoLogo", "-Command"]
```

This can make it much easier to have a single `justfile` that can be used on Windows, macOS, or Linux.

See more at the [docs](https://just.systems/man/en/shell.html)

### 13. Working Directory

You can set the working directory for an entire `justfile` or a single recipe. I'm still trying to figure out the best use case for this, but one thing that *might* be helpful is that if you have a sub-directory called `scripts` that has all of your scripts and you don't want to have every just recipe that invokes a script to look like this:

```just
simple:
    ./scripts/simple.sh

complicated:
    ./scripts/complicated.sh
```

You could add `set working-directory := 'scripts'` like this

```just
set working-directory := 'scripts'
simple:
    ./simple.sh

complicated:
    ./complicated.sh
```

Again, I'm still trying to figure out a good use case for this, but it was interesting enough to catch my eye

See [docs](https://just.systems/man/en/working-directory.html) for more details

### 14. Importing other `justfile`s

If you need/want to separate your various just recipes into separate files you can do that. Assume that you have a `justfile` and several sub-`justfile`s that look something like this:

```bash
.
├── be.just
├── fe.just
├── docker.just
└── justfile
```

The `be.just` might look like this:

```just
[doc('Used to run the back end tests')]
[group('backend')]
@be-test:
    echo "run back end tests"

[doc('Used to run the back end build')]
[group('backend')]
@be-build: be-test
    echo "run back end build"
```

the `fe.just` might look like this

```just
[doc('Used to run the front end tests')]
[group('frontend')]
@fe-test:
    echo "run front end tests"

[doc('Used to run the front end build')]
[group('frontend')]
@fe-build: fe-test
    echo "run front end build"
```

the `docker.just` might look like this:

```just
[doc('Bring Docker Containers up')]
[group('docker')]
up *ARGS:
    docker compose up {{ARGS}}

[doc('Bring Docker Containers down')]
[group('docker')]
down:
    docker compose down
```

We can then have a `justfile` that looks like this:

```just
import 'be.just'
import 'fe.just'
import 'docker.just'

set default-list := true
```

We can set whatever other settings in the `justfile` we want. This allows us to have a separation of concerns for our just recipes.

See the [docs](https://just.systems/man/en/imports.html) for more details. You can also pull shared recipes in from a common file — see tip 11.

### 15. set fallback

When you add `set fallback` you can traverse the directory up to a justfile with the recipe you're trying to find. For example, if you have a `justfile` in your home directory that looks like this:

```just
@default:
    just --list

[no-cd]
pwd:
    pwd

[no-cd]
gist file:
    gh api gists -F 'files[{{ file }}][content]=@{{ file }}'

@usage time="daily":
    npx ccusage@latest {{ time }} --breakdown

[no-cd]
@gh profile:
    uvx gh-profiler {{ profile }}

@glm:
    uvx glm-launch launch claude
```

but you're in the directory `~/code/ryancheley.com` that has a justfile that looks like this:

```just
set default-list := true

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
```

If you wanted to run the `usage` recipe you'd get an error like this:

```bash
error: justfile does not contain recipe `usage`
```

However, if you add `set fallback` to the top of the `justfile` in `~/code/ryancheley.com` then the recipe will run without issue. For example:

```just
set default-list := true
set fallback

@html:
    make html

...
```

See [docs](https://just.systems/man/en/fallback-to-parent-justfiles.html) for more details

### 16. Remote justfile

Let's say you really like the Django Packages `justfile` and you wanted to include it in your `justfile`. You could add the following to the top of your just file

```just
import? 'djangopackages.just'
set allow-duplicate-recipes
```

The first line optionally imports a file called `djangopackages.just`. The second line isn't strictly necessary, but in the event you have a recipe with the same name as one used in `djangopackages.just` this allows you to not get an error. One caveat is that the last version of the recipe is what will be used. In this example, since the `import? 'djangopackages.just'` appears at the top, the `lock` recipe will be the one from the `justfile` and not from `djangopackages.just`

You can then add this recipe to your `justfile`:

```just
fetch:
    curl https://raw.githubusercontent.com/djangopackages/djangopackages/refs/heads/main/justfile > djangopackages.just
```

In order to have the `djangopackages.just` file you'll need to run the `just fetch` recipe.

### 17. The `--choose` flag

The `--choose` flag will list out recipes (with some exceptions) so you can select them; good for learning about the recipes available. In order to use this you'll need to install `fzf`. This can be installed with `brew install fzf` on macOS.

One caveat here is that it won't list out recipes that have arguments passed to them. Additionally private recipes (item 10) and aliases are skipped.

See the [docs](https://just.systems/man/en/selecting-recipes-to-run-with-an-interactive-chooser.html) here.

### 18. Confirm attribute

Let's say you have a super destructive just recipe like this:

```just
delete-all:
    rm -rf *
```

When you run `just delete-all` it will run the command without prompting. You can prevent that behavior by adding the `[confirm]` attribute to the recipe

```just
[confirm]
delete-all:
    rm -rf *
```

So when you run `just delete-all` instead of nuking all of the files, you'll get prompted to confirm that decision

```bash
Run recipe `delete-all`?
```
And you can enter `N` if you invoked the recipe by mistake.

See the [docs](https://just.systems/man/en/requiring-confirmation-for-recipes.html) for more details.


### 19. Format your justfile

A simple way to check that your `justfile` is formatted correctly is to run `just --fmt --check`

You can then run `just --fmt` to format it correctly.

See the [docs](https://just.systems/man/en/formatting-and-dumping-justfiles.html) for more details.
