Title: Atuin - The Magical Shell Tool
Date: 2026-10-29
Author: ryan
Tags: atuin, shell, history
Slug: atuin-the-magical-shell-tool
Series: learnings-on-leave
Status: published

In part two of my series, "Learning on Leave" I spent some time going through the [docs](https://docs.atuin.sh/latest/) for [Atuin](https://atuin.sh/). I even went down a rabbit hole of roling my own sync server!

## What is Atuin and why would I use it?

Atuin is "Shell history supercharged". Per their [website](https://atuin.sh/):

> Sync, search, and back up your shell history with end-to-end encryption. The magical shell tool loved by developers worldwide.

I first learned about it on Mastodon from [b0rk](https://mastodon.social/@b0rk). As an aside, she's also where I first learned about [fish](https://fishshell.com/) which is a great shell!

It's been a real game changer for me. Logging into different servers and having access to my shell history across all machines it kind of a game changer.

## Things I learned

1. `ctrl-r`

When I migrated from just the standard `zsh` history to Atuin, I was just used to pressing using `ctrl-r` to search, but Atuin offered use of the `up-arrow` key to browse through my history. This seemeed easier to me, so I started to use that exclusively and the completely forgot that `ctrl-r` ever existed 🤦🏻‍♂️

The thing is, `ctrl-r` will also allow you to cycle through the filter modes (global, host, session, directory, workspace, session-preload). This allows you to see all commands, or focus on just the session history. You can update the settings to have the history set to a specific filter mode. The default is `global` which means all of the synced history from all servers. After learning about this I decided to update mine to `host`. One note, `workspace` is only available inside a git repository or if you've set [`workspaces = false`] in your settings.


See the [docs](https://docs.atuin.sh/latest/guide/advanced-usage/#filter-mode) for more on filter mode.

See the [docs](https://docs.atuin.sh/latest/configuration/config/#workspaces) for more on workspaces


2. `ctrl-o`

While you're in the history (using `ctrl-r`) you can use `ctrl-o` to show you the history of that command. The history is limited by what your filter mode is. If you set it to `host` it will only show the history of that command on the host you're currently on

3. Agent integration

There is agent integration via `atuin hook install claude-code` and then `atuin mcp install claude-code`.

Using `atuin hook install claude-code` allows Atuin to capture commands that your agents are running. Atuin tags these so they are easy to search on our filter out.

If you want to use `atuin mcp install claude-code` you will need to have your sync server set to to Atuin's sync server, or, if you decided to roll your own sync server, you'll need to set up a self hosted agent server too.

See the [docs](https://docs.atuin.sh/latest/guide/agent-hooks/) for more details.

See the [docs](https://docs.atuin.sh/latest/ai/mcp/) for more details.


4. Deduplicating your history

There is a command that will dedup your history to clean it up if needed. Why would you want to do this if the point of Atuin is to have all of your history? It can be super helpful after you've imported your history, or if a runaway script pollutted your history. There are other use cases too I'm sure. But just knowing it's there in case it's needed is pretty nice.

An example would be

```bash
atuin history dedup --dry-run --before "2025-01-01" --dupkeep 1
```

This would perform a dry run of what would be removed for anything from before January 1, 2025. It would only keep 1 copy (the most recent) in history.

To perform the deduplication

```bash
atuin history dedup --dry-run --before "2025-01-01" --dupkeep 1
```

See the [docs](https://docs.atuin.sh/latest/guide/delete-history/#deduplicating-history) for more details.

5. Themes

Like many (all) developer tools, we have an ability to express ourselves through themes. The default, "default" is fine, but I prefer [Dracula styled themes](https://draculatheme.com/). There isn't a library of themes, but there are [good docs](https://docs.atuin.sh/latest/guide/theming/#theme-creation) on how to create your own theme.

My Dracula theme looks like this:

```toml
[theme]
name = "dracula"

[colors]
Base = "#f8f8f2"          # Dracula Foreground
Muted = "#6272a4"         # Dracula Comment/Grey
Title = "#bd93f9"         # Dracula Purple
Important = "#ff79c6"     # Dracula Pink
Guidance = "#8be9fd"      # Dracula Cyan
Annotation = "#6272a4"    # Dracula Comment/Grey
AlertInfo = "#50fa7b"     # Dracula Green
AlertWarn = "#ffb86c"     # Dracula Orange
AlertError = "#ff5555"    # Dracula Red
```

And is placed in ~/.atuin/themes/dracula.toml.

I then updated my `config.toml` with this block

```toml
[theme]
name = "dracula"
```


6. `atuin info`

The command `atuin info` will shows the location of config files on your system. When I run it on my local macBook Pro I get

```bash
Config files:
client config: "/Users/ryan/.config/atuin/config.toml"
server config: "/Users/ryan/.atuin/server.toml"
client db path: /Users/ryan/.local/share/atuin/history.db
key path: /Users/ryan/.local/share/atuin/key
meta db path: /Users/ryan/.local/share/atuin/meta.db

Env Vars:
ATUIN_HOME = None
ATUIN_CONFIG_DIR = None

Version info:
version: 18.24.3
commit:  4532ceacd860885c2310ab8fab92a1bc00d6d7e8
```

This command can be especially helpful when you're trying to figure out why your `config.toml` isn't applying your settings the way you expect. In my case, the default one from the atuin install was being used instead of my user one. To fix it I deleted the one set up by atuin. If there are multiple `config.toml` files you do get a warning when running `atuin info` so you can see that there is something amiss.

(https://docs.atuin.sh/latest/reference/info/)

7. `atuin output search`

`atuin output search` allows for cli search capabilities for the output from commands. The command will return the output in addition to the command that prmopted the output.

Per the [docs](https://docs.atuin.sh/latest/reference/output/):

> Matches come back most relevant first, each with its command, when and where it ran, and its output.

you do need to ensure that `output capture` is enabled.

If it's not, run

```bash
atuin config enable output-capture
```

See the [docs](https://docs.atuin.sh/latest/reference/output/) for full details.


8. Search

The highlight feature of Atuin is it's search capabilities and yeah, there's a lot of power in the search.

You can interactively search using a TUI with `atuin search -i`. This isn't any different than `ctrl-r` or the `up-arrow`. BUT if you combine it with a search term, like `atuin search -i docker` you'll immediately be searching only you `docker` commands in your history.

There are also some great example of what's available [here](https://docs.atuin.sh/latest/reference/search/#examples)

9. `atuin stats`

You can run `atuin stats` to get details on what unique commands you've been running.

For example

```bash
atuin stats week --filter-mode session
```

returns

```bash
[▮▮▮▮▮▮▮▮▮▮] 4 cat
[▮▮▮▮▮▮▮   ] 3 clear
[▮▮▮▮▮▮▮   ] 3 grep
[▮▮▮▮▮     ] 2 just
[▮▮▮▮▮     ] 2 atuin
[▮▮        ] 1 wc
[▮▮        ] 1 code
Total commands:   12
Unique commands:  14
```

Notice that I was able to set the `--filter-mode` to look only at my session status.

You can also pass time arguments like this

```bash
atuin stats last thursday 3pm
```

This will get you everything since last Thursday at 3pm

10. `atuin store status`

The store `atuin status command` can tell you the status of each machine that has atuin attached to it. The host it displays is a uuid. You can get a pretty hostname, but you need to run

```bash
printf '%s %s\n' (cat ~/.local/share/atuin/host_id) (hostname -s)
```

on each machine.

11. `atuin scripts`
The `atuin scripts` command is currentlyl an undocumented feature. There was a [blog post](https://blog.atuin.sh/atuin-scripts-shareable-syncable-shell-snippets/) announcing it though.

I continue to struggle with how this is helpful, BUT this doesn't have to be useful for me to be useful in general!

One thing that does look interesting is this invocation:

```bash
atuin scripts new script-name --last N --tags my-tag --description "Does the thing!"
```

This will take the last N commands, add a tag called `my-tag` and a description `Does the thing!` and generate a script you can run with `atuin scripts run my-script`

If you run `atuin scripts list` you'll get this output

```bash
Available scripts:
- script-name [tags: my-tag]
  Description: Does the thing!
```

This can be especially helpful if you are going to need to do the same thing over and over again (like maybe migrating to a self hosted version of Atuin for all of your servers).

12. Key Bindings

This is where we can control, amongst other things, whether or not the `up-arrow` will invoke Atuin or not. One thing I've been struggling with is that in herdr the up arrow is captured by a scrolling up mouse as well. This is frustrating for me when I want to scroll up the page out output in a shell. I instead have to remember to use the `Page-up` key instead. I am not a fan.

So, I updated my key bindings to eliminate the `up-arrow` behavior for Atuin so that the mouse scroll doesn't get stolen by Atuin.

See the [docs](https://docs.atuin.sh/latest/configuration/key-binding) for full details.

### Settings

There are a LOT of settings. Like, holy shit, so many [settings](https://docs.atuin.sh/latest/configuration/config/)!

I'll give a run down of some of the ones that I found most interesting

- [sync_address](https://docs.atuin.sh/latest/configuration/config/#sync_address): This is what allows you to have your own self hosted instance. It defaults to "https://api.atuin.sh" so if you don't run your own instance there's nothing you need to update
- [filter_mode](https://docs.atuin.sh/latest/configuration/config/#filter_mode): this is what allows you to determine which history you start your search in. The default is `global`, but I changed it to `host`. You can use `ctrl-r` to cycle through the filter_mode though should you need to
- [inline_height](https://docs.atuin.sh/latest/configuration/config/#inline_height): the default is 40, but I set mine to 15 because I liked the way it looked better. This setting will determine the maximum number of lines Atuin's interface should take up.
- [enter_accept](https://docs.atuin.sh/latest/configuration/config/#enter_accept): This defaults to `false` but it kept breaking my brain, so I updated it to `true`. When this is set to `true`, Atuin will immediately execute a command rather than the user having to press enter twice. Pressing tab returns me to the shell and allows me a chance to edit the command if I want.
- [theme](https://docs.atuin.sh/latest/configuration/config/#theme): allows you to set you theme to a custom theme. I've set mine to `dracula`
-

## Rabbit Hole

While working through this I decided that setting up my own atuin sync server would be fun (and maybe easy). Since I use [coolify](https://coolify.io/) for my various web projects, I decided to use it to stand up my own sync server using the following `docker-compose.yml` file (created with the help of Claude):

```yaml
services:
  atuin:
    restart: always
    image: ghcr.io/atuinsh/atuin:62d5bad
    command: start
    expose:
      - 8888
    environment:
      ATUIN_HOST: "0.0.0.0"
      ATUIN_OPEN_REGISTRATION: "true"
      ATUIN_DB_URI: postgres://${ATUIN_DB_USERNAME}:${ATUIN_DB_PASSWORD}@db/${ATUIN_DB_NAME}
      RUST_LOG: info,atuin_server=debug
    depends_on:
      db:
        condition: service_healthy
  db:
    image: postgres:18
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${ATUIN_DB_USERNAME} -d ${ATUIN_DB_NAME}"]
      interval: 5s
      timeout: 5s
      retries: 10
    volumes: # Don't remove permanent storage for index database files!
      - "atuin-db:/var/lib/postgresql"
    environment:
      POSTGRES_USER: ${ATUIN_DB_USERNAME}
      POSTGRES_PASSWORD: ${ATUIN_DB_PASSWORD}
      POSTGRES_DB: ${ATUIN_DB_NAME}
      TZ: America/Los_Angeles
      PGTZ: America/Los_Angeles

volumes:
  atuin-db:
```

There is one limitation with rolling your own sync server. If you want to use the [AI features of Atuin](https://docs.atuin.sh/latest/ai/introduction/) you need to roll your own AI server too. They do have a [setup guide](https://docs.atuin.sh/latest/ai/self-hosting/) for that, but it seemed like a solution to a problem I don't have, so I decided against it.
