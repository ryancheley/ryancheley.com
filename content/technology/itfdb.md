Title: ITFDB!!!
Date: 2018-02-13 18:23
Author: ryan
Tags: Baseball, dodgers, python, Raspberry Pi, Python
Slug: itfdb
Status: published

My wife and I **love** baseball season. Specifically we love the [Dodgers](https://www.mlb.com/dodgers "Go Dodgers!!!") and we can’t wait for Spring Training to begin. In fact, today pitchers and catchers report!

I’ve wanted to do something with the Raspberry Pi Sense Hat that I got (since I got it) but I’ve struggled to find anything useful. And then I remembered baseball season and I thought, ‘Hey, what if I wrote something to have the Sense Hat say “\#ITFDB” starting 10 minutes before a Dodgers game started?’

And so I did!

The script itself is relatively straight forward. It reads a csv file and checks to see if the current time in California is within 10 minutes of start time of the game. If it is, then it will send a `show_message` command to the Sense Hat.

I also wrote a cron job to run the script every minute so that I get a beautiful scrolling bit of text every minute before the Dodgers start!

The code can be found on my [GitHub](https://github.com/ryancheley/itfdb "Git Hub") page in the itfdb repository. There are 3 files:

1.  `Program.py` which does the actual running of the script
2.  `data_types.py` which defines a class used in `Program.py`
3.  `schedule.csv` which is the schedule of the games for 2018 as a csv file.

I ran into a couple of issues along the way. First, my development environment on my Mac Book Pro was Python 3.6.4 while the Production Environment on the Raspberry Pi was 3.4. This made it so that the code about time ran locally but not on the server 🤦‍♂️.

It took some playing with the code, but I was finally able to go from this (which worked on 3.6 but not on 3.4):

    now = utc_now.astimezone(pytz.timezone("America/Los_Angeles"))
    game_date_time = game_date_time.astimezone(pytz.timezone("America/Los_Angeles"))

To this which worked on both:

    local_tz = pytz.timezone('America/Los_Angeles')
    now = utc_now.astimezone(local_tz)
    game_date_time = local_tz.localize(game_date_time)

For both, the `game_date_time` variable setting was done in a for loop.

Another issue I ran into was being able to *display* the message for the sense hat on my Mac Book Pro. I wasn’t ever able to because of a package that is missing (RTIMU ) and is apparently only available on Raspbian (the OS on the Pi).

Finally, in my attempts to get the code I wrote locally to work on the Pi I decided to install Python 3.6.0 on the Pi (while 3.4 was installed) and seemed to do nothing but break `pip`. It looks like I’ll be learning how to uninstall Python 3.4 OR reinstalling everything on the Pi and starting from scratch. Oh well … at least it’s just a Pi and not a *real* server.

Although, I’m pretty sure I hosed my [Linode](https://www.linode.com) server a while back and basically did the same thing so maybe it’s just what I do with servers when I’m learning.

One final thing. While sitting in the living room watching *DC Legends of Tomorrow* the Sense Hat started to display the message. Turns out, I was accounting for the minute, hour, and day but *NOT* the month. The Dodgers play the Cubs on September 12 at 9:35 (according to the schedule.csv file anyway) and so the conditions to display were met.

I added another condition to make sure it was the right month and now we’re good to go!

Super pumped for this season with the Dodgers!
