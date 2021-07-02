Title: Automating the Hummingbird Video Upload to YouTube or How I finally got Cron to do what I needed it to do but in the ugliest way possible
Date: 2018-05-02 16:44
Author: ryan
Tags: automation, Raspberry Pi, youtube
Slug: automating-the-hummingbird-video-upload-to-youtube-or-how-i-finally-got-cron-to-do-what-i-needed-it-to-do-but-in-the-ugliest-way-possible
Status: published

Several weeks ago in [Cronjob Redux](/cronjob-redux.html) I wrote that I had *finally* gotten Cron to automate the entire process of compiling the `h264` files into an `mp4` and uploading it to [YouTube](https://www.youtube.com).

I hadn’t. And it took the better part of the last 2 weeks to figure out what the heck was going on.

Part of what I wrote before was correct. I wasn’t able to read the `client_secrets.json` file and that was leading to an error.

I was *not* correct on the creation of the `create_mp4.sh` though.

The reason I got it to run automatically that night was because I had, in my testing, created the `create_mp4.sh` and when cron ran my `run_script.sh` it was able to use what was already there.

The next night when it ran, the `create_mp4.sh` was already there, but the `h264` files that were referenced in it weren’t. This lead to no video being uploaded and me being confused.

The issue was that cron was unable to run the part of the script that generates the script to create the `mp4` file.

I’m close to having a fix for that, but for now I did the most inelegant thing possible. I broke up the script in cron so it looks like this:

    00 06 * * * /home/pi/Documents/python_projects/cleanup.sh
    10 19 * * * /home/pi/Documents/python_projects/create_script_01.sh
    11 19 * * * /home/pi/Documents/python_projects/create_script_02.sh >> $HOME/Documents/python_projects/create_mp4.sh 2>&1
    12 19 * * * /home/pi/Documents/python_projects/create_script_03.sh
    13 19 * * * /home/pi/Documents/python_projects/run_script.sh

At 6am every morning the `cleanup.sh` runs and removes the `h264` files, the `mp4` file and the `create_mp4.sh` script

At 7:10pm the ‘[header](https://gist.github.com/ryancheley/5b11cc15160f332811a3b3d04edf3780)’ for the `create_mp4.sh` runs. At 7:11pm the ‘[body](https://gist.github.com/ryancheley/9e502a9f1ed94e29c4d684fa9a8c035a)’ for `create_mp4.sh` runs. At 7:12pm the ‘[footer](https://gist.github.com/ryancheley/3c91a4b27094c365b121a9dc694c3486)’ for `create_mp4.sh` runs.

Finally at 7:13pm the `run_script.sh` compiles the `h264` files into an `mp4` and uploads it to YouTube.

Last night while I was at a School Board meeting the whole process ran on it’s own. I was super pumped when I checked my YouTube channel and saw that the May 1 hummingbird video was there and I didn’t have to do anything.
