Title: Setting up ITFDB with a voice
Date: 2018-03-15 17:41
Author: ryan
Tags: python, Raspberry Pi
Slug: setting-up-itfdb-with-a-voice
Status: published

In a [previous post](/itfdb.html) I wrote about my Raspberry Pi experiment to have the SenseHat display a scrolling message 10 minutes before game time.

One of the things I have wanted to do since then is have Vin Scully’s voice come from a speaker and say those five magical words, `It's time for Dodger Baseball!`

I found a clip of [Vin on Youtube](https://www.youtube.com/watch?v=4KwFuGtGU6c) saying that (and a little more). I wasn’t sure how to get the audio from that YouTube clip though.

After a bit of googling[ref]Actually, it was an embarrassing amount[/ref] I found a command line tool called [youtube-dl](https://rg3.github.io/youtube-dl/). The tool allowed me to download the video as an `mp4` with one simple command:

    youtube-dl https://www.youtube.com/watch?v=4KwFuGtGU6c

Once the mp4 was downloaded I needed to extract the audio from the `mp4` file. Fortunately, `ffmpeg` is a tool for just this type of exercise!

I modified [this answer from StackOverflow](https://stackoverflow.com/questions/9913032/ffmpeg-to-extract-audio-from-video) to meet my needs

    ffmpeg -i dodger_baseball.mp4 -ss 00:00:10 -t 00:00:9.0 -q:a 0 -vn -acodec copy dodger_baseball.aac

This got me an `aac` file, but I was going to need an `mp3` to use in my Python script.

Next, I used a [modified version of this suggestion](https://askubuntu.com/questions/35457/converting-aac-to-mp3-via-command-line) to create write my own command

    ffmpeg -i dodger_baseball.aac -c:a libmp3lame -ac 2 -b:a 190k dodger_baseball.mp3

I could have probably combined these two steps, but … meh.

OK. Now I have the famous Vin Scully saying the best five words on the planet.

All that’s left to do is update the python script to play it. Using guidance from [here](https://raspberrypi.stackexchange.com/questions/7088/playing-audio-files-with-python) I updated my `itfdb.py` file from this:

    if month_diff == 0 and day_diff == 0 and hour_diff == 0 and 0 >= minute_diff >= -10:
       message = '#ITFDB!!! The Dodgers will be playing {} at {}'.format(game.game_opponent, game.game_time)
       sense.show_message(message, scroll_speed=0.05)

To this:

    if month_diff == 0 and day_diff == 0 and hour_diff == 0 and 0 >= minute_diff >= -10:
       message = '#ITFDB!!! The Dodgers will be playing {} at {}'.format(game.game_opponent, game.game_time)
       sense.show_message(message, scroll_speed=0.05)
       os.system("omxplayer -b /home/pi/Documents/python_projects/itfdb/dodger_baseball.mp3")

However, what that does is play Vin’s silky smooth voice every minute for 10 minutes before game time. Music to my ears but my daughter was not a fan, and even my wife who LOVES Vin asked me to change it.

One final tweak, and now it only plays at 5 minutes before game time and 1 minute before game time:

    if month_diff == 0 and day_diff == 0 and hour_diff == 0 and 0 >= minute_diff >= -10:
       message = '#ITFDB!!! The Dodgers will be playing {} at {}'.format(game.game_opponent, game.game_time)
       sense.show_message(message, scroll_speed=0.05)

    if month_diff == 0 and day_diff == 0 and hour_diff == 0 and (minute_diff == -1 or minute_diff == -5):
       os.system("omxplayer -b /home/pi/Documents/python_projects/itfdb/dodger_baseball.mp3")

Now, for the rest of the season, even though Vin isn’t calling the games, I’ll get to hear his voice letting me know, “It’s Time for Dodger Baseball!!!”
