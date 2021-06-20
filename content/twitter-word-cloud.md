Title: Twitter Word Cloud
Date: 2016-11-23 03:41
Author: ryan
Category: Python
Tags: python, twitter
Slug: twitter-word-cloud
Status: published

[As previously mentioned](/pitching-stats-and-python.html) I'm a bit of a [Twitter](https://www.twitter.com) user. One of the things that I came across, actually the first python project I did, was writing code to create a [word cloud](https://en.wikipedia.org/wiki/Tag_cloud) based on the most recent 20 posts of my [Twitter](https://www.twitter.com/) feed.

I used a post by [Sebastian Raschka](http://sebastianraschka.com/Articles/2014_twitter_wordcloud.html) and a post on [TechTrek.io](http://www.techtrek.io/generating-word-cloud-from-twitter-feed-with-python/) as guides and was able to generate the word cloud pretty easily.

As usual, we import the need libraries:

    import tweepy, json, random
    from tweepy import OAuthHandler
    import matplotlib.pyplot as plt
    from wordcloud import WordCloud, STOPWORDS
    from scipy.misc import imread

The code below allows access to my feed using secret keys from my twitter account. They have been removed from the post so that my twitter account doesn't stop being mine:

    consumer_key = consumer_key
    consumer_secret = consumer_secret
    access_token = access_token
    access_secret = access_secret

    auth = OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_secret)

    api = tweepy.API(auth)

Next I open a file called `tweets` and write to it the tweets (referred to in the `for` loop as `status`) and encode with `utf-8`. If you don't do the following error is thrown: `TypeError: a bytes-like object is required, not 'str'`. And who wants a `TypeError` to be thrown?

    f = open('tweets', 'wb')

    for status in api.user_timeline():
        f.write(api.get_status(status.id).text.encode("utf-8"))
    f.close()

Now I'm ready to do something with the tweets that I collected. I read the file into a variable called `words`

    words=' '
    count =0
    f = open('tweets', 'rb')
    for line in f:
        words= words + line.decode("utf-8")
    f.close

Next, we start on constructing the word cloud itself. We declare words that we want to ignore (in this case **https** is ignored, otherwise it would count the protocol of links that I've been tweeting).

    stopwords = {'https', 'co', 'RT'}

Read in the twitter bird to act as a mask

    logomask = imread('twitter_mask.png')

Finally, generate the wordcloud, plot it and save the image:

    wordcloud = WordCloud(
        font_path='/Users/Ryan/Library/Fonts/Inconsolata.otf',
        stopwords=STOPWORDS.union(stopwords),
        background_color='white',
        mask = logomask,
        max_words=500,
        width=1800,
        height=1400
    ).generate(words)

    plt.imshow(wordcloud.recolor(color_func=None, random_state=3))
    plt.axis('off')
    plt.savefig('./Twitter Word Cloud - '+time.strftime("%Y%m%d")+'.png', dpi=300)
    plt.show()

The second to last line generates a dynamically named file based on the date so that I can do this again and save the image without needing to do too much thinking.

Full Code can be found on my [GitHub Report](https://www.github.com/miloardot/)

My Twitter Word Cloud as of today looks like this:

![](/images/uploads/2017/12/Twitter-Word-Cloud-20161122-300x200.png){.alignnone .size-medium .wp-image-116 width="300" height="200"}

I think it will be fun to post this image every once in a while, so as I remember, I'll run the script again and update the Word Cloud!
