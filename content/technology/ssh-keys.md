Title: SSH Keys
Date: 2024-07-11
Author: ryan
Tags: tutorial, ssh keys
Slug: ssh-keys
Status: published

# SSH Keys

If you want to access a server in a 'passwordless' way, the best approach I know is to use SSH Keys. This is great, but what does that mean and how do you set it up?

I'm going to attempt to write out the steps for getting this done.

Let's assume we have two servers, `web1` and `web2`. These two servers have 1 non-root user which I'll call `user1`.

So we have something like this

- `user1@web1`
- `user1@web2`

Suppose we want to allow user1 from web2 to access web1.

At a high level, we need to allow SSH access to web1 for user1 on web2 we need to:

1. Create `user1` on `web1`
2. Create `user1` on `web2`
3. Create SSH keys on `web2` for `user1`
4. Add the public key for `user1` from `web2` to onto the `authorized_keys` for for `user1` on `web1`

OK, let's try this. I am using DigitalOcean and will be taking advantage of their CLI tool `doctl`

To create a droplet, there are two required arguments.:

- image
- size

I'm also going to include a few other options

- tag
- region
- ssh-keys[ref]I'm using these keys so that I can gain access to the server as root[/ref]

Below is the command to use to create a server called `web-t-001`

```
doctl compute droplet create web-t-001 \
  --image ubuntu-24-04-x64 \
  --size s-1vcpu-1gb \
  --enable-monitoring \
  --region sfo2 \
  --tag-name test \
  --ssh-keys $(doctl compute ssh-key list --output json | jq -r 'map(.id) | join(",")')
```

and to create a server called `web-t-002`

```
doctl compute droplet create web-t-002 \
  --image ubuntu-24-04-x64 \
  --size s-1vcpu-1gb \
  --enable-monitoring \
  --region sfo2 \
  --tag-name test \
  --ssh-keys $(doctl compute ssh-key list --output json | jq -r 'map(.id) | join(",")')
```

The values for the `ssh-keys` above will get all of the ssh-keys I have stored at DigitalOcean and add them.

The output looks something like:

> --ssh-keys 1234, 4567, 6789, 1222

Now that we've created two droplets called `web-t-001` and `web-t-002` we can set up user1 on each of the servers.

I'll SSH as root into each of the servers and create `user1` on each (I can do this because of the ssh keys that were added as part of the droplet creation)

- `adduser --disabled-password --gecos "User 1" user1 --home /home/user1`

I then switch to `user1`

`su user1`

and run this command

`ssh-keygen -q -t rsa -b 2048 -f /home/user1/.ssh/id_rsa -N ''`

This will generate two files in `~/.ssh without any prompts`:

- `id_rsa`
- `id_rsa.pub`

The `id_rsa` identifies the computer. This is the Private Key. It should NOT be shared with anyone!

The `id_rsa.pub`. This is the Public Key. It CAN be shared.

The contents of the `id_rsa.pub` file will be used for the `authorized_keys` file on the computer this user will SSH into.

OK, what does this actually look like?

On `web-t-002`, I get the content of `~/.ssh/id_rsa.pub` for `user1` and copy it to my clipboard.

Then from `web-t-001` as `user1` I paste that into the the `authorized_keys` in `~/.ssh`. If the file isn't already there, it needs to be created.

This tells `web-t-001` that a computer with the private key that matches the public key is allowed to access as `user1`

The implementation of this is to be on `web-t-002` as `user1` and then run the command

	ssh user1@web-t-001

The first time this is done, a prompt will come up that looks like this:

	The authenticity of host 'xxx.xxx.xxx.xxx (xxx.xxx.xxx.xxx)' can't be established.
	ED25519 key fingerprint is SHA256:....
	This key is not known by any other names.
	Are you sure you want to continue connecting (yes/no/[fingerprint])?

This ensure that you know which computer you're connecting to and you want to continue. This helps to prevent potential man-in-the-middle attacks. When you type `yes` this creates a file called `known_hosts`

OK, so where are we at? The table below shows the files, their content, and their servers

