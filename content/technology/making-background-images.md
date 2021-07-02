Title: Making Background Images
Date: 2017-09-17 23:24
Author: ryan
Tags: macOS
Slug: making-background-images
Status: published

I'm a big fan of [podcasts](http://www.ryancheley.com/podcasts-i-like/). I've been listening to them for 4 or 5 years now. One of my favorite Podcast Networks, [Relay](http://www.relay.fm) just had their second anniversary. They offer memberships and after listening to hours and hours of *All The Great Shows* I decided that I needed to become a [member](https://www.relay.fm/membership).

One of the awesome perks of [Relay](http://www.relay.fm) membership is a set of **Amazing** background images.

This is fortuitous as I've been looking for some good backgrounds for my iMac, and so it seemed like a perfect fit.

On my iMac I have several `spaces` configured. One for `Writing`, one for `Podcast` and one for everything else. I wanted to take the backgrounds from Relay and have them on the `Writing` space and the `Podcasting` space, but I also wanted to be able to distinguish between them. One thing I could try to do would be to open up an image editor (Like [Photoshop](http://www.photoshop.com), [Pixelmater](http://www.pixelmator.com/pro/) or [Acorn](https://flyingmeat.com/acorn/)) and add text to them one at a time (although I'm sure there is a way to script them) but I decided to see if I could do it using Python.

Turns out, I can.

This code will take the background images from my `/Users/Ryan/Relay 5K Backgrounds/` directory and spit them out into a subdirectory called `Podcasting`

    from PIL import Image, ImageStat, ImageFont, ImageDraw
    from os import listdir
    from os.path import isfile, join

    # Declare Text Attributes
    TextFontSize = 400
    TextFontColor = (128,128,128)
    font = ImageFont.truetype("~/Library/Fonts/Inconsolata.otf", TextFontSize)

    mypath = '/Users/Ryan/Relay 5K Backgrounds/'
    onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
    onlyfiles.remove('.DS_Store')

    rows = len(onlyfiles)

    for i in range(rows):
        img = Image.open(mypath+onlyfiles[i])
        width, height = img.size
        draw = ImageDraw.Draw(img)
        TextXPos = 0.6 * width
        TextYPos = 0.85 * height
        draw.text((TextXPos, TextYPos),'Podcasting',TextFontColor,font=font)
        draw.text
        img.save('/Users/Ryan/Relay 5K Backgrounds/Podcasting/'+onlyfiles[i])
        print('/Users/Ryan/Relay 5K Backgrounds/Podcasting/'+onlyfiles[i]+' succesfully saved!')

This was great, but it included all of the images, and some of them are *really* bright. I mean, like *really* bright.

So I decided to use [something I learned while helping my daughter with her Science Project last year](http://www.ryancheley.com/blog/2016/12/17/its-science) and determine the brightness of the images and use only the dark ones.

This lead me to update the code to this:

    from PIL import Image, ImageStat, ImageFont, ImageDraw
    from os import listdir
    from os.path import isfile, join

    def brightness01( im_file ):
       im = Image.open(im_file).convert('L')
       stat = ImageStat.Stat(im)
       return stat.mean[0]

    # Declare Text Attributes
    TextFontSize = 400
    TextFontColor = (128,128,128)
    font = ImageFont.truetype("~/Library/Fonts/Inconsolata.otf", TextFontSize)

    mypath = '/Users/Ryan/Relay 5K Backgrounds/'
    onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
    onlyfiles.remove('.DS_Store')

    darkimages = []

    rows = len(onlyfiles)

    for i in range(rows):
        if brightness01(mypath+onlyfiles[i]) <= 65:
            darkimages.append(onlyfiles[i])

    darkimagesrows = len(darkimages)

    for i in range(darkimagesrows):
        img = Image.open(mypath+darkimages[i])
        width, height = img.size
        draw = ImageDraw.Draw(img)
        TextXPos = 0.6 * width
        TextYPos = 0.85 * height
        draw.text((TextXPos, TextYPos),'Podcasting',TextFontColor,font=font)
        draw.text
        img.save('/Users/Ryan/Relay 5K Backgrounds/Podcasting/'+darkimages[i])
        print('/Users/Ryan/Relay 5K Backgrounds/Podcasting/'+darkimages[i]+' succesfully saved!')

I also wanted to have backgrounds generated for my **Writing** space, so I tacked on this code:

    for i in range(darkimagesrows):
        img = Image.open(mypath+darkimages[i])
        width, height = img.size
        draw = ImageDraw.Draw(img)
        TextXPos = 0.72 * width
        TextYPos = 0.85 * height
        draw.text((TextXPos, TextYPos),'Writing',TextFontColor,font=font)
        draw.text
        img.save('/Users/Ryan/Relay 5K Backgrounds/Writing/'+darkimages[i])
        print('/Users/Ryan/Relay 5K Backgrounds/Writing/'+darkimages[i]+' succesfully saved!')

The `print` statements at the end of the `for` loops were so that I could tell that something was actually happening. The images were VERY large (close to 10MB for each one) so the `PIL` library was taking some time to process the data and I was concerned that something had frozen / stopped working

This was a pretty straightforward project, but it was pretty fun. It allowed me to go from this:

![Cortex Background Original](/images/uploads/2017/09/Cortex-5K-small-original-300x169.png){.alignnone .size-medium .wp-image-121 width="300" height="169"}

To this:

![Cortex Background resized](/images/uploads/2017/09/Cortex-5K-small-300x169.png){.alignnone .size-medium .wp-image-122 width="300" height="169"}

For the text attributes I had to play around with them for a while until I found the color, font and font size that I liked and looked good (to me).

The Positioning of the text also took a bit of experimentation, but a little trial and error and I was all set.

Also, for the `brightness` level of 65 I just looked at the images that seemed to work and found a threshold to use. The actual value may vary depending on the look you're doing for.
