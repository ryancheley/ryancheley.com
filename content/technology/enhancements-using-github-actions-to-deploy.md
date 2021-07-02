Title: Enhancements: Using GitHub Actions to Deploy
Date: 2021-03-14 11:00
Author: ryan
Tags: Deployment, github actions, series
Slug: enhancements-using-github-actions-to-deploy
Status: published

Integrating a version control system into your development cycle is just kind of one of those things that you do, right? I use GutHub for my version control, and it’s GitHub Actions to help with my deployment process.

There are 3 `yaml` files I have to get my local code deployed to my production server:

-   django.yaml
-   dev.yaml
-   prod.yaml

Each one serving it’s own purpose

## django.yaml

The `django.yaml` file is used to run my tests and other actions on a GitHub runner. It does this in 9 distinct steps and one Postgres service.

The steps are:

1.  Set up Python 3.8 - setting up Python 3.8 on the docker image provided by GitHub
2.  psycopg2 prerequisites - setting up `psycopg2` to use the Postgres service created
3.  graphviz prerequisites - setting up the requirements for graphviz which creates an image of the relationships between the various models
4.  Install dependencies - installs all of my Python package requirements via pip
5.  Run migrations - runs the migrations for the Django App
6.  Load Fixtures - loads data into the database
7.  Lint - runs `black` on my code
8.  Flake8 - runs `flake8` on my code
9.  Run Tests - runs all of the tests to ensure they pass

``` {.wp-block-code}
name: Django CI

on:
  push:
    branches-ignore:
      - main
      - dev

jobs:

  build:
    runs-on: ubuntu-18.04
    services:
      postgres:
        image: postgres:12.2
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: github_actions
        ports:
          - 5432:5432
        # needed because the postgres container does not provide a healthcheck
        options: --health-cmd pg_isready --health-interval 10s --health-timeout 5s --health-retries 5

    steps:
    - uses: actions/checkout@v1
    - name: Set up Python 3.8
      uses: actions/setup-python@v1
      with:
        python-version: 3.8
    - uses: actions/cache@v1
      with:
        path: ~/.cache/pip
        key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
        restore-keys: |
          ${{ runner.os }}-pip-
    - name: psycopg2 prerequisites
      run: sudo apt-get install python-dev libpq-dev
    - name: graphviz prerequisites
      run: sudo apt-get install graphviz libgraphviz-dev pkg-config
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install psycopg2
        pip install -r requirements/local.txt
    - name: Run migrations
      run: python manage.py migrate
    - name: Load Fixtures
      run: |
        python manage.py loaddata fixtures/User.json
        python manage.py loaddata fixtures/Sport.json
        python manage.py loaddata fixtures/League.json
        python manage.py loaddata fixtures/Conference.json
        python manage.py loaddata fixtures/Division.json
        python manage.py loaddata fixtures/Venue.json
        python manage.py loaddata fixtures/Team.json
    - name: Lint
      run: black . --check
    - name: Flake8
      uses: cclauss/GitHub-Action-for-Flake8@v0.5.0
    - name: Run tests
      run: coverage run -m pytest
```

## dev.yaml

The code here does essentially they same thing that is done in the `deploy.sh` in my earlier post [Automating the Deployment](/automating-the-deployment.html) except that it pulls code from my `dev` branch on GitHub onto the server. The other difference is that this is on my UAT server, not my production server, so if something goes off the rails, I don’t hose production.

``` {.wp-block-code}
name: Dev CI

on:
  pull_request:
    branches:
      - dev

jobs:
  deploy:
    runs-on: ubuntu-18.04
    steps:
      - name: deploy code
        uses: appleboy/ssh-action@v0.1.2
        with:
          host: ${{ secrets.SSH_HOST_TEST }}
          key: ${{ secrets.SSH_KEY_TEST }}
          username: ${{ secrets.SSH_USERNAME }}

          script: |
            rm -rf StadiaTracker
            git clone --branch dev git@github.com:ryancheley/StadiaTracker.git

            source /home/stadiatracker/venv/bin/activate

            cd /home/stadiatracker/

            rm -rf /home/stadiatracker/StadiaTracker

            cp -r /root/StadiaTracker/ /home/stadiatracker/StadiaTracker

            cp /home/stadiatracker/.env /home/stadiatracker/StadiaTracker/StadiaTracker/.env

            pip -q install -r /home/stadiatracker/StadiaTracker/requirements.txt

            python /home/stadiatracker/StadiaTracker/manage.py migrate

            mkdir /home/stadiatracker/StadiaTracker/static
            mkdir /home/stadiatracker/StadiaTracker/staticfiles

            python /home/stadiatracker/StadiaTracker/manage.py collectstatic --noinput -v0

            systemctl daemon-reload
            systemctl restart stadiatracker
```

## prod.yaml

Again, the code here does essentially they same thing that is done in the `deploy.sh` in my earlier post [Automating the Deployment](/automating-the-deployment.html) except that it pulls code from my `main` branch on GitHub onto the server.

``` {.wp-block-code}
name: Prod CI

on:
  pull_request:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-18.04
    steps:
      - name: deploy code
        uses: appleboy/ssh-action@v0.1.2
        with:
          host: ${{ secrets.SSH_HOST }}
          key: ${{ secrets.SSH_KEY }}
          username: ${{ secrets.SSH_USERNAME }}

          script: |
            rm -rf StadiaTracker
            git clone git@github.com:ryancheley/StadiaTracker.git

            source /home/stadiatracker/venv/bin/activate

            cd /home/stadiatracker/

            rm -rf /home/stadiatracker/StadiaTracker

            cp -r /root/StadiaTracker/ /home/stadiatracker/StadiaTracker

            cp /home/stadiatracker/.env /home/stadiatracker/StadiaTracker/StadiaTracker/.env

            pip -q install -r /home/stadiatracker/StadiaTracker/requirements.txt

            python /home/stadiatracker/StadiaTracker/manage.py migrate

            mkdir /home/stadiatracker/StadiaTracker/static
            mkdir /home/stadiatracker/StadiaTracker/staticfiles

            python /home/stadiatracker/StadiaTracker/manage.py collectstatic --noinput -v0

            systemctl daemon-reload
            systemctl restart stadiatracker
```

The general workflow is:

1.  Create a branch on my local computer with `git switch -c branch_name`
2.  Push the code changes to GitHub which kicks off the `django.yaml` workflow.
3.  If everything passes then I do a pull request from `branch_name` into `dev`.
4.  This kicks off the `dev.yaml` workflow which will update UAT
5.  I check UAT to make sure that everything works like I expect it to (it almost always does … and when it doesn’t it’s because I’ve mucked around with a server configuration which is the problem, not my code)
6.  I do a pull request from `dev` to `main` which updates my production server

My next enhancement is to kick off the `dev.yaml` process if the tests from `django.yaml` all pass, i.e. do an auto merge from `branch_name` to `dev`, but I haven’t done that yet.
