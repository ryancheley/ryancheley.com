Title: Cronjob ... Finally
Date: 2018-04-10 20:10
Author: ryan
Tags: Cronjob, python, youtube, Automation, hummingbird
Slug: cronjob-finally
Status: published

I’ve mentioned before that I have been working on getting the hummingbird video upload automated.

Each time I thought I had it, and each time I was wrong.

For some reason I could run it from the command line without issue, but when the cronjob would try and run it ... nothing.

Turns out, it was running, it just wasn’t doing anything. And that was my fault.

The file I had setup in cronjob was called `run_scrip.sh`

At first I was confused because the script was suppose to be writing out to a log file all of it’s activities. But it didn’t appear to.

Then I noticed that the log.txt file it was writing was in the main `` \` `` directory. That should have been my first clue.

I kept trying to get the script to run, but suddenly, in a blaze of glory, realized that it **was** running, it just wasn’t doing anything.

And it wasn’t doing anything for the same reason that the log file was being written to the `` \` `` directory.

All of the paths were relative instead of absolute, so when the script ran the command `./create_mp4.sh` it looks for that script in the home directory, didn’t find it, and moved on.

The fix was simple enough, just add absolute paths and we’re golden.

That means my `run_script.sh` goes from this:

    # Create the script that will be run
    ./create_script.sh
    echo "Create Shell Script: $(date)" >> log.txt

    # make the script that was just created executable
    chmod +x /home/pi/Documents/python_projects/create_mp4.sh

    # Create the script to create the mp4 file
    /home/pi/Documents/python_projects/create_mp4.sh
    echo "Create MP4 Shell Script: $(date)" >> /home/pi/Documents/python_projects/log.txt

    # upload video to YouTube.com
    /home/pi/Documents/python_projects/upload.sh
    echo "Uploaded Video to YouTube.com: $(date)" >> /home/pi/Documents/python_projects/log.txt

    # Next we remove the video files locally
    rm /home/pi/Documents/python_projects/*.h264
    echo "removed h264 files: $(date)" >> /home/pi/Documents/python_projects/log.txt

    rm /home/pi/Documents/python_projects/*.mp4
    echo "removed mp4 file: $(date)" >> /home/pi/Documents/python_projects/log.txt

To this:

    # change to the directory with all of the files
    cd /home/pi/Documents/python_projects/

    # Create the script that will be run
    /home/pi/Documents/python_projects/create_script.sh
    echo "Create Shell Script: $(date)" >> /home/pi/Documents/python_projects/log.txt

    # make the script that was just created executable
    chmod +x /home/pi/Documents/python_projects/create_mp4.sh

    # Create the script to create the mp4 file
    /home/pi/Documents/python_projects/create_mp4.sh
    echo "Create MP4 Shell Script: $(date)" >> /home/pi/Documents/python_projects/log.txt

    # upload video to YouTube.com
    /home/pi/Documents/python_projects/upload.sh
    echo "Uploaded Video to YouTube.com: $(date)" >> /home/pi/Documents/python_projects/log.txt

    # Next we remove the video files locally
    rm /home/pi/Documents/python_projects/*.h264
    echo "removed h264 files: $(date)" >> /home/pi/Documents/python_projects/log.txt

    rm /home/pi/Documents/python_projects/*.mp4
    echo "removed mp4 file: $(date)" >> /home/pi/Documents/python_projects/log.txt

I made this change and then started getting an error about not being able to access a `json` file necessary for the upload to [YouTube](https://www.youtube.com). Sigh.

Then while searching for what directory the cronjob was running from I found [this very simple](https://unix.stackexchange.com/questions/38951/what-is-the-working-directory-when-cron-executes-a-job) idea. The response was, why not just change it to the directory you want. 🤦‍♂️

I added the `cd` to the top of the file:

    # change to the directory with all of the files
    cd /home/pi/Documents/python_projects/

Anyway, now it works. Finally!

Tomorrow will be the first time (unless of course something else goes wrong) that The entire process will be automated. Super pumped!
