Title: Making it easy to ssh into a remote server
Date: 2018-05-05 12:54
Author: ryan
Tags: digital ocean, linux, Remote servers, SSH, Terminal
Slug: making-it-easy-to-ssh-into-a-remote-server
Status: published

Logging into a remote server is a drag. Needing to remember the password (or get it from [1Password](https://1password.com)); needing to remember the IP address of the remote server. Ugh.

It’d be so much easier if I could just

    ssh username@servername

and get into the server.

And it turns out, you can. You just need to do two simple things.

## Simple thing the first: Update the `hosts` file on your local computer to map the IP address to a memorable name.

The `hosts` file is located at `/etc/hosts` (at least on \*nix based systems).

Go to the hosts file in your favorite editor … my current favorite editor for simple stuff like this is vim.

Once there, add the IP address you don’t want to have to remember, and then a name that you will remember. For example:

    67.176.220.115    easytoremembername

One thing to keep in mind, you’ll already have some entries in this file. Don’t mess with them. Leave them there. Seriously … it’ll be better for everyone if you do.

## Simple thing the second: Generate a public-private key and share the public key with the remote server

From the terminal run the command `ssh-keygen -t rsa`. This will generate a public and private key. You will be asked for a location to save the keys to. The default (on MacOS) is `/Users/username/.ssh/id_rsa`. I tend to accept the default (no reason not to) and leave the passphrase blank (this means you won’t have to enter a password which is what we’re looking for in the first place!)

Next, we copy the public key to the host(s) you want to access using the command

    ssh-copy-id <username>@<hostname>

for example:

    ssh-copy-id pi@rpicamera

The first time you do this you will get a message asking you if you’re sure you want to do this. Type in `yes` and you’re good to go.

One thing to note, doing this updates the file `known_hosts`. If, for some reason, the server you are ssh-ing to needs to be rebuilt (i.e. you have to keep destroying your Digital Ocean Ubuntu server because you can’t get the static files to be served properly for your Django project) then you need to go to the `known_hosts` file and remove the entry for that known host.

When you do that you’ll be asked about the identity of the server (again). Just say yes and you’re good to go.

If you forget that step then when you try to ssh into the server you get a nasty looking error message saying that the server identities don’t match and you can’t proceed.
