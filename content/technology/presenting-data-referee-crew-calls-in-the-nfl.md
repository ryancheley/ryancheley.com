Title: Presenting Data - Referee Crew Calls in the NFL
Date: 2016-12-25 20:00
Author: ryan
Tags: data visualization, nfl, Python
Slug: presenting-data-referee-crew-calls-in-the-nfl
Status: published

One of the great things about computers is their ability to take tabular data and turn them into pictures that are easier to interpret. I'm always amazed when given the opportunity to show data as a picture, more people don't jump at the chance.

For example, [this piece on ESPN regarding the difference in officiating crews and their calls](http://www.espn.com/blog/nflnation/post/_/id/225804/aaron-rodgers-could-get-some-help-from-referee-jeff-triplette) has some great data in it regarding how different officiating crews call games.

One thing I find a bit disconcerting is:

1.  ~~One of the rows is missing data so that row looks 'odd' in the context of the story and makes it look like the writer missed a big thing ... they didn't~~ (it's since been fixed)
2.  This tabular format is just begging to be displayed as a picture.

Perhaps the issue here is that the author didn't know how to best visualize the data to make his story, but I'm going to help him out.

If we start from the underlying premise that not all officiating crews call games in the same way, we want to see in what ways they differ.

The data below is a reproduction of the table from the article:

  REFEREE              DEF. OFFSIDE   ENCROACH   FALSE START   NEUTRAL ZONE   TOTAL
  ------------------- -------------- ---------- ------------- -------------- -------
  Triplette, Jeff           39           2           34             6          81
  Anderson, Walt            12           2           39             10         63
  Blakeman, Clete           13           2           41             7          63
  Hussey, John              10           3           42             3          58
  Cheffers, Cartlon         22           0           31             3          56
  Corrente, Tony            14           1           31             8          54
  Steratore, Gene           19           1           29             5          54
  Torbert, Ronald           9            4           31             7          51
  Allen, Brad               15           1           28             6          50
  McAulay, Terry            10           4           23             12         49
  Vinovich, Bill            8            7           29             5          49
  Morelli, Peter            12           3           24             9          48
  Boger, Jerome             11           3           27             6          47
  Wrolstad, Craig           9            1           31             5          46
  Hochuli, Ed               5            2           33             4          44
  Coleman, Walt             9            2           25             4          40
  Parry, John               7            5           20             6          38

The author points out:

> > Jeff Triplette's crew has called a combined 81 such penalties -- 18 more than the next-highest crew and more than twice the amount of two others

The author goes on to talk about his interview with [Mike Pereira](https://en.wikipedia.org/wiki/Mike_Pereira) (who happens to be ~~pimping~~ promoting his new book).

While the table above is *helpful* it's not an image that you can look at and ask, "Man, what the heck is going on?" There is a visceral aspect to it that says, something is wrong here ... but I can't **really** be sure about what it is.

Let's sum up the defensive penalties (Defensive Offsides, Encroachment, and Neutral Zone Infractions) and see what the table looks like:

  REFEREE              DEF Total   OFF Total   TOTAL
  ------------------- ----------- ----------- -------
  Triplette, Jeff         47          34        81
  Anderson, Walt          24          39        63
  Blakeman, Clete         22          41        63
  Hussey, John            16          42        58
  Cheffers, Cartlon       25          31        56
  Corrente, Tony          23          31        54
  Steratore, Gene         25          29        54
  Torbert, Ronald         20          31        51
  Allen, Brad             22          28        50
  McAulay, Terry          26          23        49
  Vinovich, Bill          20          29        49
  Morelli, Peter          24          24        48
  Boger, Jerome           20          27        47
  Wrolstad, Craig         15          31        46
  Hochuli, Ed             11          33        44
  Coleman, Walt           15          25        40
  Parry, John             18          20        38

Now we can see what might actually be going on, but it's still a bit hard for those visual people. If we take this data and then generate a scatter plot we might have a picture to show us the issue. Something like this:

![Referee Crew Penalty Calls](/images/uploads/2017/12/Officials-Crew-Calls-NFL-2016-300x222.png){.alignnone .size-medium .wp-image-113 width="300" height="222"}

The horizontal dashed blue lines represent the average defensive calls per crew while the vertical dashed blue line represents the average offensive calls per crew. The gray box represents the area containing plus/minus 2 standard deviations from the mean for both offensive and defensive penalty calls.

Notice anything? Yeah, me too. Jeff Triplette's crew is so far out of range for defensive penalties it's like they're watching a different game, or reading from a different play book.

What I'd really like to be able to do is this same analysis but on a game by game basis. I don't think this would really change the way that Jeff Triplette and his crew call games, but it may point out some other inconsistencies that are worth exploring.

Code for this project can be found on my [GitHub Repo](https://github.com/miloardot/python-files/blob/master/Referees)
