Title: The PIR Sensor Debacle of 2018
Date: 2018-11-10 11:26
Author: ryan
Tags: Hummingbird, pir sensor
Slug: the-pir-sensor
Status: published

Last spring I set up a Raspberry Pi to record humming birds at my hummingbird feeder, compile the recorded h264 files into an mp4 and upload it to YouTube.

I’ve written about that process before here, here, and here.

This post is a bit of documentation to remind myself about how to connect the PIR sensor to the Raspberry Pi so I don’t forget.

When I went to set it up this year, it appeared like the PIR sensor wasn’t working. It would start the video capture, but it wouldn’t end it.

I tried a couple of different things (including the purchase of some new PIR sensors) but none of them seemed to work. I was worried that the heat from the early bit of summer last year had maybe fried my little Pi.

But no, it turns out that the link I was using as the basis for my project had a diagram AND a description about how to connect the PIR.

I had assumed that the diagram was correct and that I didn’t need to read the description, but it turns out I did BECAUSE the diagram had the connections set up in a way that didn’t line up with the PIR sensor(s) I have.

![rPi wires diagram](/images/uploads/2018/11/pir-diagram-1.png){.alignnone .size-full .wp-image-313 width="1000" height="375"}

In the Parent Detector PIR sensor the connectors are (1) Power, (2) Ground, (3) Out

![movement sensor](/images/uploads/2018/11/IMG_0282.jpg){.alignnone .size-full .wp-image-314 width="3024" height="4032"}

In my PIR sensor the connectors are (1) Power, (2) Out, (3) Ground.

This meant that the power was getting to the PIR sensor, but there was no way to send the trip because the signal was being sent to the Ground.

Anyway, the morale of the story is, pictures are nice, but reading may save you some time (and money) in the long run.
