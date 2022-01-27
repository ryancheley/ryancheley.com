Title: git add filename automation
Date: 2022-01-26
Tags:
Slug: git-add-filename-automation
Series: Auto Deploying my Words
Authors: ryan
Status: published

In [my last post](https://www.ryancheley.com/2022/01/24/auto-tweeting-new-post/) I mentioned the steps needed in order for me to post. They are:

1. Run `make html` to generate the SQLite database that powers my site's search tool[ref]`make vercel` actually runs `make html` so this isn't really a step that I need to do.[/ref]
2. Run `make vercel` to deploy the SQLite database to vercel
3. [Run `git add <filename>` to add post to be committed to GitHub](https://www.ryancheley.com/2022/01/26/git-add-filename-automation/)
4. Run `git commit -m <message>` to commit to GitHub
5. [Post to Twitter with a link to my new post](https://www.ryancheley.com/2022/01/24/auto-tweeting-new-post/)

In that post I focused on number 5, posting to Twitter with a link to the post using GitHub Actions.

In this post I'll be focusing on how I automated step 3, "Run `git add <filename>` to add post to be committed to GitHub".

# Automating the `git add ...` part of my workflow

I have my pelican content set up so that the category of a post is determined by the directory a markdown file is placed in. The structure of my content folder looks like this:

```
content
├── musings
├── pages
├── productivity
├── professional\ development
└── technology
```

If you just just `git status` on a directory it will give you the status of all of the files in that directory that have been changed, added, removed. Something like this:

```
❯ git status
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        content/productivity/more-writing-automation.md
        Makefile
        metadata.json
```

That means that when you run `git add .` all of those files will be added to git. For my purposes all that I need is the one updated file in the `content` directory.

The command `find` does a great job of taking a directory and allowing you to search for what you want in that directory. You can run something like

```
find content -name '*.md' -print
```

And it will return essentially what you're looking for. Something like this:

```
content/pages/404.md
content/pages/curriculum-vitae.md
content/pages/about.md
content/pages/brag.md
content/productivity/adding-the-new-file.md
content/productivity/omnifocus-3.md
content/productivity/making-the-right-choice-or-how-i-learned-to-live-with-limiting-my-own-technical-debt-and-just-be-happy.md
content/productivity/auto-tweeting-new-post.md
content/productivity/my-outlook-review-process.md
content/productivity/rules-and-actions-in-outlook.md
content/productivity/auto-generating-the-commit-message.md
content/productivity/declaring-omnifocus-bankrupty.md
```

However, because one of my categories has a space in it's name (`professional development`) if you pipe the output of this to `xargs git add` it fails with the error

```
fatal: pathspec 'content/professional' did not match any files
```

In order to get around this, you need to surround the output of the results of `find` with double quotes ("). You can do this by using `sed`

```
find content -name '*.md' -print | sed 's/^/"/g' | sed 's/$/"/g'
```

What this says is, take the output of `find` and pipe it to `sed` and use a global find and replace to add a `"` to the start of the line (that's what the `^` does) and then pipe that to `sed` again and use a global find and replace to add a `"` to the end of the line (that's what the '$' does).

Now, when you run

```
find content -name '*.md' -print | sed 's/^/"/g' | sed 's/$/"/g'
```

The output looks like this:

```
"content/pages/404.md"
"content/pages/curriculum-vitae.md"
"content/pages/about.md"
"content/pages/brag.md"
"content/productivity/adding-the-new-file.md"
"content/productivity/omnifocus-3.md"
"content/productivity/making-the-right-choice-or-how-i-learned-to-live-with-limiting-my-own-technical-debt-and-just-be-happy.md"
"content/productivity/auto-tweeting-new-post.md"
"content/productivity/my-outlook-review-process.md"
"content/productivity/rules-and-actions-in-outlook.md"
"content/productivity/auto-generating-the-commit-message.md"
"content/productivity/declaring-omnifocus-bankrupty.md"
```

Now, you can pipe your output to `xargs git add` and there is no error!

The final command looks like this:

```
find content -name '*.md' -print | sed 's/^/"/g' | sed 's/$/"/g' | xargs git add
```

In the next post, I'll walk through how I generate the commit message to be used in the automatic tweet!
