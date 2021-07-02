Title: Web Scrapping - Passer Data (Part II)
Date: 2016-11-18 20:27
Author: ryan
Tags: nfl, python
Slug: web-scrapping-passer-data-part-ii
Status: published

On a previous post I went through my new found love of Fantasy Football and the rationale behind the 'why' of this particular project. This included getting the team names and their URLs from the [ESPN website](https://www.espn.com).

As before, let's set up some basic infrastructure to be used later:

    from time import strptime

    year = 2016 # allows us to change the year that we are interested in.
    nfl_start_date = date(2016, 9, 8)
    BASE_URL = 'http://espn.go.com/nfl/team/schedule/_/name/{0}/year/{1}/{2}' #URL that we'll use to cycle through to get the gameid's (called match_id)

    match_id = []
    week_id = []
    week_date = []
    match_result = []
    ha_ind = []
    team_list = []

Next, we iterate through the `teams` `dictionary` that I created yesterday:

    for index, row in teams.iterrows():
        _team, url = row['team'], row['url']
        r=requests.get(BASE_URL.format(row['prefix_1'], year, row['prefix_2']))
        table = BeautifulSoup(r.text, 'lxml').table
        for row in table.find_all('tr')[2:]: # Remove header
            columns = row.find_all('td')
            try:
                for result in columns[3].find('li'):
                    match_result.append(result.text)
                    week_id.append(columns[0].text) #get the week_id for the games dictionary so I know what week everything happened
                    _date = date(
                        year,
                        int(strptime(columns[1].text.split(' ')[1], '%b').tm_mon),
                        int(columns[1].text.split(' ')[2])
                    )
                    week_date.append(_date)
                    team_list.append(_team)
                    for ha in columns[2].find_all('li', class_="game-status"):
                        ha_ind.append(ha.text)
                for link in columns[3].find_all('a'): # I realized here that I didn't need to do the fancy thing from the site I was mimicking http://danielfrg.com/blog/2013/04/01/nba-scraping-data/
                    match_id.append(link.get('href')[-9:])

            except Exception as e:
                pass

Again, we set up some variables to be used in the `for` loop. But I want to really talk about the `try` portion of my code and the part where the `week_date` is being calculated.

Although I've been developing and managing developers for a while, I've not had the need to use a construct like `try`. (I know, right, weird!)

The basic premise of the `try` is that it will execute some code and if it succeeds that code will be executed. If not, it will go to the exception portion. For Python (and maybe other languages, I'm not sure) the exception **MUST** have something in it. In this case, I use Python's `pass` function, which basically says, 'hey, just forget about doing anything'. I'm not raising any errors here because I don't care if the result is 'bad' I just want to ignore it because there isn't any data I can use.

The other interesting (or gigantic pain in the a\$\$) thing is that the way [ESPN](https://www.espn.com) displays dates on the schedule page is as `Day of Week, Month Day`, i.e. `Sun Sep 11`. There is no year. I think this is because for the most part the regular season for an [NFL](https://www.nfl.com) is always in the same calendar year. However, this year the last game of the season, in week 17, is in January. Since I'm only getting games that have been played, I'm *safe* for a couple more weeks, but this will need to be addressed, otherwise the date of the last games of the 2016 season will show as January 2016, instead of January 2017.

Anyway, I digress. In order to change the displayed date to a date I can actually use is I had to get the necessary function. In order to get that I had to add the following line to my code from yesterday

    from time import strptime

This allows me to make some changes to the date (see where `_date` is being calculated in `for result in columns[3].find('li'):` portion of the `try:`.

One of the things that confused the heck out of me initially was the way the date is being stored in the list `week_date`. It is in the form `datetime.date(2016, 9, 1)`, but I was expecting it to be stored as `2016-09-01`. I did a couple of things to try and *fix* this, especially because once the list was added to the `gamesdic` `dictionary` and then used in the `games` `DataFrame` the `week_date` was then stored as `1472688000000` which is the milliseconds since Jan 1, 1970 to the date of the game, but it took an embarising amount of [Googling](https://www.google.com) to ~~realize~~ discover this.

With this new discovery, I forged on. The last two things that I needed to do was to create a `dictionary` to hold my data with all of my columns:

    gamesdic = {'match_id': match_id, 'week_id': week_id, 'result': match_result, 'ha_ind': ha_ind, 'team': team_list, 'match_date': week_date}

With dictionary in hand I was able to create a `DataFrame`:

    games = pd.DataFrame(gamesdic).set_index('match_id')

The line above is frighteningly simple. It's basically saying, hey, take all of the data from the `gamesdic` `dictionary` and make the `match_id` the index.

To get the first part, see my post [Web Scrapping - Passer Data (Part I)](https://www.ryancheley.com/blog/2016/11/17/web-scrapping).
