Title: Using justpath to go on a pyrrhic adventure to clean up my PATH
Date: 2024-05-24
Author: ryan
Tags: just, path
Slug: using-justpath-to-go-on-a-pyrrhic-adventure-to-clean-up-my-path
Status: published


A while ago I heard about a project called [justpath](https://github.com/epogrebnyak/justpath) from [Jeff Tripplet](https://mastodon.social/@webology) on [Mastodon](https://mastodon.social/@webology/112403455881574563). It seemed like a neat project to try and clean up my path and I figured, what the heck, let me give it a try.

I installed it and when I ran it for the first time, the output looked like this

```
 1 /Users/ryan/.cargo/bin
 2 /usr/local/opt/ruby/bin (resolves to /usr/local/Cellar/ruby/3.2.2_1/bin)
 3 /Users/ryan/google-cloud-sdk/bin
 4 /Users/ryan/.pyenv/shims
 5 /opt/homebrew/Cellar/pyenv-virtualenv/1.2.3/shims
 6 /opt/homebrew/bin
 7 /opt/homebrew/sbin
 8 /Library/Frameworks/Python.framework/Versions/3.12/bin
 9 /usr/local/bin (duplicates: 3)
10 /usr/local/sbin
11 /Library/Frameworks/Python.framework/Versions/3.11/bin
12 /Library/Frameworks/Python.framework/Versions/3.10/bin
13 /usr/local/bin (duplicates: 3)
14 /System/Cryptexes/App/usr/bin (resolves to /System/Volumes/Preboot/Cryptexes/App/usr/bin)
15 /usr/bin
16 /bin
17 /usr/sbin
18 /sbin
19 /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin (resolves to /private/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin, directory does not exist)
20 /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin (resolves to /private/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin, directory does not exist)
21 /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin (resolves to /private/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin, directory does not exist)
22 /opt/X11/bin
23 /Library/Apple/usr/bin
24 /Library/TeX/texbin (resolves to /usr/local/texlive/2024basic/bin/universal-darwin)
25 /usr/local/share/dotnet
26 ~/.dotnet/tools (directory does not exist)
27 /Library/Frameworks/Mono.framework/Versions/Current/Commands (resolves to /Library/Frameworks/Mono.framework/Versions/6.12.0/Commands)
28 /Applications/Postgres.app/Contents/Versions/latest/bin (resolves to /Applications/Postgres.app/Contents/Versions/14/bin)
29 /Applications/Xamarin Workbooks.app/Contents/SharedSupport/path-bin (directory does not exist)
30 /Users/ryan/.local/bin (duplicates: 2)
31 /usr/local/bin (duplicates: 3)
32 /Users/ryan/.local/bin (duplicates: 2)
```

That's a lot to look at, but helpfully there are a few flags to get only the 'bad' items

	justpath --invalid

	justpath --duplicates

Running `justpath --invalid` got this

```
18 /var/run/com.apple.security.cryptexd/codex.system/bootstrap/ usr/local/bin (resolves to /private/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin, directory does not exist)
19 /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin (resolves to /private/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin, directory does not exist)
20 /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin (resolves to /private/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin, directory does not exist)
26 ~/.dotnet/tools (directory does not exist)
29 /Applications/Xamarin Workbooks.app/Contents/SharedSupport/path-bin (directory does not exist)
```

and running `justpath --duplicates` got this

```
 8 /usr/local/bin (duplicates: 3)
12 /usr/local/bin (duplicates: 3)
30 /Users/ryan/.local/bin (duplicates: 2)
31 /usr/local/bin (duplicates: 3)
32 /Users/ryan/.local/bin (duplicates: 2)
```

Great! Now I know what is invalid and what is duplicated. Surely `justpath` will have a command to clean this up, right?

![Anakin Padmeme Meme]({static}/images/justpath-anakin-padme-meme.jpg)

Turns out not so much, and for good [reasons](https://www.reddit.com/r/Python/comments/1aehs4i/comment/kk89bor/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button):

> `justpath` does not alter the path itself, it provides the corrected version that a user can apply further. A child process the one that Python is running in cannot alter the parent environment PATH. As for reading the PATH - `justpath` relies on what is available from `os.environ['PATH']`.

So I posted on Mastodon to see how others may have approached this and Jeff [replied back](https://mastodon.social/@webology/112403455881574563)

> I ran the tool and copied the output before starting from an empty PATH.

> Then I ran justpath and added them back one at a time.

> mise helped me cut at least half a dozen weird/duplicate path statements alone. I had quite a bit of tool overlap.

I poked around with trying to find where the invalid values were coming from and found [this](https://apple.stackexchange.com/a/458280) answer

> Cryptexes are used to update parts of macOS quickly, without requiring a full rebuild of the SSV (see [this](https://eclecticlight.co/2023/04/05/how-cryptexes-are-changing-macos-ventura/) answer for details).
> I don't know whether removing these paths will break the installation of such cryptexes. But if you want to take the risk, you can remove `/etc/paths.d/10-cryptex` (or move it to a safe place in case you need it later on).
> PS: Invalid entries in PATH don't really hurt, they primarily slow down (a very little bit) the lookup of new commands run from the shell the first time.

This supported my assumption that the invalid PATH variables were likely due to macOS upgrades (I guessed that based on the existence of invalid PATH variables on other Macs in my house that didn't have a programmer / developer using them)

So, with that I found 2 files that were in `/etc/paths.d` and moved them to my desktop. Once that was done I restarted my terminal and got this output

```
 1 /Users/ryan/.cargo/bin
 2 /usr/local/opt/ruby/bin (resolves to /usr/local/Cellar/ruby/3.2.2_1/bin)
 3 /Users/ryan/google-cloud-sdk/bin
 4 /Users/ryan/.pyenv/shims
 5 /opt/homebrew/Cellar/pyenv-virtualenv/1.2.3/shims
 6 /opt/homebrew/bin
 7 /opt/homebrew/sbin
 8 /Library/Frameworks/Python.framework/Versions/3.12/bin
 9 /usr/local/bin (duplicates: 3)
10 /usr/local/sbin
11 /Library/Frameworks/Python.framework/Versions/3.11/bin
12 /Library/Frameworks/Python.framework/Versions/3.10/bin
13 /usr/local/bin (duplicates: 3)
14 /System/Cryptexes/App/usr/bin (resolves to /System/Volumes/Preboot/Cryptexes/App/usr/bin)
15 /usr/bin
16 /bin
17 /usr/sbin
18 /sbin
19 /opt/X11/bin
20 /Library/Apple/usr/bin
21 /Library/TeX/texbin (resolves to /usr/local/texlive/2024basic/bin/universal-darwin)
22 /usr/local/share/dotnet
23 /Library/Frameworks/Mono.framework/Versions/Current/Commands (resolves to /Library/Frameworks/Mono.framework/Versions/6.12.0/Commands)
24 /Applications/Postgres.app/Contents/Versions/latest/bin (resolves to /Applications/Postgres.app/Contents/Versions/14/bin)
25 /Users/ryan/.local/bin (duplicates: 2)
26 /usr/local/bin (duplicates: 3)
27 /Users/ryan/.local/bin (duplicates: 2)
```

This just left the duplicates that were being added. There are a few spots where applications (or people!) will add items to PATH and there are MANY opinions on which one is The Right Way TM. I use [zshell](https://en.wikipedia.org/wiki/Z_shell) and looked in each of these files (`~/.profile`, `~/.zshrc`, `~/.zprofile`) and found that only my `.zshrc` file contained the addition to PATH for the duplicates I was seeing

- `/usr/local/bin`
- `/Users/ryan/.local/bin`

With that, I simply commented them out of my `.zshrc`, restarted my terminal and now I am down to only two duplicates duplicate

```
 8 /usr/local/bin (duplicates: 2)
12 /usr/local/bin (duplicates: 2)
```

I looked *everywhere* trying to find where this duplicate was coming from. I tried a few variations of `find`

```
find . -type f -name '.*' 2>/dev/null -exec grep -H '/usr/local/bin' {} \;
```

But the results were only the commented out lines from `.zshrc`.

I did find [this issue](https://github.com/Homebrew/brew/issues/14560) on the Homebrew repo and thought I might be onto something, but it was for a different path so that doesn't seem to be **the** culprit.

I eventually gave up on trying to find the one true source of the duplicate entry (though I suspect that there is something adding it in the same way that Homebrew is can add a duplicate PATH variable) because I [found](https://stackoverflow.com/a/30792333) this command

	typeset -U path

I added it to my `.zshrc`, restarted my terminal and voila, a clean PATH

```
 1 /Users/ryan/.cargo/bin
 2 /Users/ryan/google-cloud-sdk/bin
 3 /Users/ryan/.pyenv/shims
 4 /opt/homebrew/Cellar/pyenv-virtualenv/1.2.3/shims
 5 /opt/homebrew/bin
 6 /opt/homebrew/sbin
 7 /Library/Frameworks/Python.framework/Versions/3.12/bin
 8 /usr/local/bin
 9 /usr/local/sbin
10 /Library/Frameworks/Python.framework/Versions/3.11/bin
11 /Library/Frameworks/Python.framework/Versions/3.10/bin
12 /System/Cryptexes/App/usr/bin (resolves to /System/Volumes/Preboot/Cryptexes/App/usr/bin)
13 /usr/bin
14 /bin
15 /usr/sbin
16 /sbin
17 /opt/X11/bin
18 /Library/Apple/usr/bin
19 /Library/TeX/texbin (resolves to /usr/local/texlive/2024basic/bin/universal-darwin)
20 /usr/local/share/dotnet
21 /Library/Frameworks/Mono.framework/Versions/Current/Commands (resolves to /Library/Frameworks/Mono.framework/Versions/6.12.0/Commands)
22 /Applications/Postgres.app/Contents/Versions/latest/bin (resolves to /Applications/Postgres.app/Contents/Versions/16/
```

I still want to try and figure out where that extra `/usr/local/bin` is coming from, but for now, I have been able to clean up my PATH.

So, the question is, does this really matter? In the [answer](https://apple.stackexchange.com/a/458280) I found the last statement really caught my attention

> PS: Invalid entries in PATH don't really hurt, they primarily slow down (a very little bit) the lookup of new commands run from the shell the first time.

So the answer is, probably not, BUT just knowing that I had duplicates and invalid entries in my PATH was like a splinter in my brain [ref]Yes, that is a Matrix reference[/ref] that needed to be excised.

What are your experiences with your PATH? Have you gone to these lengths to clean it up, figured, "Meh, it's not hurting anything, why bother?"
