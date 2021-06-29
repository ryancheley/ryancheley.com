Title: Cronjob Redux
Date: 2018-04-20 19:10
Author: ryan
Category: Technology
Tags: automation, python, Raspberry Pi, Shell Script, video, youtube, Automation
Slug: cronjob-redux
Status: published

After **days** of trying to figure this out, I finally got the video to upload via a cronjob.

There were 2 issues.

## Issue the first

Finally found the issue. [Original script from YouTube developers guide](https://developers.google.com/youtube/v3/guides/uploading_a_video)had this:

    CLIENT_SECRETS_FILE = "client_secrets.json"

And then a couple of lines later, this:

    % os.path.abspath(os.path.join(os.path.dirname(__file__), CLIENT_SECRETS_FILE))

When `crontab` would run the script it would run from a path that wasn’t where the `CLIENT_SECRETS_FILE` file was and so a message would be displayed:

    WARNING: Please configure OAuth 2.0

    To make this sample run you will need to populate the client_secrets.json file
    found at:

      %s

    with information from the Developers Console
    https://console.developers.google.com/

    For more information about the client_secrets.json file format, please visit:
    https://developers.google.com/api-client-library/python/guide/aaa_client_secrets

What I needed to do was to update the `CLIENT_SECRETS_FILE` to be the whole path so that it could always find the file.

A simple change:

    CLIENT_SECRETS_FILE  = os.path.abspath(os.path.join(os.path.dirname(__file__), CLIENT_SECRETS_FILE))

## Issue the second

When the `create_mp4.sh` script would run it was reading all of the `h264` files from the directory where they lived **BUT** they were attempting to output the `mp4` file to `/` which it didn’t have permission to write to.

This was failing silently (I’m still not sure how I could have caught the error). Since there was no `mp4` file to upload that script was failing (though it was true that the location of the `CLIENT_SECRETS_FILE` was an issue).

What I needed to do was change the `create_mp4.sh` file so that when the MP4Box command output the `mp4` file to the proper directory. The script went from this:

    (echo '#!/bin/sh'; echo -n "MP4Box"; array=($(ls ~/Documents/python_projects/*.h264)); for index in ${!array[@]}; do if [ "$index" -eq 0 ]; then echo -n " -add ${array[index]}"; else echo -n " -cat ${array[index]}"; fi; done; echo -n " hummingbird.mp4") > create_mp4.sh

To this:

    (echo '#!/bin/sh'; echo -n "MP4Box"; array=($(ls ~/Documents/python_projects/*.h264)); for index in ${!array[@]}; do if [ "$index" -eq 0 ]; then echo -n " -add ${array[index]}"; else echo -n " -cat ${array[index]}"; fi; done; echo -n " /home/pi/Documents/python_projects/hummingbird.mp4") > /home/pi/Documents/python_projects/create_mp4.sh

The last bit `/home/pi/Documents/python_projects/create_mp4.sh` may not be *neccesary* but I’m not taking any chances.

The [video posted tonight](https://www.youtube.com/watch?v=OaRiW1aFk9k) is the first one that was completely automatic!

Now … if I could just figure out how to automatically fill up my hummingbird feeder.
