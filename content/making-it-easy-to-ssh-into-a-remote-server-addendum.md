Title: Making it easy to ssh into a remote server: Addendum
Date: 2019-03-25 18:30
Author: ryan
Category: Technology
Tags: SSH
Slug: making-it-easy-to-ssh-into-a-remote-server-addendum
Status: published

I recently got a new raspberry pi (yes, I might have a problem) and wanted to be able to ssh into it without having to remember the IP or password. Luckily I wrote [this helpful post](/making-it-easy-to-ssh-into-a-remote-server.html) several months ago.

While it go me most of the way there, I did run into a slight issue.

## First Issue

The issue was that I had a typo for the command to generate a key. I had:

`ssh-keyken -t rsa`

Which should have been:

`ssh-keygen -t rsa`

When I copied and pasted the original command the terminal said there was no such command. 🤦‍♂️

## Second Issue

Once that go cleared up I went through the steps and was able to get everything set up. Or so I thought. On attempting to ssh into my new pi I was greeted with a password prompt. WTF?

The first thing I did was to check to see what keys were in my \~/.ssh folder. Sure enough there were a couple of them in there.

    ls ~/.ssh
    id_rsa             id_rsa.github      id_rsa.github.pub  id_rsa.pub         known_hosts        read_only_key      read_only_key.pub

Next, I interrogated the help command for `ssh-copy-id` to see what flags were available.

    Usage: /usr/bin/ssh-copy-id [-h|-?|-f|-n] [-i [identity_file]] [-p port] [[-o <ssh -o options>] ...] [user@]hostname
        -f: force mode -- copy keys without trying to check if they are already installed
        -n: dry run    -- no keys are actually copied
        -h|-?: print this help

I figured let’s try the `-n` flag and get the output from that. Doing so gave me

    ryan@Ryans-MBP:~/Desktop$ ssh-copy-id -n pi@newpi
    /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/Users/ryan/.ssh/id_rsa.github.pub"
    /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed

    /usr/bin/ssh-copy-id: WARNING: All keys were skipped because they already exist on the remote system.
            (if you think this is a mistake, you may want to use -f option)

OK … why is it sending the GitHub key? That’s a different problem for a different time. I see another flag available is the `-i` which will allow me to specify which key I want to send. Aha!

OK, now all that I need to do is use the following command to test the output:

    ssh-copy-id -n -i ~/.ssh/id_rsa.pub pi@newpi

And sure enough it’s sending the correct key

    /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/Users/ryan/.ssh/id_rsa.pub"
    /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed

    /usr/bin/ssh-copy-id: WARNING: All keys were skipped because they already exist on the remote system.
            (if you think this is a mistake, you may want to use -f option)

Remove the `-n` flag to send it for real

    ssh-copy-id -i ~/.ssh/id_rsa.pub pi@newpi

And try to ssh in again

    ssh pi@newpi

Success!

I wanted to write this up for 2 reasons:

1.  So I can refer back to it if I ever need to. This blog is mostly for me to write down technical things that I do so I can remember them later on
2.  This is the first time I’ve run into an issue with a command like tool and simply used the help to figure out how to fix the problem and I wanted to memorialize that. It felt [forking](https://thegoodplace.fandom.com/wiki/Censored_Curse_Words) awesome to do that.

Footnote: Yes … calling my new raspberry pi `newpi` in my hosts file is dumb. Yes, when I get my next new Raspberry Pi I will be wondering what to call it. YEs, I am going to try and remember to make the change before it happens so that I don’t end up with the next Pi being called `newnewpi` and the one after that being `newnewnewpi`
