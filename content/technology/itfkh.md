Title: ITFKH!!!
Date: 2018-11-09 19:33
Author: ryan
Tags: Hockey, Python, Raspberry Pi
Slug: itfkh
Status: published

It’s time for Kings Hockey! A couple of years ago Emily and I I decided to be Hockey fans. This hasn’t really meant anything except that we picked a team (the Kings) and ‘rooted’ for them (i.e. talked sh\*t\* to our hockey friends), looked up their position in the standings, and basically said, “Umm ... yeah, we’re hockey fans.”

When the 2018 baseball season ended, and with the lack of interest in the NFL (or the NBA) Emily and I decided to actually focus on the NHL. Step 1 in becoming a Kings fan is watching the games. To that end we got a subscription to NHL Center Ice and have committed to watching the games.

Step 2 is getting notified of when the games are on. To accomplish this I added the games to our family calendar, and decided to use what I learned writing my [ITFDB](/itfdb/) program and write one for the Kings.

For the Dodgers I had to create a CSV file and read it’s contents. Fortunately, the NHL as a sweet API that I could use. This also gave me an opportunity to use an API for the first time!

The API is relatively straight forward and has some really good documentation so using it wasn’t too challenging.

    import requests
    from sense_hat import SenseHat
    from datetime import datetime
    import pytz
    from dateutil.relativedelta import relativedelta



    def main(team_id):
        sense = SenseHat()

        local_tz = pytz.timezone('America/Los_Angeles')
        utc_now = pytz.utc.localize(datetime.utcnow())
        now = utc_now.astimezone(local_tz)

        url = 'https://statsapi.web.nhl.com/api/v1/schedule?teamId={}'.format(team_id)
        r = requests.get(url)

        total_games = r.json().get('totalGames')

        for i in range(total_games):
            game_time = (r.json().get('dates')[i].get('games')[0].get('gameDate'))
            away_team = (r.json().get('dates')[i].get('games')[0].get('teams').get('away').get('team').get('name'))
            home_team = (r.json().get('dates')[i].get('games')[0].get('teams').get('home').get('team').get('name'))
            away_team_id = (r.json().get('dates')[i].get('games')[0].get('teams').get('away').get('team').get('id'))
            home_team_id = (r.json().get('dates')[i].get('games')[0].get('teams').get('home').get('team').get('id'))
            game_time = datetime.strptime(game_time, '%Y-%m-%dT%H:%M:%SZ').replace(tzinfo=pytz.utc).astimezone(local_tz)
            minute_diff = relativedelta(now, game_time).minutes
            hour_diff = relativedelta(now, game_time).hours
            day_diff = relativedelta(now, game_time).days
            month_diff = relativedelta(now, game_time).months
            game_time_hour = str(game_time.hour)
            game_time_minute = '0'+str(game_time.minute)
            game_time = game_time_hour+":"+game_time_minute[-2:]
            away_record = return_record(away_team_id)
            home_record = return_record(home_team_id)        
            if month_diff == 0 and day_diff == 0 and hour_diff == 0 and 0 >= minute_diff >= -10:
                if home_team_id == team_id:
                    msg = 'The {} ({}) will be playing the {} ({}) at {}'.format(home_team, home_record, away_team, away_record ,game_time)
                else:
                    msg = 'The {} ({}) will be playing at the {} ({}) at {}'.format(home_team, home_record, away_team, away_record ,game_time)
                sense.show_message(msg, scroll_speed=0.05)


    def return_record(team_id):
        standings_url = 'https://statsapi.web.nhl.com/api/v1/teams/{}/stats'.format(team_id)
        r = requests.get(standings_url)
        wins = (r.json().get('stats')[0].get('splits')[0].get('stat').get('wins'))
        losses = (r.json().get('stats')[0].get('splits')[0].get('stat').get('losses'))
        otl = (r.json().get('stats')[0].get('splits')[0].get('stat').get('ot'))
        record = str(wins)+'-'+str(losses)+'-'+str(otl)
        return record


    if __name__ == '__main__':
        main(26) # This is the code for the LA Kings; the ID can be found here: https://statsapi.web.nhl.com/api/v1/teams/

The part that was the most interesting for me was getting the opponent name and then the record for both the opponent and the Kings. Since this is live data it allows the records to be updated which I couldn’t do (easily) with the Dodgers programs (hey MLB ... anytime you want to have a free API I’m ready!).

Anyway, it was super fun and on November 6 I had the opportunity to actually see it work:

`<iframe src="https://www.youtube.com/embed/AzdLSrA8wvU" width="560" height="315" frameborder="0" allowfullscreen="allowfullscreen">`{=html}`</iframe>`{=html}

I really like doing fun little projects like this.
