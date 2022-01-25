#!/bin/bash

# Add the post to git
find content -name '*.md' -print | sed 's/^/"/g' | sed 's/$/"/g' | xargs git add


# Get the parts needed for the commit message
TITLE=`git status --porcelain | sed s/^...// | xargs head -7 | grep 'Title: ' | sed -e 's/Title: //g'`
SLUG=`git status --porcelain | sed s/^...// | xargs head -7 | grep 'Slug: ' | sed -e 's/Slug: //g'`
POST_DATE=`git status --porcelain | sed s/^...// | xargs head -7 | grep 'Date: ' | sed -e 's/Date: //g' | head -c 10 | grep '-' | sed -e 's/-/\//g'`
POST_STATUS=` git status --porcelain | sed s/^...// | xargs head -7 | grep 'Status: ' | sed -e 's/Status: //g'`

URL="https://ryancheley.com/$POST_DATE/$SLUG/"

# https://ryancheley.com/2022/01/16/adding-search-to-my-pelican-blog-with-datasette/


if [ $POST_STATUS = "published" ]
then
    MESSAGE="New Post: $TITLE $URL"

    git commit -m "$MESSAGE"

    git push github main
fi