| Server | id_rsa | id_rsa.pub | authorized_keys | known_hosts |
|---|---|---|---|---|
| web-t-001 | private key | ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFwHs8VKWWSH737fVz4cs+5Eq8OcRJRf2ti0ytaChM1ySh2+olcKokHao3fl5G+ZZv4pQeKfCh8ClFP86g7rZN1evu2EFVlmBo1Ked4IwF4UBY2+rnfZmvxeHd+smtyZgfVZI/6ySfe1D+inAqv7otsMsNRRuE4aG0DNEJ39qwFxukGNcDXk9RNVvmwbCc5zT/HN0yMJ6Y7KtfPZgjl5v854VodZkfxsLpah7Bn64zAQr/xDh2KcWbtDrsvTdjNMPY7oW20VoqDs98mA6xAw9RNMI+xotNmivdWdv3BEYj9JyH61euTBQ27HC4LsOPuCOFKBqOwGXiJhpzvJZbNCcvQEztem3kqQFAPLg+4wBInyxnY2i31QX7+2IJs0a4pYTWRSRcrvwBAvi2GlXGltrZ7V6KOLzwBrXLD7XiO3C5kO5fcpanKlm/RdVAxUTjUq159H+v9om8HAgX/pIpYBpPnRrG7setNQVzDNQsxfR/YC0h+f9LWnnaBV6+51IjbaqAPSSf6KYv0AKO5XNlJsSTXNRBZaRvrfr0qllgXU82f9y8Eb0sgjL71wD9Fv24fV0toFW8PH3yOeePC6d7kNqZkFdSBksChzqagZwPudYnVhMmhMYV7k1v831H8WHdGPVRe9Z3BDnSCzf8o8fRS3mSEAJBiT30bXlGWUNopIpsgw== user1@ahc-web-t-001 | ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCbx+wTVEcdy2Uu2iB+u6+R8Q0yH9ws92GM6K/XXmAXoUuXylkdJzw9vUeuaZTmGxwGRdp+lLh+vVDmiuzrUPjbkFA7Y1SxfR5lgJu7PviDDZzsFeUo5fqSp6FOC5x75jOjqy6fc68GzOnoxk4WR6EWKWRd+xqdgCTGWiuhfUEl1lw7YN8MUhd1Hi0Ef55ZpH133jCzffWbkLFFInyIwuzG6jaPsobNPRshvg9kUoFwo5WqCx/s8Zk4iVl86yCwoV+pXjiubLylSKF7hb7uDE4Ll8gADOtuXUqmc470yvzSxxI4yaZOFz4Ajo1qZHgscSOxWgb+ZVIOKhGK5ftHPaZ4CCxXuhW5J8L3Aqs0WQeRu9Goof83V/ruZhzgg1vnhmC2511QSS2dL6U7n2JNLtNnXNjeSQ0BGVlY1FuZRczmAxN9nJETmRCdUfiTwKdPS4LdfAwrnckPHKtk1QoFKietLwfbmipU+pGvt6qKpKeRfZ/XGbG+ZiQ7oPiqcYU/eh54IAUxxo9CvVHtn742A4ABqK5+0MJP5VuY3fcDU8dIvA0r4LpxRpG/KSB4yZMUhjf+KR7QUpN3mJIDOKTDAxpGOqpNoD2gTYGpyT13AdrRROpOjOJZJqDiVi6m6r/U+sIgqymsxDqBur5+n4VxvvXbdNd+6vz7AI12WA8I8+0xZw== user1@ahc-web-t-002 | NULL |
| web-t-002 | private key | ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCbx+wTVEcdy2Uu2iB+u6+R8Q0yH9ws92GM6K/XXmAXoUuXylkdJzw9vUeuaZTmGxwGRdp+lLh+vVDmiuzrUPjbkFA7Y1SxfR5lgJu7PviDDZzsFeUo5fqSp6FOC5x75jOjqy6fc68GzOnoxk4WR6EWKWRd+xqdgCTGWiuhfUEl1lw7YN8MUhd1Hi0Ef55ZpH133jCzffWbkLFFInyIwuzG6jaPsobNPRshvg9kUoFwo5WqCx/s8Zk4iVl86yCwoV+pXjiubLylSKF7hb7uDE4Ll8gADOtuXUqmc470yvzSxxI4yaZOFz4Ajo1qZHgscSOxWgb+ZVIOKhGK5ftHPaZ4CCxXuhW5J8L3Aqs0WQeRu9Goof83V/ruZhzgg1vnhmC2511QSS2dL6U7n2JNLtNnXNjeSQ0BGVlY1FuZRczmAxN9nJETmRCdUfiTwKdPS4LdfAwrnckPHKtk1QoFKietLwfbmipU+pGvt6qKpKeRfZ/XGbG+ZiQ7oPiqcYU/eh54IAUxxo9CvVHtn742A4ABqK5+0MJP5VuY3fcDU8dIvA0r4LpxRpG/KSB4yZMUhjf+KR7QUpN3mJIDOKTDAxpGOqpNoD2gTYGpyT13AdrRROpOjOJZJqDiVi6m6r/U+sIgqymsxDqBur5+n4VxvvXbdNd+6vz7AI12WA8I8+0xZw== user1@ahc-web-t-002 | NULL | \|1\|V6uYGlSiYXpzFAly9RQHybzl07o=\|VUkDfRcKGyUgLdJn+iw6RJE+r68= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILpbPHA1jL0MHzBI8qb2X0mHDx3UlrKCdbz1IspvaJW9  \|1\|dshOpqJI2zQxEpj1pleDmtkijIY=\|ZYV8bCeLNDdyE7STDPaO2TzYUEQ= ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnGgQUmsCG23b6iYxRHq5MU9xd8Q/p8j3EyZn9hvs4IsBoCgeNXjyXK28x7Mt7tmfjrF/4jLcq4o2TTAwF6eVQZ4KXoBa73dYqYDmYTVKTwzZL9CsJTWHTsSnU8V/J3Tml+hIFrjZzWP34+lL9xyOVin5R0PT/OCG49ecb5tt2FxTZeyWI47B/bCDGXV9g1tjZ8+mnbLXpIdQ9+6GllRZrEGvXWm6z/U3YHO84dcG0IZJ7QsEaAiLSBC/t83So4MDQgdttm+aHZXds4jej5E3QwUex8JkVVn0X7Nr4yKMDkSk7ABD6AFhpa4ESXysqI33CUaSBROAuu4lmfOkLmyRZK2vQ6soiOW8iBgCEl/q8MSOEpZeAi3faYbUnOpLzLDBcCoAuSDoexrTixxlhJmRDeS3PlcXmzvkJl7RRKUYZZcPQOd2w9ipCIAD1PevNlnmmZcfkRe0RRvAyF1mqcO/x5Ovtq9QLbycFHYfh/3LcPuDOWBtT+mVd5FeNUMsZ6+8=  \|1\|HJd+aDFM66x8jJT1zUZV59ceL10=\|PfHQu/Yg35QPBKk7FvNO/46b76o= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBP+XwUozGye03WJ6zC7yoJQaYF8HiUQKmZwnQO0wSxMm9x9nBdPEx1bmyZHHUbMnwQnoeAMmd6hgK6H8hbxzEas= |

