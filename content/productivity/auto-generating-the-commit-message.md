Title: Auto Generating the Commit Message
Date: 2022-01-28
Tags: Automation
Slug: auto-generating-the-commit-message
Series: Auto Deploying my Words
Authors: ryan
Status: published

In my first post of this series I outlined the steps needed in order for me to post. They are:

1. Run `make html` to generate the SQLite database that powers my site's search tool[ref]`make vercel` actually runs `make html` so this isn't really a step that I need to do.[/ref]
2. Run `make vercel` to deploy the SQLite database to vercel
3. [Run `git add <filename>` to add post to be committed to GitHub](https://www.ryancheley.com/2022/01/26/git-add-filename-automation/)
4. [Run `git commit -m <message>` to commit to GitHub](https://www.ryancheley.com/2022/01/28/auto-generating-the-commit-message)
5. [Post to Twitter with a link to my new post](https://www.ryancheley.com/2022/01/24/auto-tweeting-new-post/)

In this post I'll be focusing on how I automated step 4, Run `git commit -m <message>` to commit to GitHub.

# Automating the "git commit ..." part of my workflow

In order for my GitHub Action to auto post to Twitter, my commit message needs to be in the form of "New Post: ...". What I'm looking for is to be able to have the commit message be something like this:

> New Post: Great New Post https://ryancheley.com/yyyy/mm/dd/great-new-post/

This is basically just three parts from the markdown file, the `Title`, the `Date`, and the `Slug`.

In order to get those details, I need to review the structure of the markdown file. For Pelican writing in markdown my file is structured like this:

```
Title:
Date:
Tags:
Slug:
Series:
Authors:
Status:

My words start here and go on for a bit.
```

In [the last post](https://www.ryancheley.com/2022/01/28/auto-generating-the-commit-message) I wrote about how to `git add` the files in the content directory. Here, I want to take the file that was added to `git` and get the first 7 rows, i.e. the details from `Title` to `Status`.

The file that was updated that needs to be added to git can be identified by running

```
find content -name '*.md' -print | sed 's/^/"/g' | sed 's/$/"/g' | xargs git add
```

Running `git status` now will display which file was added with the last command and you'll see something like this:

```
❯ git status
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        content/productivity/auto-generating-the-commit-message.md
```

What I need though is a more easily parsable output. Enter the `porcelin` flag which, per the docs

> Give the output in an easy-to-parse format for scripts. This is similar to the short output, but will remain stable across Git versions and regardless of user configuration. See below for details.

which is exactly what I needed.

Running `git status --porcelain` you get this:

```
❯ git status --porcelain
?? content/productivity/more-writing-automation.md
```

Now, I just need to get the file path and exclude the status (the `??` above in this case[ref]Other values could just as easily be `M` or `A`[/ref]), which I can by piping in the results and using `sed`

```
❯ git status --porcelain | sed s/^...//
content/productivity/more-writing-automation.md
```

The `sed` portion says

- search the output string starting at the beginning of the line (`^`)
- find the first three characters (`...`). [ref]Why the first three characters, because that's how `porcelain` outputs the `status`[/ref]
- replace them with nothing (`//`)

There are a couple of lines here that I need to get the content of for my commit message:

- Title
- Slug
- Date
- Status[ref]I will also need the `Status` to do some conditional logic otherwise I may have a post that is in draft status that I want to commit and the GitHub Action will run posting a tweet with an aritcle and URL that don't actually exist yet.
[/ref]

I can use `head` to get the first `n` lines of a file. In this case, I need the first 7 lines of the output from `git status --porcelain | sed s/^...//`. To do that, I pipe it to `head`!

```
git status --porcelain | sed s/^...// | xargs head -7
```

That command will return this:

```
Title: Auto Generating the Commit Message
Date: 2022-01-24
Tags: Automation
Slug: auto-generating-the-commit-message
Series: Auto Deploying my Words
Authors: ryan
Status: draft
```

In order to get the **Title**, I'll pipe this output to `grep` to find the line with `Title`

```
git status --porcelain | sed s/^...// | xargs head -7 | grep 'Title: '
```

which will return this

```
Title: Auto Generating the Commit Message
```

Now I just need to remove the leading `Title: ` and I've got the title I'm going to need for my Commit message!

```
git status --porcelain | sed s/^...// | xargs head -7 | grep 'Title: ' | sed -e 's/Title: //g'
```

which return just

```
Auto Generating the Commit Message
```

I do this for each of the parts I need:

- Title
- Slug
- Date
- Status

Now, this is getting to have a lot of parts, so I'm going to throw it into a `bash` script file called `tweet.sh`. The contents of the file look like this:

```
TITLE=`git status --porcelain | sed s/^...// | xargs head -7 | grep 'Title: ' | sed -e 's/Title: //g'`
SLUG=`git status --porcelain | sed s/^...// | xargs head -7 | grep 'Slug: ' | sed -e 's/Slug: //g'`
POST_DATE=`git status --porcelain | sed s/^...// | xargs head -7 | grep 'Date: ' | sed -e 's/Date: //g' | head -c 10 | grep '-' | sed -e 's/-/\//g'`
POST_STATUS=` git status --porcelain | sed s/^...// | xargs head -7 | grep 'Status: ' | sed -e 's/Status: //g'`
```

You'll see above that the `Date` piece is a little more complicated, but it's just doing a find and replace on the `-` to update them to `/` for the URL.

Now that I've got all of the pieces I need, it's time to start putting them together

I define a new variable called `URL` and set it

```
URL="https://ryancheley.com/$POST_DATE/$SLUG/"
```

and the commit message

```
MESSAGE="New Post: $TITLE $URL"
```

Now, all I need to do is wrap this in an `if` statement so the command only runs when the STATUS is `published`

```
if [ $POST_STATUS = "published" ]
then
    MESSAGE="New Post: $TITLE $URL"

    git commit -m "$MESSAGE"

    git push github main
fi
```

Putting this all together (including the `git add` from my previous post) and the `tweet.sh` file looks like this:

```
# Add the post to git
find content -name '*.md' -print | sed 's/^/"/g' | sed 's/$/"/g' | xargs git add


# Get the parts needed for the commit message
TITLE=`git status --porcelain | sed s/^...// | xargs head -7 | grep 'Title: ' | sed -e 's/Title: //g'`
SLUG=`git status --porcelain | sed s/^...// | xargs head -7 | grep 'Slug: ' | sed -e 's/Slug: //g'`
POST_DATE=`git status --porcelain | sed s/^...// | xargs head -7 | grep 'Date: ' | sed -e 's/Date: //g' | head -c 10 | grep '-' | sed -e 's/-/\//g'`
POST_STATUS=` git status --porcelain | sed s/^...// | xargs head -7 | grep 'Status: ' | sed -e 's/Status: //g'`

URL="https://ryancheley.com/$POST_DATE/$SLUG/"

if [ $POST_STATUS = "published" ]
then
    MESSAGE="New Post: $TITLE $URL"

    git commit -m "$MESSAGE"

    git push github main
fi
```

When this script is run it will find an updated or added markdown file (i.e. article) and add it to git. It will then parse the file to get data about the article. If the article is set to published it will commit the file with a message and will push to github. Once at GitHub, [the Tweeting action I wrote about](https://www.ryancheley.com/2022/01/24/auto-tweeting-new-post/) will tweet my commit message!

In the next (and last) article, I'm going to throw it all together and to get a spot when I can run one make command that will do all of this for me.
## Caveats

The script above works, but if you have multiple articles that you're working on at the same time, it will fail pretty spectacularly. The final version of the script has guards against that and looks like [this](https://github.com/ryancheley/ryancheley.com/blob/main/tweet.sh)
