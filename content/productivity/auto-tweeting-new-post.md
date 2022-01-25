Title: Auto Tweeting New Post
Date: 2022-01-21 05:40
Tags: "GitHub Actions"
Slug: auto-tweeting-new-post
Series: Auto Deploying my Words
Authors: ryan
Status: published

Each time I write something for this site there are several steps that I go through to make sure that the post makes it's way to where people can see it.

1. Run `make html` to generate the SQLite database that powers my site's search tool[ref]`make vercel` actually runs `make html` so this isn't really a step that I need to do.[/ref]
2. Run `make vercel` to deploy the SQLite database to vercel
3. Run `git add <filename>` to add post to be committed to GitHub
4. Run `git commit -m <message>` to commit to GitHub
5. Post to Twitter with a link to my new post

If there's more than 2 things to do, I'm totally going to forget to do one of them.

The above steps are all automat-able, but the one I wanted to tackle first was the automated tweet. Last night I figured out how to tweet with a GitHub action.

There were a few things to do to get the auto tweet to work:

1. Find a GitHub in the Market Place that did the auto tweet (or try to write one if I couldn't find one)
2. Set up a twitter app with Read and Write privileges
3. Set the necessary secrets for the report (API Key, API Key Secret, Access Token, Access Token Secret, Bearer)
4. Test the GitHub Action

The action I chose was [send-tweet-action](https://github.com/ethomson/send-tweet-action). It's got easy to read [documentation](https://github.com/ethomson/send-tweet-action/blob/main/README.md) on what is needed. Honestly the hardest part was getting a twitter app set up with Read and Write privileges.

I'm still not sure how to do it, honestly. I was lucky enough that I already had an app sitting around with Read and Write from the WordPress blog I had previously, so I just regenerated the keys for that one and used them.

The last bit was just testing the action and seeing that it worked as expected. It was pretty cool running an action and then seeing a tweet in my timeline.

The TIL for this was that GitHub Actions can have conditionals. This is important because I don't want to generate a new tweet each time I commit to main. I only want that to happen when I have a new post.

To do that, you just need this in the GitHub Action:

```
    if: "contains(github.event.head_commit.message, '<String to Filter on>')"
```

In my case, the `<String to Filter on>` is `New Post:`.

The `send-tweet-action` has a `status` field which is the text tweeted. I can use the `github.event.head_commit.message` in the action like this:

```
    ${{ github.event.head_commit.message }}
```

Now when I have a commit message that starts 'New Post:' against `main` I'll have a tweet get sent out too!

This got me to thinking that I can/should automate all of these steps.

With that in mind, I'm going to work on getting the process down to just having to run a single command. Something like:

```
    make publish "New Post: Title of my Post https://www.ryancheley.com/yyyy/mm/dd/slug/"
```
