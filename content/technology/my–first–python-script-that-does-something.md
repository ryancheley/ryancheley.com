Title: My First Python Script that does 'something'
Date: 2016-10-15 21:33
Author: ryan
Tags: Python
Slug: my–first–python-script-that-does-something
Status: published

I've been interested in python as a tool for a while and today I had the chance to try and see what I could do.

With my 12.9 iPad Pro set up at my desk, I started out. I have [Ole Zorn's Pythonista 3](http://omz-software.com/pythonista/) installed so I started on my first script.

My first task was to scrape something from a website. I tried to start with a website listing doctors, but for some reason the html rendered didn't include anything useful.

So the next best thing was to find a website with staff listed on it. I used my dad's company and his [staff listing](http://www.graphtek.com/Our-Team) as a starting point.

I started with a quick Google search to find Pythonista Web Scrapping and came across [this](https://forum.omz-software.com/topic/1513/screen-scraping) post on the Pythonista forums.

That got me this much of my script:

    import bs4, requests

    myurl = 'http://www.graphtek.com/Our-Team'

    def get_beautiful_soup(url):

    return bs4.BeautifulSoup(requests.get(url).text, "html5lib")

    soup = get_beautiful_soup(myurl)

Next, I needed to see how to start traversing the html to get the elements that I needed. I recalled something I read a while ago and was (luckily) able to find some [help](https://first-web-scraper.readthedocs.io/en/latest/).

That got me this:

`tablemgmt = soup.findAll('div', attrs={'id':'our-team'})`

This was close, but it would only return 2 of the 3 `div` tags I cared about (the management team has a different id for some reason ... )

I did a search for regular expressions and Python and found this useful [stackoverflow](http://stackoverflow.com/questions/24748445/beautiful-soup-using-regex-to-find-tags) question and saw that if I updated my imports to include `re` then I could use regular expressions.

Great, update the imports section to this:

`import bs4, requests, re`

And added `re.compile` to my `findAll` to get this:

`tablemgmt = soup.findAll('div', attrs={'id':re.compile('our-team')})`

Now I had all 3 of the `div` tags I cared about.

Of course the next thing I wanted to do was get the information i cared out of the structure `tablemgmt`.

When I printed out the results I noticed leading and trailing square brackets and eveytime I tried to do something I'd get an error.

It took an embarrassingly long time to realize that I needed to treat `tablemgmt` as an array. Whoops!

Once I got through that it was straight forward to loop through the data and output it:

    list_of_names = []

    for i in tablemgmt:

    for row in i.findAll('span', attrs={'class':'team-name'}):

    text = row.text.replace('<span class="team-name"', '')

    if len(text)>0:

    list_of_names.append(text)

    list_of_titles = []

    for i in tablemgmt:

    for row in i.findAll('span', attrs={'class':'team-title'}):

    text = row.text.replace('<span class="team-title"', '')

    if len(text)>0:

    list_of_titles.append(text)

The last bit I wanted to do was to add some headers **and** make the lists into a two column multimarkdown table.

OK, first I needed to see how to 'combine' the lists into a multidimensional array. Another google search and ... success. Of course the answer would be on [stackoverflow](http://stackoverflow.com/questions/12040989/printing-all-the-values-from-multiple-lists-at-the-same-time)

With my knowldge of looping through arrays and the function `zip` I was able to get this:

    for j, k in zip(list_of_names, list_of_titles):

    print('|'+ j + '|' + k + '|')

Which would output this:

    |Mike Cheley|CEO/Creative Director|

    |Ozzy|Official Greeter|

    |Jay Sant|Vice President|

    |Shawn Isaac|Vice President|

    |Jason Gurzi|SEM Specialist|

    |Yvonne Valles|Director of First Impressions|

    |Ed Lowell|Senior Designer|

    |Paul Hasas|User Interface Designer|

    |Alan Schmidt|Senior Web Developer|

This is close, however, it still needs headers.

No problem, just add some static lines to print out:

    print('| Name | Title |')
    print('| --- | --- |')

And voila, we have a multimarkdown table that was scrapped from a web page:

    | Name | Title |
    | --- | --- |
    |Mike Cheley|CEO/Creative Director|
    |Ozzy|Official Greeter|
    |Jay Sant|Vice President|
    |Shawn Isaac|Vice President|
    |Jason Gurzi|SEM Specialist|
    |Yvonne Valles|Director of First Impressions|
    |Ed Lowell|Senior Designer|
    |Paul Hasas|User Interface Designer|
    |Alan Schmidt|Senior Web Developer|

Which will render to this:

  Name            Title
  --------------- -------------------------------
  Mike Cheley     CEO/Creative Director
  Ozzy            Official Greeter
  Jay Sant        Vice President
  Shawn Isaac     Vice President
  Jason Gurzi     SEM Specialist
  Yvonne Valles   Director of First Impressions
  Ed Lowell       Senior Designer
  Paul Hasas      User Interface Designer
  Alan Schmidt    Senior Web Developer
