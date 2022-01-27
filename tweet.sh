#!/bin/bash

# generate html and publish SQLite database to vercel
make vercel

# Add the post to git
find content -name '*.md' -print | sed 's/^/"/g' | sed 's/$/"/g' | xargs git add


# Get the parts needed for the commit message
TITLE=`git status --porcelain | sed s/^...// | xargs head -7 | grep 'Title: ' | sed -e 's/Title: //g'`
SLUG=`git status --porcelain | sed s/^...// | xargs head -7 | grep 'Slug: ' | sed -e 's/Slug: //g'`
POST_DATE=`git status --porcelain | sed s/^...// | xargs head -7 | grep 'Date: ' | sed -e 's/Date: //g' | head -c 10 | grep '-' | sed -e 's/-/\//g'`
POST_STATUS=` git status --porcelain | sed s/^...// | xargs head -7 | grep 'Status: ' | sed -e 's/Status: //g'`

URL="https://ryancheley.com/$POST_DATE/$SLUG/"

FILE_COUNT=`git diff --cached --numstat | wc -l`

if [ $FILE_COUNT -gt 1 ]
then
    find content -name '*.md' -print | sed 's/^/"/g' | sed 's/$/"/g' | xargs git restore --staged
    echo "There is more than one file to commit. You'll need to do something else here."
else
    if [ $POST_STATUS = "published" ]
    then
        MESSAGE="New Post: $TITLE $URL"

        git commit -m "$MESSAGE"

        git push github main
    fi
fi
