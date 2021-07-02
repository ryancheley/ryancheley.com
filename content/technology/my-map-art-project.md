Title: My Map Art Project
Date: 2018-01-12 05:44
Author: ryan
Tags: art, Python
Slug: my-map-art-project
Status: published

I’d discovered a python package called `osmnx` which will take GIS data and allow you to draw maps using python. Pretty cool, but I wasn’t sure what I was going to do with it.

After a bit of playing around with it I finally decided that I could make some pretty cool [Fractures](https://www.fractureme.com "Fracture").

I’ve got lots of Fracture images in my house and I even turned my diplomas into Fractures to hang up on the wall at my office, but I hadn’t tried to make anything like this before.

I needed to figure out what locations I was going to do. I decided that I wanted to do 9 of them so that I could create a 3 x 3 grid of these maps.

I selected 9 cities that were important to me and my family for various reasons.

Next writing the code. The script is 54 lines of code and doesn’t really adhere to PEP8 but that just gives me a chance to do some reformatting / refactoring later on.

In order to get the desired output I needed several libraries:

    osmnx (as I’d mentioned before)
    matplotlib.pyplot
    numpy
    PIL

If you’ve never used PIL before it’s the ‘Python Image Library’ and according to it’s [home page](http://www.pythonware.com/products/pil/ "Python Image Library Home Page") it

> adds image processing capabilities to your Python interpreter. This library supports many file formats, and provides powerful image processing and graphics capabilities.

OK, let’s import some libraries!

    import osmnx as ox, geopandas as gpd, os
    import matplotlib.pyplot as plt
    import numpy as np
    from PIL import Image
    from PIL import ImageFont
    from PIL import ImageDraw

Next, we establish the configurations:

    ox.config(log_file=True, log_console=False, use_cache=True)

The `ox.config` allows you to specify several options. In this case, I’m:

1.  Specifying that the logs be saved to a file in the log directory
2.  Supress the output of the log file to the console (this is helpful to have set to `True` when you’re first running the script to see what, if any, errors you have.
3.  The `use_chache=True` will use a local cache to save/retrieve http responses instead of calling API repetitively for the same request URL

This option will help performance if you have the run the script more than once.

OSMX has many different options to generate maps. I played around with the options and found that the walking network within 750 meters of my address gave me the most interesting lines.

    AddressDistance = 750
    AddressDistanceType = 'network'
    AddressNetworkType = 'walk'

Now comes some of the most important decisions (and code!). Since I’ll be making this into a printed image I want to make sure that the image and resulting file will be of a high enough quality to render good results. I also want to start with a white background (although a black background might have been kind of cool). I also want to have a high DPI. Taking these needs into consideration I set my plot variables:

    PlotBackgroundColor = '#ffffff'
    PlotNodeSize = 0
    PlotFigureHeight = 40
    PlotFigureWidth = 40
    PlotFileType = 'png'
    PlotDPI = 300
    PlotEdgeLineWidth = 10.0

I played with the `PlotEdgeLineWidth` a bit until I got a result that I liked. It controls how thick the route lines are and is influenced by the `PlotDPI`. For the look I was going for 10.0 worked out well for me. I’m not sure if that means a 30:1 ratio for `PlotDPI` to `PlotEdgeLineWidth` would be universal but if you like what you see then it’s a good place to start.

One final piece was deciding on the landmarks that I was going to use. I picked nine places that my family and I had been to together and used addresses that were either of the places that we stayed at (usually hotels) OR major landmarks in the areas that we stayed. Nothing special here, just a text file with one location per line set up as

> Address, City, State

For example:

> 1234 Main Street, Anytown, CA

So we just read that file into memory:

    landmarks = open('/Users/Ryan/Dropbox/Ryan/Python/landmarks.txt', 'r')

Next we set up some scaffolding so we can loop through the data effectively

    landmarks = landmarks.readlines()
    landmarks = [item.rstrip() for item in landmarks]

    fill = (0,0,0,0)

    city = []

The loop below is doing a couple of things:

1.  Splits the landmarks array into base elements by breaking it apart at the commas (I can do this because of the way that the addresses were entered. Changes may be needed to account for my complex addresses (i.e. those with multiple address lines (suite numbers, etc) or if local addresses aren’t constructed in the same way that US addresses are)
2.  Appends the second and third elements of the `parts` array and replaces the space between them with an underscore to convert `Anytown, CA` to `Anytown_CA`

```{=html}
<!-- -->
```
    for element in landmarks:
        parts = element.split(',')
        city.append(parts[1].replace(' ', '', 1)+'_'+parts[2].replace(' ', ''))

This next line isn’t strictly necessary as it could just live in the loop, but it was helpful for me when writing to see what was going on. We want to know how many items are in the `landmarks`

    rows = len(landmarks)

Now to loop through it. A couple of things of note:

The package includes several `graph_from_...` functions. They take as input some type, like address, i.e. `graph_from_address` (which is what I’m using) and have several keyword arguments.

In the code below I’m using the ith landmarks item and setting the `distance`, `distance_type`, `network_type` and specifying an option to make the map simple by setting `simplify=‘true’`

To add some visual interest to the map I’m using this line

    ec = ['#cc0000' if data['length'] >=100 else '#3366cc' for u, v, key, data in G.edges(keys=True, data=True)]

If the length of the part of the map is longer than 100m then the color is displayed as `#cc0000` (red) otherwise it will be `#3366cc` (blue)

The `plot_graph` is what does the heavy lifting to generate the image. It takes as input the output from the `graph_from_address` and `ec` to identify what and how the map will look.

Next we use the `PIL` library to add text to the image. It takes into memory the image file and saves out to a directory called `/images/`. My favorite part of this library is that I can choose what font I want to use (whether it’s part of the system fonts or a custom user font) and the size of the font. For my project I used San Francisco at 512.

Finally, there is an exception for the code that adds text. The reason for this is that when I was playing with adding text to the image I found that for 8 of 9 maps having the text in the upper left hand corner worker really well. It was just that last one (San Luis Obispo, CA) that didn’t.

So, instead of trying to find a different landmark, I decided to take a bit of artistic license and put the San Luis Obispo text in the upper right hard corner.

Once the script is all set simply typing `python MapProject.py` in my terminal window from the directory where the file is saved generated the files.

All I had to do what wait and the images were saved to my `/images/` directory.

Next, upload to Fracture and order the glass images!

I received the images and was super excited. However, upon opening the box and looking at them I noticed something wasn’t quite right

\[caption id="attachment_188" align="alignnone" width="2376"\]![Napa with the text slightly off the image]images/uploads/2018/01/Image-12-16-17-6-55-AM.jpeg){.alignnone .size-full .wp-image-188 width="2376" height="2327"} Napa with the text slightly off the image\[/caption\]

As you can see, the name place is cut off on the left. Bummer.

No reason to fret though! Fracture has a 100% satisfaction guarantee. So I emailed support and explained the situation.

Within a couple of days I had my bright and shiny fractures to hang on my wall

\[caption id="attachment_187" align="alignnone" width="2138"\]![Napa with the text properly displaying]images/uploads/2018/01/IMG_9079.jpg){.alignnone .size-full .wp-image-187 width="2138" height="2138"} Napa with the text properly displaying\[/caption\]

So that my office wall is no longer blank and boring:

![Borking Wall](/images/uploads/2018/01/UNADJUSTEDNONRAW_thumb_380b.jpg){.alignnone .size-full .wp-image-189 width="1024" height="768"}

but interesting and fun to look at

![Artful Wall](/images/uploads/2018/01/IMG_9156.jpg){.alignnone .size-full .wp-image-186 width="4032" height="3024"}
