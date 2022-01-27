Title: Auto Generating the Commit Message
Date: 2022-01-24
Tags: "GitHub Actions"
Slug: auto-generating-the-commit-message
Series: Auto Deploying my Words
Authors: ryan
Status: draft

In my last post I mentioned the steps needed in order for me to post. They are:

1. Run `make html` to generate the SQLite database that powers my site's search tool[ref]`make vercel` actually runs `make html` so this isn't really a step that I need to do.[/ref]
2. Run `make vercel` to deploy the SQLite database to vercel
3. Run `git add <filename>` to add post to be committed to GitHub
4. Run `git commit -m <message>` to commit to GitHub
5. Post to Twitter with a link to my new post

In this post I'll be focusing on how I automated step 4.

What is it that I'm trying to automate in step four?

# Automating the `git commit ...` part of my workflow

I have my pelican content set up so that the category that a post will be in is determined by the directory a markdown file is placed in. The structure of my content folder looks like this:

```
content
├── musings
├── pages
├── productivity
├── professional\ development
└── technology
```

If you just just `git status` on a directory it will give you the status of all of the files in that directory. Something like this:

```
❯ git status
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        content/productivity/more-writing-automation.md
```

What I need though is a more easily parsable output to get to just the `content` directory. Enter the `porcelin` flag which, per the docs

> Give the output in an easy-to-parse format for scripts. This is similar to the short output, but will remain stable across Git versions and regardless of user configuration. See below for details.

which is exactly what I needed.

Running `git status --porcelain` you get this:

```
❯ git status --porcelain
?? content/productivity/more-writing-automation.md
```

Now, I just need to get the file itself, which I can by piping in the results and using `sed`

```
❯ git status --porcelain | sed s/^...//
content/productivity/more-writing-automation.md
```



and the format of my markdown files looks like this:

```
Title:
Date:
Tags:
Slug:
Series:
Authors: ryan
Status: draft
```


```
git status --porcelain | sed s/^...// | xargs head -7 | grep 'Title: ' | sed -e 's/Title: //g'
```
