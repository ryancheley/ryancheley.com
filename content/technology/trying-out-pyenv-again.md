Title: Trying out pyenv ... again
Date: 2024-03-29
Author: ryan
Tags: python, pyenv
Slug: trying-out-pyenv-again
Status: published

I *think* I first tried `pyenv` probably sometime in late 2022. I saw some recent stuff about it on Mastadon and thought I'd give it another go.

I read through the [installation instructions at the ReadMe](https://github.com/pyenv/pyenv/#installation) at the repo and checked to see if it was already installed (spoiler alert it was!)

I noticed that I was not on the current version (2.3.36 at the time of this writing) and decided that I needed to [update it](https://docs.brew.sh/FAQ#how-do-i-update-my-local-packages).

With the update out of the way I tried to install a version of Python with it, starting at Python 3.10 (becasue why not?!)

```
pyenv install 3.10
```

But when I ran it I got an error like this:

```
BUILD FAILED (OS X 12.3.1 using python-build 20180424)
```

Which lead me [here](https://github.com/pyenv/pyenv/issues/2343). There were some comments people left about deleting directories (which always makes me a bit uneasy ... espcially when they're in /Library/)

Reading further down I did come across [this comment](https://github.com/pyenv/pyenv/issues/2343#issuecomment-1627994171)

> I had to uninstall and reinstall Home Brew before it returned to work. It concerned the change from Mac Intel to Mac M1(Silicon).
> See the article below from Josh Alletto to find out why. https://earthly.dev/blog/homebrew-on-m1/#:~:
text=On%20Intel%20Macs
%2C%20Homebrew%2C%20and,
%2Fusr%2Flocal%2Fbin%20.&text=
Homebrew%20chose%20%2Fusr
%2Flocal%2F,in%20your%20PATH%20by%20default.

The link in the comment was a bit malformed, but I was able to clean it up and get this [link](https://earthly.dev/blog/homebrew-on-m1/). This is where I re-discovered[ref]earlier in the day I was working through a [post by Marijke about Caddy](https://marijkeluttekes.dev/blog/articles/2024/03/25/custom-localhost-urls-with-caddyfile-on-macos/) and there was a statement in her write up about how Homebrew on the M1 Macs stored files in a different directory, but when I ran the command to check where Homebrew was pointing I got the Intel location, not the Apple Silicon location ... this really should have been my first clue that some part of my set up was incorrect[/ref] that the way Homebrew is installed changed with the transition to the Apple Silicon.

Now, I got a new M2 MacBook Pro in March 2023 and since I don't use Homebrew a lot AND I didn't really use pyenv for anything, I hadn't noticed that stuff kind of changed.

Following the steps outlined I was able to redo my Homebrew and now have pyenv working. Now, the only question is will it's use 'stick' with me this time?
