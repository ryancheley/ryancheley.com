Title: Keeping Python up to date on macOS
Date: 2018-12-22 04:08
Author: ryan
Tags: macOS, Python, Terminal
Slug: keeping-python-up-to-date-on-macos
Status: published

Sometimes the internet is a horrible, awful, ugly thing. And then other times, it’s exactly what you need.

I have 2 Raspberry Pi each with different versions of Python. One running python 3.4.2 and the other running Python 3.5.3. I have previously tried to upgrade the version of the Pi running 3.5.3 to a more recent version (in this case 3.6.1) and read 10s of articles on how to do it. It did not go well. Parts seemed to have worked, while others didn’t. I have 3.6.1 installed, but in order to run it I have to issue the command `python3.6` which is *fine* but not really what I was looking for.

For whatever reason, although I do nearly all of my Python development on my Mac, it hadn’t occurred to me to upgrade Python there until last night.

With a simple Google search the first result came to Stackoverflow (what else?) and [this](https://apple.stackexchange.com/questions/201612/keeping-python-3-up-to-date-on-a-mac) answer.

    brew update
    brew upgrade python3

Sometimes things on a Mac do ‘just work’. This was one of those times.

I’m now running Python 3.7.1 and I’ll I needed to do was a simple command in the terminal.

God bless the internet.
