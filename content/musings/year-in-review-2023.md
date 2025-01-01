Title: Year in Review 2023
Date: 2023-12-31
Author: ryan
Tags:
Slug: year-in-review-2023
Series: Years in Review
Status: published

I've never done a year in review, but this seems like a good a time as any, right? I had a rough outline, but after reading the great Year in Review from [Tim Schilliing](https://www.better-simple.com/personal/2023/12/30/my-year-in-review/), [Paolo Melichore](https://www.paulox.net/2023/12/31/my-2023-in-review/), and [Velda Kiara](https://dev.to/veldakiara/djangoconus-2023-a-wish-fulfilled-2mmc), I was inspired to **actually** finish mine.

# Professional

In the moment it can feel like I don't really get anything done at work. Looking at my [time tracking stats](https://track.toggl.com/shared-report/9091b753451ad2edafbb36f18be33d82/summary/period/last12Months), I do spend A LOT of my time in meetings (nearly 40%) and administration (almost 45%) which is expected for someone in management I suppose, but I really do miss getting to write code more often.

That being said I was able to complete some pretty significant projects at work with the help of my team that I'm really proud of.

## Migrations

Change is hard, and we underwent a few BIG technology changes that have gone really well.

The first big change implemented was to migrate from a few Atlassian products ([JIRA](https://en.wikipedia.org/wiki/Jira_(software)) and [Confluence](https://en.wikipedia.org/wiki/Confluence_(software))) to [YouTrack](https://en.wikipedia.org/wiki/YouTrack). I know there are lots of people out there that HATE JIRA, but I loved it and my team liked it. I think that a big reason for that is when JIRA wasn't doing what we needed it to do, I was able to make changes to it. We didn't have to pass it through some change control committee, or get buy in from some high level manager. We just made it work for us ... and it really did work well for us.

The reason we had to migrate from these products was that Atlassian announced in February of 2021 that they would end-of-life the server versions at the end of February 2024. I looked to see if we could migrate to one of their data center versions, but because I'm in Health Care any solution 'in the cloud' needs to be HIPAA compliant. While Atlassian does offer [HIPAA](https://en.wikipedia.org/wiki/Health_Insurance_Portability_and_Accountability_Act) compliant versions, you need to have 500+ users for that solution. My organization has 50.

I spent two years trying to figure out how we could keep JRIA and/or to find something that could replace what we had in JIRA and the best solution I could find was JetBrains' YouTrack.

We've been on YouTrack since the end of May and while there are still some features that I miss (support for [Mermaid Diagrams](https://mermaid.js.org/), ability to embed the content of one Confluence Article into another Article, automatic linking between JIRA issues and Confluence Articles) overall the workflow parts of YouTrack for issue tracking are much better than JIRA. Easier to set up, easier to maintain.

Another change that we made was changing our [Version Control System](https://en.wikipedia.org/wiki/Version_control) from [Subversion](https://en.wikipedia.org/wiki/Apache_Subversion) to [git](https://en.wikipedia.org/wiki/Git), hosted on Azure DevOps. This involved all three of the teams in my department and proceeded in a staged approach over the course of about 3 months. I also helped another department migrate from Subversion to git.

The biggest challenge was the [SSIS](https://en.wikipedia.org/wiki/SQL_Server_Integration_Services) packages used in our [ETL](https://en.wikipedia.org/wiki/Extract,_transform,_load) processes, and the database objects.

The SSIS packages took 3 attempts before it stuck, but the ETL devs were positive with each unsuccessful attempt and we finally got over the hump in early December.

The Database objects are unfortunately still in Subversion. This is a limitation of our current tech stack. Migrating to git requires that each developer have their own version of the database but we don't. Honestly the way we have it set up now is something I'd really like to change, but that's a story for a different time.

In all we migrated 25 repositories from Subversion. There is still more work to do with the Web Developers to update our CICD process to fully leverage Azure DevOps, but small steps can make for big changes over time. No need to rush if we have a working CICD system (even if it's kind of Frankensteined together at this point).[ref]Our current stack involves commits to Azure DevOps which is picked up by TeamCity and then deployed using  Octopus Deploy[/ref]

With this migration to git we were also able to integrate our issue tracking system (YouTrack) with our VCS. It's nice to see commits automatically 'connected' to the issues in YouTrack.

Another thing that I've been able to work on is getting more and more Python enabled for various projects. We have a Django App that we use to manage 'administrative' tables in our MS SQL database, and we've been able to integrate Python in some of our SSIS packages for ETL.

## Speaking

One of the goals that I had from my last annual review was to engage in two public speaking activities. While I give lots of presentations at work, they're all via Zoom so the idea of getting up in a room full of strangers and talking was both exciting and terrifying.

The first conference I spoke at was the KLAS Points of Light conference in May in Salt Lake City (only about a week after PyCon US). The talk was limited to 10 minutes and I had 2 co-speakers so I was limited to about 3 minutes of talking time (and if I said I spoke for 90 seconds that would be pretty generous). That being said, I did get up on stage and spoke to a room full of about 200 strangers (and nearly threw up!)

The absolute highlight of my speaking engagements this year was speaking at Django Con (which I wrote about [here](https://www.ryancheley.com/2023/10/24/djangocon-us-2023/) and [here](https://www.ryancheley.com/2023/12/15/so-you-want-to-give-a-talk-at-a-conference/)). I won't write more about it, but I had such a great time giving that talk!

## Certifications

I was able to achieve a couple of certifications this year. The first was the Google Cloud Platform Cloud Architect Certificate. I wrote about the experience [here](https://www.ryancheley.com/2023/04/01/gcp-cloud-architect-exam-experience/).

Another certification I achieved was the Certified EDI Academy Professional. Initially I did this mostly because the cost of the classes to work on the certificate for 2 participants versus 3 participants was only $100 extra and there were 2 people in my department that had asked about working on the certification. Since my department is in charge of EDI 'stuff' and I'm in charge of the department it kind of made sense that I should get it too.

While I didn't think it would be super beneficial and did it mostly *just because* I have been surprised at how useful it's ended up being. Seeing what's possible with EDI in Healthcare has allowed me to work with the EDI Analysts in my department more effectively AND has helped us all to better identify opportunities for automation

## Misc

Above I lamented the lack of time to program above, but one thing I was able to work on was a refactor of an Airflow DAG from 2000+ lines down to 150 lines. This was thanks to the DjangoCon Tutorial [Django ❤️ Airflow](https://2023.djangocon.us/tutorials/django-3-airflow/) lead by [Sheena O'Connell](https://fosstodon.org/@sheena).

This is also the first year since the start of the pandemic that I've gone into the office on a (mostly) regular basis. While it's mostly like working from my home office (lots of Zoom meetings) it is nice to have a different bit of scenery (the new arena where hockey is played is visible from my desk when I look out the window).

In November I also got my first promotion in 7 years which was nice. I went from being the Regional Director to Senior Regional Director.

Finally something I was really excited and proud about was the rating my management team and I got for Employee Satisfaction. This was the first full year that I had two people other than me in the management team and I think that really helped. The satisfaction rating came back at 95%, the highest my department has ever gotten.

# Personal

## Health

At the end of last year I completed the Running Challenge which lead to me participating in my first organized run (the Panther 5K) since 2018[ref]That year I ran the LA Marathon in March, and in July I tore a muscle in my left hamstring[/ref]. I had hoped that this would get me back into running and that by the end of 2023 I would have been able to run a half marathon.

These hopes were dashed in April when I contracted COVID (for the second time since the start of the pandemic) and I wasn't back to feeling like myself until late May. Now, in most places of the country late May might be a swell time to start running, but in the Coachella Valley it's already push triple digit highs so I had a hard time getting motivated to start running again when it was that hot.

I started the Running Challenge again this year, but 24 days into it I got a really bad cold that basically is only now (nearly 2 weeks later) truly disappearing. I haven't run in those 2 weeks, but am looking forward to starting [rucking](https://www.901pt.com/post/rucking-what-it-is-benefits-how-to-do-it) and then running again in 2024.

## Django

I mentioned above that I spoke at DjangoCon US this year in Durham, but before the conference started I got to see my youngest step brother and his wife at their (new to me) house[ref]They've been in the house for almost 9 years![/ref]. It was a great way to start an amazing week in Durham which is one of the more walkable cities I've been to.

Another bonus was a chance encounter with [Ronard Luna](https://www.linkedin.com/in/ronardluna/) (whom I met at DCUS 2022 in San Diego) and some of his Caktus colleagues after day one of the conference. We went and got (really good) Thai that night, had some great conversations and I got to meet some more amazing Django people.

Towards the end of the conference [Jay Miller](https://mastodon.social/@kjaymiller) interviewed me about my talk and that was super awesome. I was nervous at first, but Jay (and [Dawn](https://mastodon.online/@BajoranEngineer)) did a great job of making me feel at ease 😁

I also spent time working with [Jeff Triplett](https://mastodon.social/@webology) and [Maksudul Haque](https://github.com/saadmk11) on [DjangoPackages](https://djangopackages.org) which has been fun and a great learning experience. I'm looking forward to continuing that work next year!

Finally, towards the end of the year I interviewed and was accepted to be one of the [Djangonaut.Space](https://djangonaut.space/) Navigators. I'm really looking forward to working with the Djangonauts on my team, as well as my Captain Nishant Aggarwal.

## Reading

I had a goal of increasing the diversity (both in style and authors) that I was going to read this year[ref]I read mostly Sci Fi written by people that mostly look like me[/ref]. To this end my daughter Abby helped me by putting together a list of books by Author's to get me out of my reading rut.

I kind of fell off the reading wagon in the last quarter of the year, but I was able to read some really good books that I wouldn't have found otherwise:

- American Gods: Neil Gaiman
- Scythe: Neal Shusterman
- Renegads: Marissa Meyer
- Don't Read the Comments: Eric Smith
- An Absolutely Remarkable Thing: Hank Green
- The Thousandth Floor: Katherine McGee
- Legendborn: Tracy Deonn
- Mistborn: Brandon Sanderson
- War Girls: Tochi Onyebuchi
- The Poppy War: RF Kuang

I also read a few books in the Rise of Mankind Series by John Walker[ref]These aren't particular good or well written, but I was in between books and they were on my kindle so 🤷🏼‍♂️[/ref]

- Raid
- Conflict

## Writing

I only wrote [nine articles this year](https://search-ryancheley.vercel.app/pelican?sql=select+summary+as+%27Summary%27%2C+url+as+%27URL%27%2C+published_date+as+%27Published+Data%27+%0D%0Afrom+content+%0D%0Awhere+published_date+%3E%3D+%272023-01-01%27+%0D%0Aand+category+%21%3D+%27pages%27%0D%0Aorder+by+published_date) (including this one). It sure feels like more, but in looking back I didn't write my first post until April, and then not again until July. It was really in the last 3 months (since DjangoCon) that I really started to write more with 2 in October and November and three in December.

I'm looking forward to writing more in 2024 with the goal of one article per month. I've started already with trying to write up one [TIL](https://github.com/ryancheley/til) a day. This is part of a large theme[ref]more on that in the next article 😁[/ref]

## Hockey

On December 18, 2022 AHL Hockey made its way to my home town. The best part is that the arena they play in is only 10 minutes from my house so I went to *a lot* of hockey games.

So far this season isn't going like I had hoped, but a few highlights from last season were:

* Getting to see a triple overtime game against the Calgary Wranglers that ended with the Firebirds winning
* A game 7 of the Calder Cup finals going to over time

While the 3OT game ended with the good guys winning, the game 7 OT ended with them losing. It was heart breaking, and I wrote about it [here](https://www.ryancheley.com/2023/07/01/firebirds-inaugural-season/), so I won't go over it again. That being said, even though they lost, the fact that I got to go to a Game 7 for a championship was already mind blowing. The fact that it went into overtime was more so. I did a bit a research and it was the first Game 7 OT championship game in either the AHL or NHL since the early 50s, so it was kind of neat to be a part of history.

I've gotten so into the AHL that I've written [a silly scraper](https://github.com/ryancheley/ahl) that dumps data into a [datasette](https://datasette.io) [instance on vercel](https://ahl-data.vercel.app).

At the time of this writing the Firebirds are [9 points behind the pace they had last year](https://ahl-data.vercel.app/games?sql=with+data+%28TheYear%2C+W%2C+L%2C+OTL%2C+SOL%29%0D%0Aas+%28%0D%0A%0D%0Aselect+strftime%28%27%25Y%27%2C+game_date%29%0D%0A%2C+sum%28case%0D%0A++when+home_team+%3D+%3Ateam_name+and+home_team_score+%3E+away_team_score+then+1%0D%0A++when+away_team+%3D+%3Ateam_name+and+home_team_score+%3C+away_team_score+then+1%0D%0A++else+0%0D%0Aend%29+as+%27W%27%0D%0A%2C+sum%28case%0D%0A++when+home_team+%3D+%3Ateam_name+and+home_team_score+%3C+away_team_score+and+game_status+%3D+%27Final%27+then+1%0D%0A++when+away_team+%3D+%3Ateam_name+and+home_team_score+%3E+away_team_score+and+game_status+%3D+%27Final%27then+1%0D%0A++else+0%0D%0Aend%29+as+%27L%27%0D%0A%2C+sum%28case%0D%0A++when+home_team+%3D+%3Ateam_name+and+home_team_score+%3C+away_team_score+and+game_status+%3D+%27Final+OT%27+then+1%0D%0A++when+away_team+%3D+%3Ateam_name+and+home_team_score+%3E+away_team_score+and+game_status+%3D+%27Final+OT%27then+1%0D%0A++else+0%0D%0Aend%29+as+%27OTL%27%0D%0A%2C+sum%28case%0D%0A++when+home_team+%3D+%3Ateam_name+and+home_team_score+%3C+away_team_score+and+game_status+%3D+%27Final+SO%27+then+1%0D%0A++when+away_team+%3D+%3Ateam_name+and+home_team_score+%3E+away_team_score+and+game_status+%3D+%27Final+SO%27then+1%0D%0A++else+0%0D%0Aend%29+as+%27SOL%27%0D%0Afrom%0D%0A++games%0D%0Awhere+%28home_team+%3D+%3Ateam_name%0D%0A+++++++or+away_team+%3D+%3Ateam_name%29%0D%0Aand+++strftime%28%27%25m-%25d%27%2C+game_date%29+%3E%3D+%2710-01%27%0D%0A++AND+game_date+%3C%3D+strftime%28%27%25Y%27%2C+game_date%29+%7C%7C+%27-%27+%7C%7C+strftime%28%27%25m-%25d%27%2C+%27now%27%29%0D%0A++group+by+strftime%28%27%25Y%27%2C+game_date%29%0D%0A%29%0D%0Aselect+*%0D%0A%2C+2+*+W+%2B+OTL+%2B+SOL+as+%27Points%27%0D%0Afrom+data%0D%0Aorder+by+TheYear&team_name=Coachella+Valley+Firebirds&_hide_sql=1).

With that, it's still pretty awesome that I get to watch hockey live a couple of times a week and don't have to travel hours to do it.

# House

When my wife Emily and I bought our house in 2009 we were surprised that it was on septic and not connected to the sewer. But then we learned that the unincorporated part of the county we live in that's not unusual. Every few years I call one of the [local plumbing companies](https://hammerplumbing.com/) that is highly regarded to empty my septic tank.

This was the year to have the tank emptied and when they came out to empty it, we discovered that the tank was collapsing on itself and would need to be replaced.

Now, this is not an inexpensive expense[ref]Average costs is about $15,000[/ref] but also not totally unexpected. What was unexpected was to find out that because our house was within 200 feet of the sewer line we were REQUIRED to connect to the sewer.

After contacting 12 approved contractors we were able to get one under contract and they got us connected to the sewer. It cost WAAAAAY more than I think anything should[ref]Close to $30,000[/ref], but it's done now so one less thing to worry about going forward

But the silver lining in that is I finally felt comfortable getting a lemon tree in my front yard and it brings me lots of joy. [ref]When Emily and I were looking to buy a house we only had three requirements: (1) It couldn't be behind a gate; (2) it couldn't have a pool; (3) it had to have a citrus tree, preferably lemon. We were able to get 2 of the three when we bought the house and it only took 13 years to get the citrus tree![/ref]

# Family

This fall my daughter Abby started her Senior year in High School. This is a mind blowing stage in life. It means that this time next year Emily and I will officially be empty nesters.

In preparation for the transition to College we have done a lot of College tours. These have mostly been short weekend trips, but it's been nice to get out there and visit new / different places.

Before the pandemic my family and I would take a [stereotypical American style family road trip](https://www.imdb.com/title/tt0085995/). We haven't done it since, but we were hoping to do something big this summer.

Those plans were derailed when the sewer bill came in, but the college tours, and a nice long weekend trip to [Julian](https://visitjulian.com/) made up for the lack of a BIG trip.

I mentioned above the Hockey games I've been able to see at Acrisure Arena, but one of the extra benefits of having an arena where they play hockey is that they will also play music. I was only able to go to one concert ([Paramore](https://en.wikipedia.org/wiki/Paramore) with Abby), but Emily and Abby were able to see several shows including [Shania Twain](https://www.shaniatwain.com/#/), [Lizzo](https://www.lizzomusic.com/), and [Pentatonix](https://www.ptxofficial.com/).

We also live relatively close to LA so we were able to see a couple of events at the Staples Center (I refuse to call it by it's new name) including [SZA](https://www.szasos.com/tour/) (all three of us plus a friend of Abby's) and a [Kings game](https://www.nhl.com/avalanche/news/colorado-avalanche-los-angeles-kings-game-recap-december-3-x2816) (just Emily and me).

Abby was also able to see the last show of [Taylor Swift's Eras tour](https://www.taylorswift.com/tour-us/) at [SoFi Stadium](https://en.wikipedia.org/wiki/SoFi_Stadium) which was a bit stressful as she did it with a group of friends and an adult cousin of one of those friends (that we didn't know) but she had a great time and had a smile as big as any I've seen on her in a while for a few days after.

Emily and I also went down to the Palm Springs Pride parade and got to see [10,000 Maniacs](https://maniacs.com/) with their new lead singer ([Leigh Nash](https://en.wikipedia.org/wiki/Leigh_Nash) from [Six Pence None the Richer](https://en.wikipedia.org/wiki/Sixpence_None_the_Richer))

We have also really started to take advantage of the space in our back yard as a family. As a 15 year work anniversary gift I received a projector TV that we've set up outside. We also got a fire pit to keep us warm in the *frigid* Desert Winter Nights (I mean, it gets down to a low of like 50 by the time I go back inside 🥶) and reminds me of [this meme](https://imgur.com/tczZ7ez).

# Tropical Storm Hillary

I grew up in the Coachella Valley, and except for a 10 year period (mostly in my 20s) I've lived here my entire life. I've seen [Haboobs](https://en.wikipedia.org/wiki/Haboob), felt Earthquakes, seen smoke from nearby Wild Fires, and a couple of pretty bad rain storms (like the [Valentine's Day massacre](https://www.desertsun.com/picture-gallery/weather/2020/02/13/2019-valentines-day-storm-and-its-aftermath-across-region/4747997002/), and the [Storm Cell that wouldn't move](https://kesq.com/news/2014/09/11/la-quinta-cleanup-from-700-year-storm/)) ... but I NEVER thought I'd experience a Tropical Storm (which was very nearly a Hurricane) but this year we did.

It was a stressful day but at the end of it we can out unscathed. We were fortunate that we didn't have any property damage, but others weren't. There are still [areas of the Valley that are trying to rebuild after the flooding](https://www.desertsun.com/story/news/2023/09/03/tropical-storm-hilary-destroyed-one-palm-springs-area-neighborhood-heres-why/70733017007/) that the storm brought.

# Conclusion

When I started writing this I didn't think i I'd have *that* much to write, but looking back  I see that I did!

I'm glad I did this and hope that future me will find some benefit from it. Hopefully 2024 me won't procrastinate writing this until the very last day ... but he probably will.

That's just the nature of these things, right?
