Title: Pitching Stats and Python
Date: 2016-11-21 05:19
Author: ryan
Tags: mlb, Python
Slug: pitching-stats-and-python
Status: published

I'm an avid [Twitter](https://www.twitter.com) user, mostly as a replacement [RSS](https://en.wikipedia.org/wiki/RSS) feeder, but also because I can't stand [Facebook](https://www.facebook.com) and this allows me to learn about really important world events when I need to and to just stay isolated with [my head in the sand](http://gerdleonhard.typepad.com/.a/6a00d8341c59be53ef013488b614d8970c-800wi) when I don't. It's perfect for me.

One of the people I follow on [Twitter](https://twitter.com/drdrang) is [Dr. Drang](http://www.leancrew.com/all-this/) who is an Engineer of some kind by training. He also appears to be a fan of baseball and posted an [analysis of Jake Arrieata's pitching](http://leancrew.com/all-this/2016/09/jake-arrieta-and-python/) over the course of the 2016 MLB season (through September 22 at least).

When I first read it I hadn't done too much with Python, and while I found the results interesting, I wasn't sure what any of the code was doing (not really anyway).

Since I had just spent the last couple of days learning more about `BeautifulSoup` specifically and `Python` in general I thought I'd try to do two things:

1.  Update the data used by Dr. Drang
2.  Try to generalize it for any pitcher

Dr. Drang uses a flat csv file for his analysis and I wanted to use `BeautifulSoup` to scrape the data from [ESPN](https://www.espn.com) directly.

OK, I know how to do that (sort of ¯\\*(ツ)*/¯)

First things first, import your libraries:

    import pandas as pd
    from functools import partial
    import requests
    import re
    from bs4 import BeautifulSoup
    import matplotlib.pyplot as plt
    from datetime import datetime, date
    from time import strptime

The next two lines I ~~stole~~ borrowed directly from Dr. Drang's post. The first line is to force the plot output to be inline with the code entered in the terminal. The second he explains as such:

> > The odd ones are the `rcParams` call, which makes the inline graphs bigger than the tiny Jupyter default, and the functools import, which will help us create ERAs over small portions of the season.

I'm not using [Jupyter](http://jupyter.org) I'm using [Rodeo](http://rodeo.yhat.com) as my IDE but I kept them all the same:

    %matplotlib inline
    plt.rcParams['figure.figsize'] = (12,9)

In the next section I use `BeautifulSoup` to scrape the data I want from [ESPN](https://www.espn.com):

    url = 'http://www.espn.com/mlb/player/gamelog/_/id/30145/jake-arrieta'
    r = requests.get(url)
    year = 2016

    date_pitched = []
    full_ip = []
    part_ip = []
    earned_runs = []

    tables = BeautifulSoup(r.text, 'lxml').find_all('table', class_='tablehead mod-player-stats')
    for table in tables:
        for row in table.find_all('tr'): # Remove header
            columns = row.find_all('td')
            try:
                if re.match('[a-zA-Z]{3}\s', columns[0].text) is not None:
                    date_pitched.append(
                        date(
                        year
                        , strptime(columns[0].text.split(' ')[0], '%b').tm_mon
                        , int(columns[0].text.split(' ')[1])
                        )
                    )
                    full_ip.append(str(columns[3].text).split('.')[0])
                    part_ip.append(str(columns[3].text).split('.')[1])
                    earned_runs.append(columns[6].text)
            except Exception as e:
                pass

This is basically a rehash of what I did for my Passer scraping ([here](https://www.ryancheley.com/blog/2016/11/17/web-scrapping), [here](https://www.ryancheley.com/blog/2016/11/18/web-scrapping-passer-data-part-ii), and [here](https://www.ryancheley.com/blog/2016/11/19/web-scrapping-passer-data-part-iii)).

This proved a useful starting point, but unlike the NFL data on ESPN which has pre- and regular season breaks, the MLB data on ESPN has monthly breaks, like this:

    Regular Season Games through October 2, 2016
    DATE
    Oct 1
    Monthly Totals
    DATE
    Sep 24
    Sep 19
    Sep 14
    Sep 9
    Monthly Totals
    DATE
    Jun 26
    Jun 20
    Jun 15
    Jun 10
    Jun 4
    Monthly Totals
    DATE
    May 29
    May 23
    May 17
    May 12
    May 7
    May 1
    Monthly Totals
    DATE
    Apr 26
    Apr 21
    Apr 15
    Apr 9
    Apr 4
    Monthly Totals

However, all I wanted was the lines that correspond to `columns[0].text` with actual dates like 'Apr 21'.

In reviewing how the dates were being displayed it was basically '%b %D', i.e. May 12, Jun 4, etc. This is great because it means I want 3 letters and then a space and nothing else. Turns out, Regular Expressions are great for stuff like this!

After a bit of [Googling](https://www.google.com) I got what I was looking for:

    re.match('[a-zA-Z]{3}\s', columns[0].text)

To get my regular expression and then just add an `if` in front and call it good!

The only issue was that as I ran it in testing, I kept getting no return data. What I didn't realize is that returns a `NoneType` when it's false. Enter more Googling and I see that in order for the `if` to work I have to add the `is not None` which leads to results that I wanted:

    Oct 22
    Oct 16
    Oct 13
    Oct 11
    Oct 7
    Oct 1
    Sep 24
    Sep 19
    Sep 14
    Sep 9
    Jun 26
    Jun 20
    Jun 15
    Jun 10
    Jun 4
    May 29
    May 23
    May 17
    May 12
    May 7
    May 1
    Apr 26
    Apr 21
    Apr 15
    Apr 9
    Apr 4

The next part of the transformation is to convert to a date so I can sort on it (and display it properly) later.

With all of the data I need, I put the columns into a `Dictionary`:

    dic = {'date': date_pitched, 'Full_IP': full_ip, 'Partial_IP': part_ip, 'ER': earned_runs}

and then into a `DataFrame`:

    games = pd.DataFrame(dic)

and apply some manipulations to the `DataFrame`:

    games = games.sort_values(['date'], ascending=[True])
    games[['Full_IP','Partial_IP', 'ER']] = games[['Full_IP','Partial_IP', 'ER']].apply(pd.to_numeric)

Now to apply some Baseball math to get the Earned Run Average:

    games['IP'] = games.Full_IP + games.Partial_IP/3
    games['GERA'] = games.ER/games.IP*9
    games['CIP'] = games.IP.cumsum()
    games['CER'] = games.ER.cumsum()
    games['ERA'] = games.CER/games.CIP*9

In the next part of Dr. Drang's post he writes a custom function to help create moving averages. It looks like this:

    def rera(games, row):
        if row.name+1 < games:
            ip = df.IP[:row.name+1].sum()
            er = df.ER[:row.name+1].sum()
        else:
            ip = df.IP[row.name+1-games:row.name+1].sum()
            er = df.ER[row.name+1-games:row.name+1].sum()
        return er/ip*9

The only problem with it is I called my `DataFrame` `games`, not `df`. Simple enough, I'll just replace `df` with `games` and call it a day, right? Nope:

    def rera(games, row):
        if row.name+1 < games:
            ip = games.IP[:row.name+1].sum()
            er = games.ER[:row.name+1].sum()
        else:
            ip = games.IP[row.name+1-games:row.name+1].sum()
            er = games.ER[row.name+1-games:row.name+1].sum()
        return er/ip*9

When I try to run the code I get errors. Lots of them. This is because while i made sure to update the `DataFrame` name to be correct I overlooked that the function was using a parameter called `games` and `Python` got a bit confused about what was what.

OK, round two, replace the paramater `games` with `games_t`:

    def rera(games_t, row):
        if row.name+1 < games_t:
            ip = games.IP[:row.name+1].sum()
            er = games.ER[:row.name+1].sum()
        else:
            ip = games.IP[row.name+1-games_t:row.name+1].sum()
            er = games.ER[row.name+1-games_t:row.name+1].sum()
        return er/ip*9

No more errors! Now we calculate the 3- and 4-game moving averages:

    era4 = partial(rera, 4)
    era3 = partial(rera,3)

and then add them to the `DataFrame`:

    games['ERA4'] = games.apply(era4, axis=1)
    games['ERA3'] = games.apply(era3, axis=1)

And print out a pretty graph:

    plt.plot_date(games.date, games.ERA3, '-b', lw=2)
    plt.plot_date(games.date, games.ERA4, '-r', lw=2)
    plt.plot_date(games.date, games.GERA, '.k', ms=10)
    plt.plot_date(games.date, games.ERA, '--k', lw=2)
    plt.show()

Dr. Drang focused on Jake Arrieta (he is a Chicago guy after all), but I thought it was be interested to look at the Graphs for Arrieta and the top 5 finishers in the NL Cy Young Voting (because Clayton Kershaw was 5th place and I'm a Dodgers guy).

Here is the graph for [Jake Arrieata](http://www.espn.com/mlb/player/gamelog/_/id/30145/jake-arrieta):

![Jake Arrieata](/images/uploads/2016/11/arrieta-300x222.png){.alignnone .size-medium .wp-image-177 width="300" height="222"}

And here are the graphs for the top 5 finishers in Ascending order in the [2016 NL Cy Young voting](http://bbwaa.com/16-nl-cy/):

[Max Scherzer](http://www.espn.com/mlb/player/gamelog/_/id/28976/max-scherzer) winner of the 2016 NL [Cy Young Award](https://en.wikipedia.org/wiki/Cy_Young_Award)
![Max Scherzer](/images/uploads/2016/11/scherzer-300x229.png){.alignnone .size-medium .wp-image-178 width="300" height="229"}

[Jon Lester](http://www.espn.com/mlb/player/gamelog/_/id/28487/jon-lester)
![Jon Lester](/images/uploads/2016/11/lester-300x223.png){.alignnone .size-medium .wp-image-182 width="300" height="223"}

[Kyle Hendricks](http://www.espn.com/mlb/player/gamelog/_/id/33173/kyle-hendricks)
![Kyle Hendricks](/images/uploads/2016/11/hendricks-300x225.png){.alignnone .size-medium .wp-image-179 width="300" height="225"}

[Madison Bumgarner](http://www.espn.com/mlb/player/gamelog/_/id/29949/madison-bumgarner)
![Madison Bumgarner](/images/uploads/2016/11/bumgarner-300x232.png){.alignnone .size-medium .wp-image-180 width="300" height="232"}

[Clayton Kershaw](http://www.espn.com/mlb/player/gamelog/_/id/28963/clayton-kershaw):

![Clayton Kershaw](/images/uploads/2016/11/kershaw-300x232.png){.alignnone .size-medium .wp-image-176 width="300" height="232"}

I've not spent much time analyzing the data, but I'm sure that it says *something*. At the very least, it got me to wonder, 'How many 0 ER games did each pitcher pitch?'

I also noticed that the stats include the playoffs (which I wasn't intending). Another thing to look at later.

Legend:

-   Black Dot - ERA on Date of Game
-   Black Solid Line - Cummulative ERA
-   Blue Solid Line - 3-game trailing average ERA
-   Red Solid Line - 4-game trailing average ERA

Full code can be found on my [Github Repo](https://www.github.com/miloardot)
