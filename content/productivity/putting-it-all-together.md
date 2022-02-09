Title: Putting it All Together
Date: 2022-02-09
Author: ryan
Tags: Automation
Slug: putting-it-all-together
Series: Auto Deploying my Words
Status: published

In this final post I'll be writing up how everything fits together. As a recap, here are the steps I go through to create and publish a new post

# Create Post

1. Create `.md` for my new post
2. write my words
3. edit post
4. Change `status` from `draft` to `published`

## Publish Post

1. Run `make html` to generate the SQLite database that powers my site's search tool[ref]`make vercel` actually runs `make html` so this isn't really a step that I need to do.[/ref]
2. Run `make vercel` to deploy the SQLite database to vercel
3. Run `git add <filename>` to add post to be committed to GitHub
4. Run `git commit -m <message>` to commit to GitHub
5. Post to Twitter with a link to my new post

My previous posts have gone over how each step was automated, but now we'll 'throw it all together'.

I updated my `Makefile` with a new command:

```
tweet:
	./tweet.sh
```

When I run `make tweet` it will calls `tweet.sh`. I wrote about the `tweet.sh` file in [Auto Generating the Commit Message](https://www.ryancheley.com/2022/01/28/auto-generating-the-commit-message/) so I won't go deeply into here. What it does is automate steps 1 - 5 above for the `Publish Post` section above.

And that's it really. I've now been able to automate the file creation and publish process.

Admittedly these are the 'easy' parts. The hard part is the actual writing, but it does remove a ton pf potential friction from my workflow and this will **hopefully** lead to more writing this year.
