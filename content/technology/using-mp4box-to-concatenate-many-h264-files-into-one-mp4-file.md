Title: Using MP4Box to concatenate many .h264 files into one MP4 file
Date: 2018-02-08 05:25
Author: ryan
Tags: automation, Bash, python, Shell Script
Slug: using-mp4box-to-concatenate-many-h264-files-into-one-mp4-file
Status: published

The general form of the concatenate command for [MP4Box](https://gpac.wp.imt.fr/mp4box/ "MP4Box") is:

`MP4Box -add <filename>.ext -cat <filename>.ext output.ext`[ref]The `-add` will add the \<filename\> to the output file while the `-cat` will add any other files to the output file (all while not overwriting the output file so that the files all get streamed together).[/ref]

When you have more than a couple of output files, you’re going to want to automate that `-cat` part as much as possible because let’s face it, writing out that statement even more than a couple of times will get really old really fast.

The method below *works* but I’m sure that there is a better way to do it.

1.  echo out the command you want to run. In this case:

`(echo -n "MP4Box "; for i in *.h264; do echo -n " -cat $i"; done; echo -n " hummingbird.mp4") >> com.txt`

1.  Edit the file `com.txt` created in (1) so that you can change the first `-cat` to `-add`

`vim com.txt`

1.  While still in `vim` editing the `com.txt` file add the `#!/bin/sh` to the first line. When finished, exit vim[ref]I’m sure there’s an xkcd comic about this, but I just can’t find it![/ref]
2.  Change the mode of the file so it can run

`chmod +x com.txt`

1.  Run the file:

`./com.txt`

Why am I doing all of this? I have a Raspberry Pi with a Camera attachment and a motion sensor. I’d like to watch the hummingbirds that come to my hummingbird feeder with it for a day or two and get some sweet video. We’ll see how it goes.
