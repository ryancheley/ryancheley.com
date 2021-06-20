Title: Hummingbird Video Capture
Date: 2018-04-05 17:46
Author: ryan
Category: Raspberry Pi
Tags: Hummingbird, python, video, youtube
Slug: hummingbird-video-capture
Status: published

I [previously wrote](/using-mp4box-to-concatenate-many-h264-files-into-one-mp4-file-revisited.html) about how I placed my Raspberry Pi above my hummingbird feeder and added a camera to it to capture video.

Well, the day has finally come where I’ve been able to put my video of it up on [YouTube](https://youtu.be/_oNlhrZJ-0Y)! It’s totally silly, but it was satisfying getting it out there for everyone to watch and see.

## Hummingbird Video Capture: Addendum

The code used to generate the the `mp4` file haven’t changed (really). I did do a couple of things to make it a little easier though.

I have 2 scripts that generate the file and then copy it from the pi to my MacBook Pro and the clean up:

Script 1 is called `create_script.sh` and looks like this:

    (echo '#!/bin/sh'; echo -n "MP4Box"; array=($(ls *.h264)); for index in ${!array[@]}; do if [ "$index" -eq 0 ]; then echo -n " -add ${array[index]}"; else echo -n " -cat ${array[index]}"; fi; done; echo -n " hummingbird.mp4") > create_mp4.sh | chmod +x create_mp4.sh

This creates a script called `create_mp4.sh` and makes it executable.

This script is called by another script called `run_script.sh` and looks like this:

    ./create_script.sh
    ./create_mp4.sh

    scp hummingbird.mp4 ryan@192.168.1.209:/Users/ryan/Desktop/

    # Next we remove the video files locally

    rm *.h264
    rm *.mp4

It runs the `create_script.sh` which creates `create_mpr.sh` and then runs it.

Then I use the `scp` command to copy the `mp4` file that was just created over to my Mac Book Pro.

As a last bit of housekeeping I clean up the video files.

I’ve added this `run_script.sh` to a cron job that is scheduled to run every night at midnight.

We’ll see how well it runs tomorrow night!