OK, so now we have set it up so that `user1` on `web-t-002` can access `web-t-001` as `user1`. A reasonable question to ask at this point might be, can I go the other way without any extra steps?

Let's try it and see!

From `web-t-001` as `user1` lets run

	ssh user1@web-t-002

And see what happens

We get the same warning message we got before, and if we enter `yes` we then see

	user1@yyy.yyy.yyy.yyy: Permission denied (publickey).

What's going on?

We haven't added the public key for `user1` from `web-t-002` to the `authorized_keys` file on `web-t-001`.

Let's do that now.

Similar to before we'll get the content of the id_rsa.pub from `web-t-001` for `user1` and copy it to the `authorized_keys` file on `web-t-002` for `user1`.

When we do this we are now able to connect to `web-t-002` from `web-t-001` as `user1`

OK, SSH has 4 main files involved:

- `id_rsa.pub` (public key): The SSH key pair is used to authenticate the identity of a user or process that wants to access a remote system using the SSH protocol. The public key is used by both the user and the remote server to encrypt messages.
- `id_rsa` (private key): The private key is secret, known only to the user, and should be encrypted and stored safely
- `known_hosts`: stores the public keys and fingerprints of the hosts accessed by a user
- `authorized_keys`: file containing all of the authorized public keys that have been generated. This is what tells the server that it’s Ok to use the key to allow a connection

## Using with GHA

### ssh-action from AppleBoy

A general way to access your server with GHA (say for CICD) is to use the [GitHub action from appleboy](https://github.com/appleboy/ssh-action) called `ssh-action`

There are 3 key components needed to get this to work:

1. host
2. username
3. key

Each of these can/should be put into repository secrets. Setting those up is outside the scope of this article. For details on how to set repository secrets, see [this](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions) article.

Using the servers from above we could set up the following secrets

- SSH_HOST: web-t-001 IP Address
- SSH_KEY: the content from /home/user1/.ssh/id_rsa ( from web-t-002 )
- SSH_USERNAME: user1

And then set up an GitHub Action like this

```yaml
name: Test Workflow

on:
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-22.04
    steps:
      - name: deploy code
        uses: appleboy/ssh-action@v0.1.10
        with:
          host: ${{ secrets.SSH_HOST }}
          port: 22
          key: ${{ secrets.SSH_KEY }}
          username: ${{ secrets.SSH_USERNAME }}

          script: |
            echo "This is a test" >  ~/test.txt
```

Using this set up we've made the docker image that runs the GHA to be (basically) known as `web-t-001` and it has access as `user1` in the same way we did in the terminal.

When this action is run it will ssh into `web-t-001` as `user1` and create a file called `test.txt` in the home directory. The content of that file will be "This is a test"
