Title: Making the Right Choice, or How I Learned to Live with Limiting My Own Technical Debt and Just Be Happy
Date: 2017-08-03 19:00
Author: ryan
Category: Productivity
Tags: Design Decision, SQL, Technical Debt
Slug: making-the-right-choice-or-how-i-learned-to-live-with-limiting-my-own-technical-debt-and-just-be-happy
Status: published

One of the things that comes up in my day job is trying to make sure that reports that we create are correct, not only from a data perspective, but from an architectural perspective. There are hundreds of legacy reports with legacy SQL code that has been written by 10’s of developers (some actual developers and some not so actual developers) over the last 10+ years.

Today a request came in to update a productivity report to include a new user. The request included their user ID from the application where their productivity is being tracked from.

This request looked exactly like another report and request that I’ve seen that involved running productivity from the same system with the same aspects (authorizations work).

I immediately thought that the reports were the same and set out to add the user id to a table `ReferralsTeam` which includes fields `UserID` and `USerName`.

I also thought that documenting what needed to be done for this would be a good thing to be done.

I documented the fix and linked the `Confluece` article to the `JIRA` issue and then I realized my mistake. This wasn’t the same report. It wasn’t even the same department!

OK, so two things:

1.  There are two reports that do **EXCATLY** the same thing for two different departments
2.  The report for the other department has user ids hard coded in the `SQL`

What to do?

The easy way is to just update the stored procedure with the hard coded user ids with the new one and call it a day

The **right** way:

1.  Update the table `ReferralsTeam` to have a new column called department ... or better yet create a second table called `Departments` with fields `DepartmentID` and `DepartmentName` and add the `DepartmentID` to the `ReferralsTeam` table.
2.  Populate the new column with the correct data for the current team that has records in it
3.  Update the the various stored procedures that use the `ReferralsTeam` table in them to include a parameter that is used to filter the new column that was added to keep the data consistent
4.  Add the User IDs from the report that has the user IDs hard coded, i.e. the **new** department
5.  Update the report that uses the hard coded user ids to use the dynamic stored procedure
6.  Verify the results
7.  Build a user interface to allow the data to be updated outside of `SQL Server Management Studio`
8.  Give access to that user interface to the Department Managers so they can manage it on their own

So, which one would you do?

In this case, I updated the hard coded stored procedure to include the new user id to get that part of the request done. This helps satisfy the requester and allows them to have the minimum amount of down time.

I then also create a new `JIRA` issue so that we can look at doing steps 1 - 6 above and assigned to the report developer. Steps 7 & 8 are in a separate `JIRA` issue that is assigned to the Web Developers.

Doing things the right way will sometimes take longer to implement in the short run, but in the long run we’ve removed the need for Managers in these departments to ask to have the reports updated, we prevent bad/stale filters from being used, and we can eliminate a duplicative report!

One interesting note, the reason I caught the duplication was because of a project that we’ve been working on to document all of the hundreds of reports we have. I searched `Confluence` for the report name and it’s recipients were unexpected for me. That lead me to question all I had done and really evaluate the best course of action. While I kind of went out of order (and this is why I started documented one process that I didn’t mean to) I was still able to catch my mistake and rectify it.

Documentation is a pain in the ass in the moment, but holy crap it can really pay off in unexpected ways in the long run.
