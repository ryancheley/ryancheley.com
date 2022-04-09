Title: Inserting a URL in Markdown in VS Code
Date: 2022-04-08
Author: ryan
Tags: vscode, shortcuts
Slug: inserting-a-url-in-markdown-in-vs-code
Status: draft

Eventual Answer
https://stackoverflow.com/a/70601782

cmd+Shift+P to get Preferences: Open Keyboard Shortcuts (JSON)

add to the existing list

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
