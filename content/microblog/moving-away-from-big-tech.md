Title: Moving Away from Big Tech
Date: 2025-02-02
Author: ryan
Tags:
Slug: moving-away-from-big-tech
Series: Remove if Not Needed
Status: published

I'm trying to get off of Google and other large Tech company platforms this year. It's going to be a year(s) long journey i'm pretty sure, but today I was able to at least get the list of my accounts that use gmail as the email address. It was relatively straight forward, with a little help from Claude, to get me what I wanted.

I use 1Password as my password manager, and while it's search feature is robust, I just really wanted a table of accounts. That is, I wanted to have the name, URL, Vault, and any Tags associated with the account

I used this to get what I was after

```bash
op item list --categories Login --format=json | jq -r '(["Title", "Email", "Vault", "URL", "Tags"] | @csv), (.[] | select(.additional_information == "myemail@gmail.com") | [.title, .additional_information, .vault.name, .urls[0].href, .tags] | @csv)' > accounts.csv
```

Now I have a list of the accounts that use my gmail account and I can start working my way through them. My plan is to start with the non-essential accounts. That is, the ones that I haven't used, am not sure what they are, aren't important anymore kinds of things. Once i have that done I'll start getting into the scary ones ... like my financial accounts.

There are many things in life I'm glad to have done, but was not glad to be doing them at the time. This is going to be one of those things i'm pretty sure

As a quick aside, yesterday I de-Meta-fied my life by deleting my Facebook, Instagram, and What's App accounts.
