Title: ITFDB Demo
Date: 2018-04-01 16:38
Author: ryan
Tags: Easter, Family, Shell Script, Workflow, Python
Slug: itfdb-demo
Status: published

Last Wednesday if you would have asked what I had planned for Easter I would have said something like, “Going to hide some eggs for my daughter even though she knows the Easter bunny isn’t real.”

Then suddenly my wife and I were planning on entertaining for 11 family members. My how things change!

Since I was going to have family over, some of whom are [Giants](https://www.mlb.com/giants) fans, I wanted to show them the [ITFDB program I have set up with my Pi](http://www.ryancheley.com/index.php/2018/02/13/itfdb/).

The only problem is that they would be over at 10am and leave by 2pm while the game doesn’t start until 5:37pm (Thanks [ESPN](https://www.espn.com)).

To help demonstrate the script I wrote a *demo* script to display a message on the Pi and play the Vin Scully mp3.

The Code was simple enough:

    from sense_hat import SenseHat
    import os


    def main():
        sense = SenseHat()
        message = '#ITFDB!!! The Dodgers will be playing San Francisco at 5:37pm tonight!'
        sense.show_message(message, scroll_speed=0.05)
        os.system("omxplayer -b /home/pi/Documents/python_projects/itfdb/dodger_baseball.mp3")


    if __name__ == '__main__':
        main()

But then the question becomes, how can I easily launch the script without [futzing](https://en.wiktionary.org/wiki/futz) with my laptop?

I knew that I could run a shell script for the [Workflow app](https://workflow.is) on my iPhone with a single action, so I wrote a simple shell script

    python3 ~/Documents/python_projects/itfdb/demo.py

Which was called `itfdb_demo.sh`

And made it executable

    chmod u+x itfdb_demo.sh

Finally, I created a WorkFlow which has only one action `Run Script over SSH` and added it to my home screen so that with a simple tap I could demo the results.

The WorkFlow looks like this:

![](/images/uploads/2018/04/IMG_9450.png){.alignnone .size-full .wp-image-254 width="1242" height="2208"}

Nothing too fancy, but I was able to reliably and easily demonstrate what I had done. And it was pretty freaking cool!
