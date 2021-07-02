Title: Daylight Savings Time
Date: 2018-03-26 19:02
Author: ryan
Tags: Python
Slug: daylight-savings-time
Status: published

[Dr Drang has posted on Daylight Savings in the past](http://www.leancrew.com/all-this/2013/03/why-i-like-dst/), but in a recent [post](http://leancrew.com/all-this/2018/03/one-table-following-another/) he critiqued (rightly so) the data presentation by a journalist at the Washington Post on Daylight Savings, and that got me thinking.

In the post he generated a chart showing both the total number of daylight hours and the sunrise / sunset times in Chicago. However, initially he didn’t post the code on how he generated it. The next day, in a follow up [post](http://leancrew.com/all-this/2018/03/the-sunrise-plot/), he did and that **really** got my thinking.

I wonder what the chart would look like for cities up and down the west coast (say from San Diego, CA to Seattle WA)?

Drang’s post had all of the code necessary to generate the graph, but for the data munging, he indicated:

> > If I were going to do this sort of thing on a regular basis, I’d write a script to handle this editing, but for a one-off I just did it “by hand.”

Doing it by hand wasn’t going to work for me if I was going to do several cities and so I needed to write a parser for the source of the data ([The US Naval Observatory](http://aa.usno.navy.mil)).

The entire script is on my GitHub [sunrise*sunset*](https://github.com/ryancheley/sunrise_sunset) repo. I won’t go into the nitty gritty details, but I will call out a couple of things that I discovered during the development process.

Writing a parser is hard. Like *really* hard. Each time I thought I had it, I didn’t. I was finally able to get the parser to work o cities with `01`, `29`,`30`, or `31` in their longitude / latitude combinations.

I generated the same graph as Dr. Drang for the following cities:

-   Phoenix, AZ
-   Eugene, OR
-   Portland
-   Salem, OR
-   Seaside, OR
-   Eureka, CA
-   Indio, CA
-   Long Beach, CA
-   Monterey, CA
-   San Diego, CA
-   San Francisco, CA
-   San Luis Obispo, CA
-   Ventura, CA
-   Ferndale, WA
-   Olympia, WA
-   Seattle, WA

Why did I pick a city in Arizona? They don’t do Daylight Savings and I wanted to have a comparison of what it’s like for them!

The charts in latitude order (from south to north) are below:

San Diego

![San Diego](/images/uploads/2018/03/N32_45_San-Diego_CA_rise_set_chart.png){.alignnone .wp-image-242 .size-full width="1500" height="900"}

Phoenix

![Phoenix](/images/uploads/2018/03/N33_30_Phoenix_AZ_rise_set_chart.png){.alignnone .wp-image-497 .size-full width="1500" height="900"}

Indio

![Indio](/images/uploads/2018/03/N33_44_Indio_CA_rise_set_chart.png){.alignnone .size-full .wp-image-249 width="1500" height="900"}

Long Beach

![Long Beach](/images/uploads/2018/03/N33_49_Long-Beach_CA_rise_set_chart.png){.alignnone .size-full .wp-image-250 width="1500" height="900"}

Ventura

![Ventura](/images/uploads/2018/03/N34_17_Ventura_CA_rise_set_chart.png){.alignnone .size-full .wp-image-238 width="1500" height="900"}

San Luis Obispo

![San Luis Obispo](/images/uploads/2018/03/N35_17_San-Luis-Obispo_CA_rise_set_chart.png){.alignnone .size-full .wp-image-234 width="1500" height="900"}

Monterey

![Monterey](/images/uploads/2018/03/N36_36_Monterey_CA_rise_set_chart.png){.alignnone .size-full .wp-image-245 width="1500" height="900"}

San Francisco

![San Francisco](/images/uploads/2018/03/N37_46_San-Francisco_CA_rise_set_chart.png){.alignnone .size-full .wp-image-235 width="1500" height="900"}

Eureka

![Eureka](/images/uploads/2018/03/N40_47_Eureka_CA_rise_set_chart.png){.alignnone .size-full .wp-image-236 width="1500" height="900"}

Eugene

![Eugene](/images/uploads/2018/03/N44_03_Eugene_OR_rise_set_chart.png){.alignnone .size-full .wp-image-247 width="1500" height="900"}

Salem

![Salem](/images/uploads/2018/03/N44_56_Salem_OR_rise_set_chart.png){.alignnone .size-full .wp-image-240 width="1500" height="900"}

Portland

![Portland](/images/uploads/2018/03/N45_31_Portland_OR_rise_set_chart.png){.alignnone .size-full .wp-image-248 width="1500" height="900"}

Seaside

![Seaside](/images/uploads/2018/03/N45_59_Seaside_OR_rise_set_chart.png){.alignnone .size-full .wp-image-244 width="1500" height="900"}

Olympia

![Olympia](/images/uploads/2018/03/N47_02_Olympia_WA_rise_set_chart.png){.alignnone .size-full .wp-image-241 width="1500" height="900"}

Seattle

![Seattle](/images/uploads/2018/03/N47_38_Seattle_WA_rise_set_chart.png){.alignnone .size-full .wp-image-246 width="1500" height="900"}

Ferndale

![Ferndale](/images/uploads/2018/03/N48_51_Ferndale_WA_rise_set_chart.png){.alignnone .size-full .wp-image-243 width="1500" height="900"}

While these images do show the different impact of Daylight Savings, I think the images are more compelling when shown as a GIF:

![All Cities GIF](/images/uploads/2018/03/animated.gif){.alignnone .size-full .wp-image-239 width="1500" height="900"}

We see just how different the impacts of DST are on each city depending on their latitude.

One of [Dr. Drang’s main points in support of DST](http://www.leancrew.com/all-this/2013/03/why-i-like-dst/) is:

> > If, by the way, you think the solution is to stay on DST throughout the year, I can only tell you that we tried that back in the 70s and it didn’t turn out well. Sunrise here in Chicago was after 8:00 am, which put school children out on the street at bus stops before dawn in the dead of winter. It was the same on the East Coast. Nobody liked that.

I think that comment says more about our school system and less about the need for DST.

For this whole argument I’m way more on the side of CGP Grey who does a [great job of explaining what Day Lights Time is](https://www.youtube.com/watch?v=84aWtseb2-4).

I think we may want to start looking at a Universal Planetary time (say UTC) and base all activities on that **regardless** of where you are in the world. The only reason 5am *seems* early (to some people) is because we’ve collectively decided that 5am (depending on the time of the year) is either **WAY** before sunrise or just a bit before sunrise, but really it’s just a number.

If we used UTC in California (where I’m at) 5am would we 12pm. Normally 12pm would be lunch time, but that’s only a convention that we have constructed. It could just as easily be the crack of dawn as it could be lunch time.

Do I think a conversion like this will ever happen? No. I just really hope that at some point in the distant future when aliens finally come and visit us, we aren’t late (or them early) because we have such a wacky time system here.
