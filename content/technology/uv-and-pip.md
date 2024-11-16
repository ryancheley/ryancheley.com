Title: uv and pip
Date: 2024-11-23
Author: ryan
Tags: pip, python, uv
Slug: uv-and-pip
Series: Remove if Not Needed
Status: published

On Sunday November 3 I posted [this](https://mastodon.social/@ryancheley/113420509533590631) to Mastodon:

> I've somehow managed to get Python on my macbook to not install packages into the virtual environment I've activated and I'm honestly not sure how to fix this.
>
> Has anyone else ever run into this problem? If so, any pointers on how to fix it?

I got lots of helpful replies and with those replies I was able to determine what the issue was and 'fix' it.

## A timeline of events

I was working on updating a [library of mine](https://github.com/ryancheley/the-well-maintained-test) and because it had been a while since it had been worked on, I had to git clone it locally. When I did that I then set out to try `uv` for the virtual environment management.

This worked well (and was lightning FAST) and I was hacking away at the update I wanted to do.

Then I had a call with my daughter to review her upcoming schedule for the spring semester. When I got back to working on my library I kind of dove right in and started to get an error messages about the library not being installed

	zsh: command not found: the-well-maintained-test

So I tried to install it (though I was 100% sure it was already there) and got this message

	ERROR: Could not find an activated virtualenv (required).

I deleted the venv directory and started over again (using `uv` still) and ran into the same issue.

I restarted my Mac (at my day job I use Windows computers and this is just a natural reaction to do when something doesn't work the way I think it should[ref]Yes this is dumb, and yes I hate it[/ref])

That didn't fix the issue 😢

I spent the next little while certain that in some way `pipx` or `pyenv` had jacked up my system, so I uninstalled them ... now you might ask *why* I thought this, and dear reader, I have no f$%&ing clue.

With those *pesky* helpers out of the way, `pip` still wasn't working the way I expected it to!

I then took to Mastodon and with this [one response](https://fosstodon.org/@browniebroke/113420548462836451) I saw what I needed

> @ryancheley Are you running python -m pip install... Or just pip install...? If that's a venv created by uv, pip isn't installed I think, so 'pip install' might resolve to a pip in a different python installation

I went back to my terminal, and sure enough that was the issue. I haven't used `uv` enough to get a real sense of it, and when I was done talking with my daughter, my brain switched to Python programming, but it forgot that I had used `uv` to set everything up.

## Lessons learned

This was a good lesson but I'm still unsure about a few things:

1. How do I develop a cli using `uv`?
2. Why did it seem that my cli testing worked fine right up until the call with my daughter, and now it seems that I can't develop cli's with `uv`?

I did write a [TIL](https://github.com/ryancheley/til/blob/main/uv/uv-venv.md) for this but I discovered that

```bash
uv venv venv
```

is not a full replacement for

```bash
python -m venv venv
```

Specifically `uv` does not include `pip`, which is what contributed to my issues. You **can** include `pip` by running this command though

```bash
uv venv venv --seed
```


Needless to say, with the help of some great people on the internet I got my issue resolved, but I did spend a good portion of Monday evening un-f$%&ing my MacBook Pro by reinstalling pyenv, and pipx[ref]As of this writing I've uninstalled pipx because `uv` can replace it too. See Jeff Triplett's post [uv does everything](https://micro.webology.dev/2024/11/03/uv-does-everything.html)[/ref] ... and cleaning up my system Python for 3.12 and 3.13 ... turns out Homebrew REALLY doesn't want you to do anything with the system Python, even if you accidentally installed a bunch of cruft in there accidentally.
