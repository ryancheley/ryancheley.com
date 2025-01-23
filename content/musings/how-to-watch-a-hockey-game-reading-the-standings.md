Title: How to Watch a Hockey Game - Reading the Standings
Date: 2025-02-01
Author: ryan
Tags: hockey
Slug: how-to-watch-a-hockey-game-reading-the-standings
Series: How to Watch a Hockey Game
Status: published

This is the fourth part of my How to Watch a Hockey Game Series. You can catch up on previous articles [here]()

## Game Outcomes

In many North American sports when reading the standings there are typically just Wins (W), and losses (L).[ref]Football also has Ties (T) but they are exceedingly rare and are only ever displayed when the first Tie of the season occurs[/ref]

Hockey is a bit different. When you look at the standings for Hockey you'll see 4 headers:

W: Wins
L: Losses
OTL: Overtime Losses
SOL: Shootout Losses

# need to add a link

As discussed [earlier in this series](), if a game is tied at the end of regulation, a five-minute overtime period is played. If either team scores during this Overtime period then the winning team gets a Win, while the losing team gets an Overtime Loss (OTL).

If they're still tied at the end of Overtime then a Shootout is played. Once a winner is declared in the shootout they get the Win, while the losing team gets a Shootout Loss.

Because of this, values are assigned to each type of outcome:

| Outcome | Points |
| ---     |  ----  |
| Win     |   2    |
| Loss    |   0    |
| OTL     |   1    |
| SOL     |   1    |

This might best be shown with a concrete example.

## A Concrete Example

Let's say that the Coachella Valley Firebirds have played 39 games so far. They have won 21 games and lost 13 games. They've also played in 5 games that went into overtime and lost. One (1) in the Overtime period, and 4 in Shootouts. Their record would look like this:

Coachella Valley Firebirds: 21-13-1-4

Points Calculation:

- Wins: 21 × 2 = 42 points
- OTL: 1 × 1 = 1 point
- SOL: 4 × 1 = 4 points

Total: 42 + 1 + 4 = 47 points

The Firebirds play in the Pacific Division of the Western Conference, and the standings might look like this:

| Team | GP | W | L | OTL | SOL | PTS | PCT |
|------|----|----|---|-----|-----|-----|-----|
| Calgary | 41 | 27 | 13 | 1 | 0 | 55 | 0.671 |
| Coachella Valley | 39 | 21 | 13 | 1 | 4 | 47 | 0.603 |
| Colorado | 36 | 21 | 11 | 2 | 2 | 46 | 0.639 |
| Ontario | 37 | 22 | 13 | 1 | 1 | 46 | 0.622 |
| San Jose | 36 | 20 | 13 | 1 | 2 | 43 | 0.597 |
| Abbotsford | 37 | 20 | 15 | 1 | 1 | 42 | 0.568 |
| Tucson | 37 | 19 | 16 | 2 | 0 | 40 | 0.541 |
| Bakersfield | 35 | 16 | 14 | 4 | 1 | 37 | 0.529 |
| San Diego | 37 | 11 | 20 | 4 | 2 | 28 | 0.378 |
| Henderson | 39 | 12 | 25 | 2 | 0 | 26 | 0.333 |

Legend:
- GP: Games Played
- W: Wins
- L: Losses
- OTL: Overtime Losses
- SOL: Shootout Losses
- PTS: Points
- PCT: Points Percentage

## Winning Percent

There are 2 things to look at in the standings: (1) Total Points, and (2) Winning Percent.

The Total Points we've already spoken about so let's review winning percent.

The winning percent is calculated as the Total Points the team has divided by the total possible points that they could have gotten. The total possible points are calculated as the Games Played * 2 (that is, what are the total number of points that they would have if they won every game they played).

That is
```text
    Winning Percentage = Total Points ÷ (Games Played × 2)
```
For example, when looking at the table above, we see that the PCT column for the Firebirds is 0.603. This is calculated by the Points (47) divided by GP * 2 (39 * 2 = 78), that is 47 / 78 = 0.603.

The winning percentage allows ranking intra-season when teams haven't played the same number of games. After all games have been played, the rankings are determined by the total number of points a team has.[ref]Depending on the league there are tiebreakers, but that's outside the scope of this article[/ref]
