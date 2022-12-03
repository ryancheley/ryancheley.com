Title: Time to delivery for technical projects is 80% coordination and 20% problem solving
Date: 2022-12-03
Author: ryan
Tags: projects
Slug: time-to-delivery-for-technical-projects-is-80-coordination-and-20-problem-solving
Status: draft

Why does it take so long to deliver a project of a technical nature, especially when it seems that the solution is *so* easy? I've been thinking about this a lot lately, and I think it really comes down to one big thing. Coordination

Where I work, more often than not, we get a request from someone (a manager, director, VP, whatever) and they have a problem. The issue though, is that the problem that they have isn't what we (the technical team) gets. What we get is the solution that the non-technical person has come up with to solve the problem.

There are basically 2 ways to attack this request then:

1. Try and implement the solution that has been given to us
2. try to find out what the real problem is and solve that

Going through the motions of option 1 tend to seem easier, at least initially. The request may be well formed, or not (usually not) and the technical team will spend time working to implement the request, coming up with questions when necessary, and then finally, the request is fulfilled. Only it doesn't solve the actual problem. And it took 10 times as long to implement as anyone thought it should have. Why?

Essentially what we see is, Please create this technical thing (Web App, Report, automation, etc) that does thing X.

Thing X is poorly specified, so there are questions. Specifically, questions like, what do we do in this edge case here? What about this situation over there? But the technical team may not know what questions to ask initially about the request, and the requester may not have thought through the entire request. So there's a lot of time spent sending emails to the requester to get additional information. A lot of time waiting and/or following up with the requester because they are a *very busy person* who just wants the solution they asked for to be implemented. They don't have time to answer these questions!

What if instead of offering up a solution the requester indicated what problem was needing to be solved. What if instead of trying to make highly paid, highly creative technical types into code **monkeys** (but I don't like this word), we instead made them autonomous, problem solving entities that were able to use their experience and creativity to solve problems.

An example:

Insert web link to story about person trying to get the extension of a file by asking how to get the last 3 characters of a file

Another example:

A recently received request asked a technical team to take an excel file and 'add a person identifier to it'.

In this case the technical team could have written up the request (in JIRA), put the request into the queue of requests to be completed (in the next few weeks) OR call the requester and ask for more details.

The more details turned out to be that the requester was going to take the updated excel file with the person identifier, use that to get an attribute of the person from ANOTHER excel (and in this case the extra attribute would have been available to the technical team to add should that have been the request) and THEN ...

There was no 'and then'. the requester didn't know what problem was trying to be solved either. The requester then reviewed what the actual ask was with their boss and together we discovered that there was already a report that got them the information they needed.

With a simple phone call to talk through the problem we were able to discover that the problem was actually not even known to the requester, and once it was known, they were able to solve the problem on their own.

This story shouldn't be taken to be read as, "Goodness, requesters are dumb" ... quite the opposite actually. this story should be taken to be read as IF the technical team is involved in the problem solving then everyone wins because we can save time.

This is just one example of once we stop and ask the question "What problem are you trying to solve?" That we can see getting everyone involved to solve the problem is not only beneficial, but also efficient as we're not sitting waiting around for someone to answer questions to supper edge cases that may actually never come up OR because the problem wasn't really thought out to being with.
