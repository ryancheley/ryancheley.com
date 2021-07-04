Title: Writing a Raffle Script
Date: 2020-06-29 05:24
Author: ryan
Tags: PyBites, Python
Slug: writing-a-raffle-script
Status: published

Due to the COVID Pandemic, many things are ... different. One thing that needed to be different this year was the way that students at my daughters middle school got to spend their ‘Hero Points’.

Hero Points are points earned for good behavior. In a typical year the students would get to spend them at the student store, but with all of the closures, this wasn’t possible. For the students in my daughter’s 8th grade this was a big deal as they’re going on to High School next year, so we can just roll them over to next year!

Instead of having the kids ‘spend’ their Hero Points the PTO offered up the solution of a raffle based on the number of Hero Points they had. But they weren’t sure how to do it.

I jumped at the chance to write something like this up (especially after all of my works on the PyBites [CodeChalleng.es](https://codechalleng.es "CodeChalleng.es") platform) and so my wife volunteered me 😁

In order to really get my head wrapped around the problem, I wanted to treat my solution like a real world analog. For example, in a real work raffle, when you get your tickets, there are two tickets with the same number. One that you get to hold onto, and one that goes into a bowl (or other vessel) that is randomly drawn from.

How many tickets?

Each student had some number of Hero Points. The PTO decided that 10 Hero Points would equal 1 Raffle ticket. Further, it was decided that we would ALWAYS round up. This means that 1 Hero Point would equal 1 Raffle Ticket, but that 9 Hero Points would also equal 1 Raffle Ticket.

## Create tickets

I decided to use a `namedtuple` to store the Raffle Tickets. Specifically, I store the student name, ticket numbers they drew, and the number of tickets they have

``` {.wp-block-code}
Raffle_Tickets = namedtuple('Raffle_Tickets', ['name', 'ticket_numbers', 'tickets'])
```

The list of student names and total Hero Points was stored in an Excel File (.xlsx) so I decided to use the Pandas Package to import it and manipulate it into a dataframe. The structure of the excel file is: Student Name, Grade, Available Points.

``` {.wp-block-code}
df = pd.read_excel (r'/Users/ryan/Documents/python-files/8th  Hero Points.xlsx')
```

After a bit of review it turned out that there were a couple of students with NEGATIVE Hero Points. I’m not really sure how that happened, but I was not properly accounting for that originally, so I had to update my dataframe.

The code below filters the dataframe to only return students with positive ‘Available Points’ and then reindex. Finally, it calculates the number of Raffle tickets by dividing by 10 and rounding up using Python’s `ceil` function. It puts all of this into a list called `tickets`. We append our `tickets` list to the original dataframe.

``` {.wp-block-code}
df = df[df['Available Points'] >0]
df.reset_index(inplace=True, drop=True)
tickets = []
for i in df['Available Points'] / 10:
    tickets.append(ceil(i))
df['Tickets'] = tickets
```

Our dataframe now looks like this: Student Name, Grade, Available Points, Tickets.

Next, we need to figure out the Raffle ticket numbers. To do that I count the total number of Tickets available. I’m also using some extra features of the range function which allows me to set the start number of the Raffle.[ref]Why am I doing this, versus just stating a `0`? Mostly because I wanted the Raffle Ticket numbers to look like *real* Raffle Ticket Numbers. How many times have you seen a raffle ticket with number 0 on it?[/ref]

``` {.wp-block-code}
total_number_of_tickets = sum(df['Tickets'])
ticket_number_start = 1000000
ticket_number_list = []
for i in range(ticket_number_start, ticket_number_start+total_number_of_tickets):
    ticket_number_list.append(i)
```

Once we have the list of ticket numbers I want to make a copy of it … remember there are two tickets, one that goes in the bowl and one that the student ‘gets’. Extending the metaphor of having two different, but related, tickets, I decided to use the `deepcopy` function on the `ticket_number_list` to create a list called `assigned_ticket_number_list`.

For more on deepcopy versus (shallow) copy [see the documentation](https://docs.python.org/3/library/copy.html "Deepcopy")

``` {.wp-block-code}
assigned_ticket_number_list = deepcopy(ticket_number_list)
```

Finally, I reindex the dataframe just to add a bit more randomness to the list

``` {.wp-block-code}
df = df.reindex(np.random.permutation(df.index))
```

## Assign Tickets

Next we’ll assign the tickets randomly to the students.

``` {.wp-block-code}
raffle_list = []
for student in range(df.shape[0]):
    student_ticket_list = []
    for i in range(df.loc[student].Tickets):
        assigned_ticket_number = randint(0, len(assigned_ticket_number_list)-1)
        student_ticket_list.append(assigned_ticket_number_list[assigned_ticket_number])
        assigned_ticket_number_list.pop(assigned_ticket_number)
    raffle_list.append(Raffle_Tickets(df.loc[student].Name, student_ticket_list, len(student_ticket_list)))
```

OK … the code above looks pretty dense, but basically all we’re doing is looping through the students to determine the number of tickets they each have. Once we have that we loop through the available ticket numbers and randomly assign it to the student. At the end we add a `namedtuple` object called `Raffle_Tickets` that we defined above to the raffle_list to store the student’s name, their ticket numbers, and the number of tickets that they received.

## Draw Tickets

Now we want to ‘draw’ the tickets from the ‘bowl’. We want to select 25 winners, but we also don’t want to have any student win more than once. Honestly, the ’25 winning tickets with 25 distinct winners’ was the hardest part to get through.

``` {.wp-block-code}
selected_tickets = []
for i in range(25):
    selected_ticket_number_index = randint(0, len(ticket_number_list) - 1)
    selected_ticket_number = ticket_number_list[selected_ticket_number_index]
    for r in raffle_list:
        if selected_ticket_number in r.ticket_numbers:
            ticket_number_list = [x for x in ticket_number_list if x not in r.ticket_numbers]
    selected_tickets.append(selected_ticket_number)
```

We see above that we’ll select 25 items from the ‘bowl’ of tickets. We select the tickets one at a time. For each ticket we determine what set of tickets that selected ticket is in. Once we know that, we then remove **all** tickets associated with that winning ticket so that we can guarantee 25 unique winners.

## Find the Winners

We now have 25 tickets with 25 winners. Now we just need to get their names!

``` {.wp-block-code}
winners_list=[]
for r in raffle_list:
    for t in r.ticket_numbers:
        student_winning_list = []
        if t in selected_tickets:
            student_winning_list.append(t)
            winners_list.append((Raffle_Tickets(r.name, student_winning_list, len(student_winning_list))))
```

Again, we construct a list of `namedtuple` `Raffle\_Tickets` only this time it’s just the winners.

## Output winners

Whew! Now that we have the results we want to write them to a file.

``` {.wp-block-code}
with open('/Users/ryan/PyBites/Raffle/winners_new.txt', 'w+') as f:
    for winner in winners_list:
        tickets = ticket_count(winner.name)
        percent_chance_of_winning = tickets / total_number_of_tickets * 100
        percent_chance_of_winning_string = "{:.2f}".format(percent_chance_of_winning)
        f.write(f'{winner.name} with winning ticket {winner.ticket_numbers[0]}. They had {tickets} tickets and a {percent_chance_of_winning_string}% chance of winning.\n')
```

One of the reasons that I stored the number of tickets above was so that we could see what the chance was of a student winning given the number of tickets they started with.

For each student we output to a line to a file with the student’s name, the winning tickets number, the number of tickets they started with and their chance of winning (the ratio of tickets the student had to the total number of starting tickets)

## Conclusion

This was a fun project for me because it was needed for a real world application, allowed me to use MANY of the concepts I learned at PyBites [CodeChalleng.es](https://codechalleng.es) AND helped my daughter’s school.
