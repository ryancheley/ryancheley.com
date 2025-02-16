Title: The Trouble with Karabiner
Date: 2025-02-16
Author: ryan
Tags: macOS,key-bindings
Slug: the-trouble-with-karabiner
Status: published

I woke up this morning and attempted to do some stuff on my mac. I have a docking station that I use for both my Mac Book Pro and my work Windows Laptop.

There is a [Code Keyboard](https://codekeyboards.com/)[ref]R.I.P. Code Keyboards[/ref] that is attached and is set to Windows mode (because I use this configuration for work for many more hours that I use it for non work, i.e. macOS stuff)

To help with this I use an app called [Karabiner-Elements](https://karabiner-elements.pqrs.org/).

When I plugged my MBP in today none of the Karabiner remapped keys were working as expected (I map `alt` to `command` on the left and right side specificall). I tried many things, and eventually discovered that I need to have the following items enabled

Full Disk Access

- karabiner_grabber
- Karabiner-Elements

Something (probably an OS update) seems to have disabled the karabiner_grabber access as I had to switch it back on.

Suddenly everything is back to working as expected.

I would really like that 45 minutes back though. Not a great way to start your day
