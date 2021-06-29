Title: Dropbox Files Word Cloud
Date: 2016-11-25 16:22
Author: ryan
Category: Technology
Tags: Python
Slug: dropbox-files-word-cloud
Status: published

In one of my [previous posts](https://www.ryancheley.com/blog/2016/11/22/twitter-word-cloud) I walked through how I generated a wordcloud based on my most recent 20 tweets. I though it would be *neat* to do this for my [Dropbox](https://www.dropbox.com) file names as well. just to see if I could.

When I first tried to do it (as previously stated, the Twitter Word Cloud post was the first python script I wrote) I ran into some difficulties. I didn't really understand what I was doing (although I still don't **really** understand, I at least have a vague idea of what the heck I'm doing now).

The script isn't much different than the [Twitter](https://www.twitter.com) word cloud. The only real differences are:

1.  the way in which the `words` variable is being populated
2.  the mask that I'm using to display the cloud

In order to go get the information from the file system I use the `glob` library:

    import glob

The next lines have not changed

    import matplotlib.pyplot as plt
    from wordcloud import WordCloud, STOPWORDS
    from scipy.misc import imread

Instead of writing to a 'tweets' file I'm looping through the files, splitting them at the `/` character and getting the last item (i.e. the file name) and appending it to the list `f`:

    f = []
    for filename in glob.glob('/Users/Ryan/Dropbox/Ryan/**/*', recursive=True):
        f.append(filename.split('/')[-1])

The rest of the script generates the image and saves it to my Dropbox Account. Again, instead of using a [Twitter](https://www.twitter.com) logo, I'm using a **Cloud** image I found [here](http://www.shapecollage.com/shapes/mask-cloud.png)

    words = ' '
    for line in f:
        words= words + line

    stopwords = {'https'}

    logomask = imread('mask-cloud.png')

    wordcloud = WordCloud(
        font_path='/Users/Ryan/Library/Fonts/Inconsolata.otf',
        stopwords=STOPWORDS.union(stopwords),
        background_color='white',
        mask = logomask,
        max_words=1000,
        width=1800,
        height=1400
    ).generate(words)

    plt.imshow(wordcloud.recolor(color_func=None, random_state=3))
    plt.axis('off')
    plt.savefig('/Users/Ryan/Dropbox/Ryan/Post Images/dropbox_wordcloud.png', dpi=300)
    plt.show()

And we get this:

![](/images/uploads/2017/12/dropbox_wordcloud-300x200.png){.alignnone .size-medium .wp-image-112 width="300" height="200"}
