Title: Inserting a URL in Markdown in VS Code
Date: 2022-04-08
Author: ryan
Tags: vscode, shortcuts
Slug: inserting-a-url-in-markdown-in-vs-code
Status: published

Since I [switched my blog to pelican](https://www.ryancheley.com/2021/07/02/migrating-to-pelican-from-
wordpress/) last summer I've been using [VS Code](https://code.visualstudio.com) as my writing app. And it's **really** good for writing, note just code but prose as well.

The one problem I've had is there's no keyboard shortcut for links when writing in markdown ... at least not a default / native keyboard shortcut.

In other (macOS) writing apps you just select the text and press ⌘+k and boop! There's a markdown link set up for you. But not so much in VS Code.

I finally got to the point where that was one thing that may have been keeping me from writing because of how much 'friction' it caused!

So, I decided to figure out how to fix that.

I did have to do a bit of googling and eventually found [this](https://stackoverflow.com/a/70601782) StackOverflow answer

Essentially the answer is

1. Open the Preferences Page: ⌘+Shift+P
2. Select `Preferences: Open Keyboard Shortcuts (JSON)`
3. Update the `keybindings.json` file to include a new key

The new key looks like this:

```json
{
    "key": "cmd+k",
    "command": "editor.action.insertSnippet",
    "args": {
        "snippet": "[${TM_SELECTED_TEXT}]($0)"
    },
    "when": "editorHasSelection && editorLangId == markdown "
}
```

Honestly, it's *little* things like this that can make life so much easier and more fun. Now I just need to remember to do this on my work computer 😀
