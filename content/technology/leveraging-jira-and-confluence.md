Title: Leveraging Jira and Confluence
Date: 2022-12-31
Author: ryan
Tags: jira, confluence
Slug: leveraging-jira-and-confluence
Status: draft

At my day job we're pretty all in on Jira and Confluence. I've seen passing jabs at how bad Jira is and I'm convinced it's an issue of configuration, not one from a fundamental limitation or shortcoming for Jira. When used with developers in mind, it's actually pretty useful.

One of the features of Jira that may be underutilized is the powerful linking options that are available.

The other feature of Jira that I think may be under appreciated, or underutilized is its tight integration with Confluence (Atlassian's Wiki product).

In Jira you have 3 linking options:

1. Another Jira Issue
2. A confluence Page
3. A web link

Let's review each of these in order.

Why would you want to link Jira issues? A few possibilities:

1. Perhaps a bug was reported that is due to a recent feature that was pushed out. Ok, great, create a link between the two issues that shows they are related. Even better, you have the option to say, This issue caused that issue in the linking! Brilliant! Is there some part of the code base that always feels like it's causing problems. Now you have data to support your gut!
2. Or, maybe there are a few different projects: one for web development, one for ETL development, one for Report Development. Maybe the Web Development issue blocks the ETL issue which blocks the report issue. With issue linking, you can show this which helps to keep the ETL developer from starting their project before the web development is completed. It also keeps the report developer from starting on the report before the ETL issue is finished. Showing how things are related and dependent upon each other has a ton of power and eases communication about the relationship between issues.

When used consistently, Confluence super changes Jira. In one of our projects we have two issue types that have documentation as part of sub tasks that are created automatically. For new Reports the sub task is to create a documentation page (in confluence) which is then linked to the Jira issue. For report enhancements we have a sub task called Verify documentation. The Confluence page is linked to both of these issues. This allows you to 1, confirm you've written the documentation on a new report (both via the sub task and through the existence of the link in the origination issue) and for any enhancements that come in.

Now, jump over to confluence and you can see all of the Jira issues that have linked to this Confluence page! Holy moly. That means you can see the originating issue and all of the subsequent enhancements. We also link Bugs to the Pages so we can see how changes impacted the report negatively.

Web links are useful for two reasons:

1. Research
2. External web based ticketing systems

When you're working on an issue you'll come across a requirement you're not sure how to implement. How do I do this with c#, what's the syntax for this in JavaScript. With Web links you can link to Stock Overflow answers so you can refer back to them later while working on the issue. This is also helpful for your team as they may come across an issue and they'll either be able to ask you for the details from your solve OR they can look in Jira and find the issue and the link to get the solution you had.

The other thing that it allows is that if you're working with an external vendor that has a web based ticketing system you can link to the ticket from your issue so that you don't have to dig around in your email to find the ticket number ... and what was the link again? Also, if you're suddenly out your team can look at your comments and see the link to the external ticket system.

When used together Jira and Confluence can help lead to great communication between developers AND managers AND users.
