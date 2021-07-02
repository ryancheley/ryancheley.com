Title: Receipts
Date: 2019-03-16 05:37
Author: ryan
Tags: iOS, Siri Shortcuts, Automation
Slug: receipts
Status: published

Every month I set up a budget for my family so that we can track our spending and save money in the ways that we need to while still being able to enjoy life.

I have a couple of Siri Shortcuts that will take a picture and then put that picture into a folder in Dropbox. The reason that I have a couple of them is that one is for physical receipts that we got at a store and the other is for online purchases. I’m sure that these couple be combined into one, but I haven’t done that yet.

One of the great things about these shortcuts is that they will create the folder that the image will go into if it’s not there. For example, the first receipt of March 2019 will create a folder called **March** in the **2019** folder. If the **2019** folder wasn’t there, it would have created it too.

What it doesn’t do is create the sub folder that all of my processed receipts will go into. Each month I need to create a folder called `month_name` Processed. And each month I think, there must be a way I can automate this, but because it doesn’t really take that long I’ve never really done it.

Over the weekend I finally had the time to try and write it up and test it out. Nothing too fancy, but it does what I want it to do, and a little more.

    # create the variables I'm going to need later

    y=$( date +"%Y" )
    m=$( date +"%B" )
    p=$( date +"%B_Processed" )

    # check to see if the Year folder exists and if it doesn't, create it
    if [ ! -d /Users/ryan/Dropbox/Family/Financials/$y ]; then
        mkdir /Users/ryan/Dropbox/Family/Financials/$y
    fi

    # check to see if the Month folder exists and if it doesn't, create it
    if [ ! -d /Users/ryan/Dropbox/Family/Financials/$y/$m ]; then
        mkdir /Users/ryan/Dropbox/Family/Financials/$y/$m
    fi

    #check to see if the Month_Processed folder exists and if it doesn't, create it
    if [ ! -d "/Users/ryan/Dropbox/Family/Financials/$y/$m/$p" ]; then
        mkdir "/Users/ryan/Dropbox/Family/Financials/$y/$m/$p"
    fi

The last section I use the double quotes “” around the directory name so that I can have a space in the name of the processed folder. Initially I had used an underscore but that’s not how I do it in real life when creating the sub directors, so I had to do a bit of googling and found a helpful [resource](https://ubuntuforums.org/showthread.php?t=1962625).

The only thing left to do at this point is get it set up to run automatically so I don’t have to do anything.

In order to do that I needed to add the following to my cronjob:

    0 5 1 * * /Users/ryan/Documents/scripts/create_monthly_expense_folders.sh

And now I will have my folder structure created for me automatically on the first of the month at 5am!
