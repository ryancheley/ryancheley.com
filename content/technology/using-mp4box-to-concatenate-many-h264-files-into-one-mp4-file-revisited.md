Title: Using MP4Box to concatenate many .h264 files into one MP4 file: revisited
Date: 2018-02-10 15:20
Author: ryan
Tags: Bash, python, Shell Script, hummingbird
Slug: using-mp4box-to-concatenate-many-h264-files-into-one-mp4-file-revisited
Status: published

In my last [post](/using-mp4box-to-concatenate-many-h264-files-into-one-mp4-file.html) I wrote out the steps that I was going to use to turn a ton of `.h264` files into one `mp4` file with the use of `MP4Box`.

Before outlining my steps I said, “The method below works but I’m sure that there is a better way to do it.”

Shortly after posting that I decided to find that better way. Turns out, ~~it wasn’t really that much more work~~ it was much harder than originally thought.

The command below is a single line and it will create a text file (com.txt) and then execute it as a bash script:

~~`(echo '#!/bin/sh'; for i in *.h264; do if [ "$i" -eq 1 ]; then echo -n " -add $i"; else echo -n " -cat $i"; fi; done; echo -n " hummingbird.mp4") > /Desktop/com.txt | chmod +x /Desktop/com.txt | ~/Desktop/com.txt`~~

    (echo '#!/bin/sh'; echo -n "MP4Box"; array=($(ls *.h264)); for index in ${!array[@]}; do if [ "$index" -eq 1 ]; then echo -n " -add ${array[index]}"; else echo -n " -cat ${array[index]}"; fi; done; echo -n " hummingbird.mp4") > com.txt | chmod +x com.txt

Next you execute the script with

    ./com.txt

OK, but what is it doing? The parentheses surround a set of echo commands that output to com.txt. I’m using a for loop with an if statement. The reason I can’t do a straight for loop is because the first `h264` file used in `MP4Box` needs to have the `-add` flag while all of the others need the `-cat` flag.

Once the file is output to the `com.txt` file (on the Desktop) I pipe it to the `chmod +x` command to change it’s mode to make it executable.

Finally, I pipe that to a command to run the file `~/Desktop/com.txt`

I was pretty stoked when I figured it out and was able to get it to run.

The next step will be to use it for the hundreds of h264 files that will be output from my hummingbird camera that I just installed today.

I’ll have a post on that in the next couple of days.
