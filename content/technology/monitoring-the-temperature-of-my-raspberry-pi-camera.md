Title: Monitoring the temperature of my Raspberry Pi Camera
Date: 2018-12-04 07:07
Author: ryan
Tags: automation, Bash, Raspberry Pi
Slug: monitoring-the-temperature-of-my-raspberry-pi-camera
Status: published

In late April of this year I wrote a script that would capture the temperature of the Raspberry Pi that sits above my Hummingbird feeder and log it to a file.

It’s a straight forward enough script that captures the date, time and temperature as given by the internal `measure_temp` function. In code it looks like this:

    MyDate="`date +'%m/%d/%Y, %H:%M, '`"
    MyTemp="`/opt/vc/bin/vcgencmd measure_temp |tr -d "=temp'C"`"
    echo "$MyDate$MyTemp" >> /home/pi/Documents/python_projects/temperature/temp.log

I haven’t ever really done anything with the file, but one thing I wanted to do was to get alerted if (when) the temperature exceeded the recommended level of 70 C.

To do this I installed `ssmtp` onto my Pi using `apt-get`

    sudo apt-get install ssmtp

With that installed I am able to send an email using the following command:

    echo "This is the email body" | mail -s "This is the subject" user@domain.tld

With this tool in place I was able to attempt to send an alert if (when) the Pi’s temperature got above 70 C (the maximum recommended running temp).

At first, I tried adding this code:

    if [ "$MyTemp" -gt "70" ]; then
       echo "Camera Pi Running Hot" | mail -s "Warning! The Camera Pi is Running Hot!!!" user@domain.tld
    fi

Where the `$MyTemp` came from the above code that get’s logged to the temp.log file.

It didn’t work. The problem is that the temperature I’m capturing for logging purposes is a float, while the item it was being compared to was an integer. No problem, I’ll just make the “70” into a “70.0” and that will fix the ... oh wait. That didn’t work either.

OK. I tried various combinations, trying to see what would work and finally determined that there is a way to get the temperature as an integer, but it meant using a different method to capture it. This is done by adding this line:

    ComparisonTemp=$(($(cat /sys/class/thermal/thermal_zone0/temp)/1000))

The code above gets the temperature as an integer. I then use that in my `if` statement for checking the temperature:

    if [ "$ComparisonTemp" -gt "70" ]; then
       echo "Camera Pi Running Hot" | mail -s "Warning! The Camera Pi is Running Hot!!!" user@domain.tld
    fi

Giving a final script that looks like this:

    MyDate="`date +'%m/%d/%Y, %H:%M, '`"
    MyTemp="`/opt/vc/bin/vcgencmd measure_temp |tr -d "=temp'C"`"
    echo "$MyDate$MyTemp" >> /home/pi/Documents/python_projects/temperature/temp.log
    ComparisonTemp=$(($(cat /sys/class/thermal/thermal_zone0/temp)/1000))

    if [ "$ComparisonTemp" -gt "70" ]; then
       echo "Camera Pi Running Hot" | mail -s "Warning! The Camera Pi is Running Hot!!!" user@domain.tld
    fi
