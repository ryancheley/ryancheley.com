Title: Remember the Colosseum!
Date: 2025-01-21
Author: ryan
Tags: documentation
Slug: remember-the-colosseum
Status: published

## The Roman Colosseum

After the fall of the Western Roman Empire in 497 CE the Colosseum fell into disrepair. Rightfully so! Who can worry about keeping up a giant megalith made by people centuries ago while you're just trying to figure out where your next meal may come from, or the ranging hordes of barbarians showing up and taking the food you did find!

However, during the medieval period, while Rome's population declined dramatically and many ancient structures fell into disrepair or were repurposed, the Colosseum remained a prominent landmark. There are stories that as the centuries progressed, the inhabitants of Rome forgot who built it.  While some fantastical legends did develop around it, the basic historical facts of its construction by the Flavian emperors and its original purpose remained part of common knowledge among educated Romans. For the non-educated Roman's there were lots of misconceptions about the colosseum.

The non-education Romans would have created stories[ref]such as it being a temple to the sun[/ref] about the large building. It was haunted. It was used for pagan rituals and no good Christian would go in. Folklore would rise up around it. As many of us have seen or experienced, in the absence of information, people will make it up.[ref]Brené Brown[/ref]

## The Story of the Legacy System

OK, but why is this important from a technology perspective?

Imagine if you will a large system, built 10 years ago, by a group of developers, that have all left the organization.

No one left knows how it works, or how to make changes to it. Most people don't even really know WHY it's there in the first place.

There isn't any documentation that can be referred to. Either because it wasn't ever created OR it was destroyed by Barbarians, I mean well meaning IT processes that 'clean up' unused files.

So what happens? The people remaining create stories about the system. Stories like the long timer 'Bob' that once caused the entire system to Crash and then an old copy backup copy had to be restored, and months worth of work was lost.

No one ever saw Bob after that. Now we're all afraid to touch any part of it. We mostly leave it alone, and it leaves us alone.

There are stories about another gray beard that actually built the system, but everyone assumes these are just fairy tales.

The stories tell of this Gray Beard busting out the entire system in a weekend, using nothing but a pin to move the electrons into the proper places to get all of the logic to work as expected.

Of course, no one really believes that story, but it encourages people to never want to have to make and changes to it.

The problem here is that it's running on a server with an OS that hasn't been supported for 7 years and there is security mandate to upgrade 'everything' to be on current software

No one wants to be in charge of this project, but someone is going to have to be in charge of it.

What do you do?

The story above isn't real, at least not for me. But it could be.

How many times have you gotten to a system that is old, no one around has any idea how it was built and people mostly just avoid it? Probably more than once.

But how can we avoid this fate? Do we just keep the old timers on until they (or the system) die?

There are options, and they are some of the easiest things to do, but many people don't like to do them.

What is the answer?

## Documentation

Documentation. No really, Documentation. Just write it down. For a new project especially. For an old project? Most definitely.

For new projects it's best to just get into the habit of writing good docs[ref]any docs in this case are good docs![/ref] as you go. If that's doc strings in a method, or a full fledged Knowledge Management System using a documentation framework like [diataxis](https://diataxis.fr/), then so be it.

But write it down. Write down the why's whenever you can. Use something like an [Architectural Decision Dsocument](https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions) to understand WHY you made a technical decision you made. Maybe it's not the best decision, but it's the best decision given a set of constraints.

For existing projects, it can be more challenging. It's possible that NO ONE that created the system is at the organization. It could be that NO ONE that asked for the system to be created is at the organization.

This leads to a bunch of problems to try to solve, but the journey of 1000 miles starts with a single step.

## How do you solve it?

Use the helpful [Awareness-Understanding Matrix](https://en.wikipedia.org/wiki/There_are_unknown_unknowns)[ref]This is in no way an endoresement of Donald Rumsfeld. He was a horrible person[/ref]

| | Aware | Unaware |
| --- | --- |--- |
| Understand | Known Knowns |  Unknowns Known  |
| Don't Understand | Known Unknowns| Unknown Unknowns|

That is,

* Known Knowns: Things we are aware of and understand
* Known Unknowns: Things we are aware of but don't understand
* Unknown Knowns: Things we are not aware of but do understand or know implicitly
* Unknown Unknowns: Things we are neither aware of nor understand

The Known Knowns may be very small, but it won't be empty.

The Unknown Unknowns might (will probably) be the largest.

The lack of knowledge here represents Risk[ref]Jacob Kaplan-Moss has a great series on [Risk](https://jacobian.org/series/risk/)[/ref]. Risk to your team, or to your organization. This Risk needs to be handled as much as possible.

Looking at a system with the Awareness-Understanding Matrix can help to risk it properly. Once you've properly risked the system, then you can start writing documentation.

The documentation can take the form of Architectural Review of System X (DRAFT)

The system does these things

1. Thing 1
2. Thing 2
3. Many other things that are still unknown

Sometimes just the act of writing these things out will help you in finding out what you know and what you don't know.

If you're using a documentation framework like [diataxis](https://diataxis.fr/) for this, you will want to keep your documentation parts separated (How To, Tutorials, Reference, Explanation). You may start righting a Reference article on the system and realize that you also need to have some, yet to be discovered, Explanation. The issue is that the Explanation still needs to be researched and written.

That's OK! One strategy I've encouraged, and use, is if I'm writing a Reference Article and need to link to a yet to be written Explanation article, is that I'll simply create the yet to be written Explanation article and tag it with `Explanation` and `Stub`. This frees me to come back to it later and fill in the details.

The other thing that will need to be done is to figure out who uses the system. Sometimes that's super easy, and sometimes, it's not.

Once you're able to determine who uses the system, you can talk with them about the system and then work to fill in the gaps from above.

Occassionally, you find out who everyone *thinks* is using the system, and discover that actually, it hasn't been used for 5 years because **reasons**, and they didn't know who to tell.

Now you can just retire the system using a decommissioning process. You have a technology decommissioning process, right? If you don't, it may be time to look into one!

## Back to the colosseum

The inhabitants of Rome never got to a spot where none of them knew why it was built, or who built it. Or even why. But what did happen is that the people with the knowledge may have been parts of groups that were marginalized and therefore their knowledge was discounted or ignored. Because the knowledge was a verbal knowledge and not written down. It was, to use a loaded term, tribal knowledge. EVERYONE just knows the obvious thing.

But the thing is ... obvious things are only obvious in the context they were created. It's obvious what Python is. I mean, why would someone use a snake to write code to get a computer to do a thing. EVERYONE knows I'm talking about the programming language Python ... until they don't.

Just write this shit down. Make sure everyone gets into the habit of documenting. Make the documentation public. And if it's not possible to make all of the documentation public, make as much public as possible.

For the parts that aren't public, make sure they are accessible by the people that will need access to it.

Really, documentation is a means to an end. Sometimes you won't need the documentation. You'll know how the thing works, and it has an obvious API or UI and people just "get it". This can lead to people not writing the documentation because we don't need it.

This is kind of like saying, I've used a seatbelt every day for 30 years and I've never needed it. I don't see why I need to wear it any more.

This might be fine until you're in an accident.

Not writing documentation is fine, until it's needed. And that's the worst time to discover that you need it.

Better to have it and not need it, than to need it and not have it.
