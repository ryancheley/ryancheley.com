Title: An Update to my first Python Script
Date: 2016-10-22 16:00
Author: ryan
Category: Python
Slug: an-update-to-my-first-python-script
Status: published

Nothing can ever really be considered **done** when you're talking about programming, right?

I decided to try and add images to the [python script I wrote last week](https://github.com/miloardot/python-files/commit/e603eb863dbba169938b63df3fa82263df942984) and was able to do it, with not too much hassel.

The first thing I decided to do was to update the code on `pythonista` on my iPad Pro and verify that it would run.

It took some doing (mostly because I *forgot* that the attributes in an `img` tag included what I needed ... initially I was trying to programatically get the name of the person from the image file itelf using [regular expressions](https://en.wikipedia.org/wiki/Regular_expression) ... it didn't work out well).

Once that was done I branched the `master` on GitHub into a `development` branch and copied the changes there. Once that was done I performed a **pull request** on the macOS GitHub Desktop Application.

Finally, I used the macOS GitHub app to merge my **pull request** from `development` into `master` and now have the changes.

The updated script will now also get the image data to display into the multi markdown table:

    | Name | Title | Image |
    | --- | --- | --- |
    |Mike Cheley|CEO/Creative Director|![alt text](http://www.graphtek.com/user_images/Team/Mike_Cheley.png "Mike Cheley")|
    |Ozzy|Official Greeter|![alt text](http://www.graphtek.com/user_images/Team/Ozzy.png "Ozzy")|
    |Jay Sant|Vice President|![alt text](http://www.graphtek.com/user_images/Team/Jay_Sant.png "Jay Sant")|
    |Shawn Isaac|Vice President|![alt text](http://www.graphtek.com/user_images/Team/Shawn_Isaac.png "Shawn Isaac")|
    |Jason Gurzi|SEM Specialist|![alt text](http://www.graphtek.com/user_images/Team/Jason_Gurzi.png "Jason Gurzi")|
    |Yvonne Valles|Director of First Impressions|![alt text](http://www.graphtek.com/user_images/Team/Yvonne_Valles.png "Yvonne Valles")|
    |Ed Lowell|Senior Designer|![alt text](http://www.graphtek.com/user_images/Team/Ed_Lowell.png "Ed Lowell")|
    |Paul Hasas|User Interface Designer|![alt text](http://www.graphtek.com/user_images/Team/Paul_Hasas.png "Paul Hasas")|
    |Alan Schmidt|Senior Web Developer|![alt text](http://www.graphtek.com/user_images/Team/Alan_Schmidt.png "Alan Schmidt")|

Which gets displayed as this:

  Name            Title                           Image
  --------------- ------------------------------- -----------------------------------------------------------------------------------------
  Mike Cheley     CEO/Creative Director           ![alt text](http://www.graphtek.com/user_images/Team/Mike_Cheley.png "Mike Cheley")
  Ozzy            Official Greeter                ![alt text](http://www.graphtek.com/user_images/Team/Ozzy.png "Ozzy")
  Jay Sant        Vice President                  ![alt text](http://www.graphtek.com/user_images/Team/Jay_Sant.png "Jay Sant")
  Shawn Isaac     Vice President                  ![alt text](http://www.graphtek.com/user_images/Team/Shawn_Isaac.png "Shawn Isaac")
  Jason Gurzi     SEM Specialist                  ![alt text](http://www.graphtek.com/user_images/Team/Jason_Gurzi.png "Jason Gurzi")
  Yvonne Valles   Director of First Impressions   ![alt text](http://www.graphtek.com/user_images/Team/Yvonne_Valles.png "Yvonne Valles")
  Ed Lowell       Senior Designer                 ![alt text](http://www.graphtek.com/user_images/Team/Ed_Lowell.png "Ed Lowell")
  Paul Hasas      User Interface Designer         ![alt text](http://www.graphtek.com/user_images/Team/Paul_Hasas.png "Paul Hasas")
  Alan Schmidt    Senior Web Developer            ![alt text](http://www.graphtek.com/user_images/Team/Alan_Schmidt.png "Alan Schmidt")
