Title: Web Scrapping - Passer Data (Part III)
Date: 2016-11-19 17:25
Author: ryan
Tags: nfl, python
Slug: web-scrapping-passer-data-part-iii
Status: published

In Part III I'm reviewing the code to populate a DataFrame with Passer data from the current NFL season.

To start I use the `games` `DataFrame` I created in [Part II](https://www.ryancheley.com/blog/2016/11/18/web-scrapping-passer-data-part-ii) to create 4 new `DataFrames`:

-   reg_season_games - All of the Regular Season Games
-   pre_season_games - All of the Pre Season Games
-   gameshome - The Home Games
-   gamesaway - The Away Games

A cool aspect of the DataFrames is that you can treat them kind of like temporary tables (at least, this is how I'm thinking about them as I am mostly a `SQL` programmer) and create other temporary tables based on criteria. In the code below I'm taking the `nfl_start_date` that I defined in [Part II](https://www.ryancheley.com/blog/2016/11/18/web-scrapping-passer-data-part-ii) as a way to split the data frame into pre / and regular season `DataFrame`. I then take the regular season `DataFrame` and split that into home and away `DataFrames`. I do this so I don't double count the statistics for the passers.

    #Start Section 3

    reg_season_games = games.loc[games['match_date'] >= nfl_start_date]
    pre_season_games = games.loc[games['match_date'] < nfl_start_date]

    gameshome = reg_season_games.loc[reg_season_games['ha_ind'] == 'vs']
    gamesaway = reg_season_games.loc[reg_season_games['ha_ind'] == '@']

Next, I set up some variables to be used later:

    BASE_URL = 'http://www.espn.com/nfl/boxscore/_/gameId/{0}'

    #Create the lists to hold the values for the games for the passers
    player_pass_name = []
    player_pass_catch = []
    player_pass_attempt = []
    player_pass_yds = []
    player_pass_avg = []
    player_pass_td = []
    player_pass_int = []
    player_pass_sacks = []
    player_pass_sacks_yds_lost = []
    player_pass_rtg = []
    player_pass_week_id = []
    player_pass_result = []
    player_pass_team = []
    player_pass_ha_ind = []
    player_match_id = []
    player_id = [] #declare the player_id as a list so it doesn't get set to a str by the loop below

    headers_pass = ['match_id', 'id', 'Name', 'CATCHES','ATTEMPTS', 'YDS', 'AVG', 'TD', 'INT', 'SACKS', 'YRDLSTSACKS', 'RTG']

Now it's time to start populating some of the `list` variables I created above. I am taking the `week_id`, `result`, `team_x`, and `ha_ind` columns from the `games` `DataFrame` (I'm sure there is a better way to do this, and I will need to revisit it in the future)

    player_pass_week_id.append(gamesaway.week_id)
    player_pass_result.append(gamesaway.result)
    player_pass_team.append(gamesaway.team_x)
    player_pass_ha_ind.append(gamesaway.ha_ind)

Now for the looping (everybody's favorite part!). Using `BeautifulSoup` I get the `div` of class `col column-one gamepackage-away-wrap`. Once I have that I get the table rows and then loop through the data in the row to get what I need from the table holding the passer data. Some intersting things happening below:

-   The Catches / Attempts and Sacks / Yrds Lost are displayed as a single column each (even though each column holds 2 statistics). In order to *fix* this I use the `index()` method and get all of the data to the left of a character (`-` and `/` respectively for each column previously mentioned) and append the resulting 2 items per column (so four in total) to 2 different lists (four in total).

The last line of code gets the [ESPN](https://www.espn.com) `player_id`, just in case I need/want to use it later.

    for index, row in gamesaway.iterrows():
        print(index)
        try:
            request = requests.get(BASE_URL.format(index))
            table_pass = BeautifulSoup(request.text, 'lxml').find_all('div', class_='col column-one gamepackage-away-wrap')

            pass_ = table_pass[0]
            player_pass_all = pass_.find_all('tr')


            for tr in player_pass_all:
                for td in tr.find_all('td', class_='sacks'):
                    for t in tr.find_all('td', class_='name'):
                        if t.text != 'TEAM':
                            player_pass_sacks.append(int(td.text[0:td.text.index('-')]))
                            player_pass_sacks_yds_lost.append(int(td.text[td.text.index('-')+1:]))
                for td in tr.find_all('td', class_='c-att'):
                    for t in tr.find_all('td', class_='name'):
                        if t.text != 'TEAM':
                            player_pass_catch.append(int(td.text[0:td.text.index('/')]))
                            player_pass_attempt.append(int(td.text[td.text.index('/')+1:]))
                for td in tr.find_all('td', class_='name'):
                    for t in tr.find_all('td', class_='name'):
                        for s in t.find_all('span', class_=''):
                            if t.text != 'TEAM':
                                player_pass_name.append(s.text)
                for td in tr.find_all('td', class_='yds'):
                    for t in tr.find_all('td', class_='name'):
                        if t.text != 'TEAM':
                            player_pass_yds.append(int(td.text))
                for td in tr.find_all('td', class_='avg'):
                    for t in tr.find_all('td', class_='name'):
                        if t.text != 'TEAM':
                            player_pass_avg.append(float(td.text))
                for td in tr.find_all('td', class_='td'):
                    for t in tr.find_all('td', class_='name'):
                        if t.text != 'TEAM':
                            player_pass_td.append(int(td.text))
                for td in tr.find_all('td', class_='int'):
                    for t in tr.find_all('td', class_='name'):
                        if t.text != 'TEAM':
                            player_pass_int.append(int(td.text))
                for td in tr.find_all('td', class_='rtg'):
                    for t in tr.find_all('td', class_='name'):
                        if t.text != 'TEAM':
                            player_pass_rtg.append(float(td.text))
                            player_match_id.append(index)
                #The code below cycles through the passers and gets their ESPN Player ID
                for a in tr.find_all('a', href=True):
                    player_id.append(a['href'].replace("http://www.espn.com/nfl/player/_/id/","")[0:a['href'].replace("http://www.espn.com/nfl/player/_/id/","").index('/')])

        except Exception as e:
            pass

With all of the data from above we now populate our `DataFrame` using specific headers (that's why we set the `headers_pass` variable above):

    player_passer_data = pd.DataFrame(np.column_stack((
    player_match_id,
    player_id,
    player_pass_name,
    player_pass_catch,
    player_pass_attempt,
    player_pass_yds,
    player_pass_avg,
    player_pass_td,
    player_pass_int,
    player_pass_sacks,
    player_pass_sacks_yds_lost,
    player_pass_rtg
    )), columns=headers_pass)

An issue that I ran into as I was playing with the generated `DataFrame` was that even though I had set the numbers generated in the `for` loop above to be of type `int` anytime I would do something like a `sum()` on the `DataFrame` the numbers would be concatenated as though they were `strings` (because they were!).

After much [Googling](https://www.google.com) I came across a [useful answer](http://stackoverflow.com/questions/15891038/pandas-change-data-type-of-columns) on [StackExchange](https://www.stackexchange.com) (where else would I find it, right?)

What it does is to set the data type of the columns from `string` to `int`

    player_passer_data[['TD', 'CATCHES', 'ATTEMPTS', 'YDS', 'INT', 'SACKS', 'YRDLSTSACKS','AVG','RTG']] = player_passer_data[['TD', 'CATCHES', 'ATTEMPTS', 'YDS', 'INT', 'SACKS', 'YRDLSTSACKS','AVG','RTG']].apply(pd.to_numeric)

OK, so I've got a `DataFrame` with passer data, I've got a `DataFrame` with away game data, now I need to join them. As expected, `pandas` has a way to join `DataFrame` data ... with the [join](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.join.html) method obviously!

I create a new `DataFrame` called `game_passer_data` which joins `player_passer_data` with `games_away` on their common key `match_id`. I then have to use `set_index` to make sure that the index stays set to `match_id` ... If I don't then the `index` is reset to an auto-incremented integer.

    game_passer_data = player_passer_data.join(gamesaway, on='match_id').set_index('match_id')

This is great, but now `game_passer_data` has all of these extra columns. Below is the result of running `game_passer_data.head()` from the terminal:

    id          Name  CATCHES  ATTEMPTS  YDS  AVG  TD  INT  SACKS    
   match_id
    400874518  2577417  Dak Prescott       22        30  292  9.7   0    0      4
    400874674  2577417  Dak Prescott       23        32  245  7.7   2    0      2
    400874733  2577417  Dak Prescott       18        27  247  9.1   3    1      2
    400874599  2577417  Dak Prescott       21        27  247  9.1   3    0      0
    400874599    12482  Mark Sanchez        1         1    8  8.0   0    0      0

               YRDLSTSACKS                        ...                            
   match_id                                      ...
    400874518           14                        ...
    400874674           11                        ...
    400874733           14                        ...
    400874599            0                        ...
    400874599            0                        ...

               ha_ind  match_date                  opp result          team_x    
   match_id
    400874518       @  2016-09-18  washington-redskins      W  Dallas Cowboys
    400874674       @  2016-10-02  san-francisco-49ers      W  Dallas Cowboys
    400874733       @  2016-10-16    green-bay-packers      W  Dallas Cowboys
    400874599       @  2016-11-06     cleveland-browns      W  Dallas Cowboys
    400874599       @  2016-11-06     cleveland-browns      W  Dallas Cowboys

              week_id prefix_1             prefix_2               team_y    
   match_id
    400874518       2      wsh  washington-redskins  Washington Redskins
    400874674       4       sf  san-francisco-49ers  San Francisco 49ers
    400874733       6       gb    green-bay-packers    Green Bay Packers
    400874599       9      cle     cleveland-browns     Cleveland Browns
    400874599       9      cle     cleveland-browns     Cleveland Browns

                                                             url
    match_id
    400874518  http://www.espn.com/nfl/team/_/name/wsh/washin...
    400874674  http://www.espn.com/nfl/team/_/name/sf/san-fra...
    400874733  http://www.espn.com/nfl/team/_/name/gb/green-b...
    400874599  http://www.espn.com/nfl/team/_/name/cle/clevel...
    400874599  http://www.espn.com/nfl/team/_/name/cle/clevel...

That is nice, but not exactly what I want. In order to remove the *extra* columns I use the `drop` method which takes 2 arguments:

-   what object to drop
-   an axis which determine what types of object to drop (0 = rows, 1 = columns):

Below, the object I define is a list of columns (figured that part all out on my own as the documentation didn't explicitly state I could use a list, but I figured, what's the worst that could happen?)

    game_passer_data = game_passer_data.drop(['opp', 'prefix_1', 'prefix_2', 'url'], 1)

Which gives me this:

    id          Name  CATCHES  ATTEMPTS  YDS  AVG  TD  INT  SACKS    
   match_id
    400874518  2577417  Dak Prescott       22        30  292  9.7   0    0      4
    400874674  2577417  Dak Prescott       23        32  245  7.7   2    0      2
    400874733  2577417  Dak Prescott       18        27  247  9.1   3    1      2
    400874599  2577417  Dak Prescott       21        27  247  9.1   3    0      0
    400874599    12482  Mark Sanchez        1         1    8  8.0   0    0      0

               YRDLSTSACKS    RTG ha_ind  match_date result          team_x    
   match_id
    400874518           14  103.8      @  2016-09-18      W  Dallas Cowboys
    400874674           11  114.7      @  2016-10-02      W  Dallas Cowboys
    400874733           14  117.4      @  2016-10-16      W  Dallas Cowboys
    400874599            0  141.8      @  2016-11-06      W  Dallas Cowboys
    400874599            0  100.0      @  2016-11-06      W  Dallas Cowboys

              week_id               team_y
    match_id
    400874518       2  Washington Redskins
    400874674       4  San Francisco 49ers
    400874733       6    Green Bay Packers
    400874599       9     Cleveland Browns
    400874599       9     Cleveland Browns

I finally have a `DataFrame` with the data I care about, **BUT** all of the column names are wonky!

This is easy enough to fix (and should have probably been fixed earlier with some of the objects I created only containing the necessary columns, but I can fix that later). By simply renaming the columns as below:

    game_passer_data.columns = ['id', 'Name', 'Catches', 'Attempts', 'YDS', 'Avg', 'TD', 'INT', 'Sacks', 'Yards_Lost_Sacks', 'Rating', 'HA_Ind', 'game_date', 'Result', 'Team', 'Week', 'Opponent']

I now get the data I want, with column names to match!

    id          Name  Catches  Attempts  YDS  Avg  TD  INT  Sacks    
   match_id
    400874518  2577417  Dak Prescott       22        30  292  9.7   0    0      4
    400874674  2577417  Dak Prescott       23        32  245  7.7   2    0      2
    400874733  2577417  Dak Prescott       18        27  247  9.1   3    1      2
    400874599  2577417  Dak Prescott       21        27  247  9.1   3    0      0
    400874599    12482  Mark Sanchez        1         1    8  8.0   0    0      0

               Yards_Lost_Sacks  Rating HA_Ind   game_date Result            Team    
   match_id
    400874518                14   103.8      @  2016-09-18      W  Dallas Cowboys
    400874674                11   114.7      @  2016-10-02      W  Dallas Cowboys
    400874733                14   117.4      @  2016-10-16      W  Dallas Cowboys
    400874599                 0   141.8      @  2016-11-06      W  Dallas Cowboys
    400874599                 0   100.0      @  2016-11-06      W  Dallas Cowboys

              Week             Opponent
    match_id
    400874518    2  Washington Redskins
    400874674    4  San Francisco 49ers
    400874733    6    Green Bay Packers
    400874599    9     Cleveland Browns
    400874599    9     Cleveland Browns

I've posted the code for all three parts to my [GitHub Repo](https://www.github.com/miloardot).

Work that I still need to do:

1.  Add code to get the home game data
2.  Add code to get data for the other position players
3.  Add code to get data for the defense

When I started this project on Wednesday I had only a bit of exposure to very basic aspects of `Python` and my background as a developer. I'm still a long way from considering myself proficient in `Python` but I know more now that I did 3 days ago and for that I'm pretty excited! It's also given my an ~~excuse~~ reason to write some stuff which is a nice side effect.
