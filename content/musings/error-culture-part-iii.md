Title: Error Culture Part III
Date: 2023-11-14
Author: ryan
Tags: culture, programming
Slug: error-culture-part-iii
Series: Error Culture
Status: published

# How can I tell if I'm in an error culture?

In part 1 I spoke about the idea of [Error Culture](https://www.ryancheley.com/2023/10/29/error-culture/). In that post I define what error culture.

In part 2 I spoke when [Error Culture](https://www.ryancheley.com/2023/11/09/error-culture-part-ii/) starts. This time I'll talk about how you can tell if you're living in an Error Culture, and what you can do about it.

Below are a couple of tell-tale signs I've found to determine if you're living in an error culture.

## Email Rules

You start your day and fire up your email client. As the application opens up you see the number of unread message go from 500 down to 20. You think back to a time when you would open your email client and have to trod through ALL 500 of those emails. Now though ... now you've outsmarted the email system by implementing several rules to ignore or hide those pesky emails that don't seem to mean anything.

## Instinct to just delete emails

Maybe you don't know about the amazing opportunities that email client rules offer, so you start going through your emails. You delete the ones you **know** aren't useful or don't mean anything.

Or maybe you do know about rules and of the remaining 20 you notice a few new emails that you don't need to act on. Your first instinct is to delete them, but you remember you are a smart email user and create a new rule to get rid of those emails as well.

## Why do I get this email anyway?

If you use rules, you recall a time before you had them. A time when you would methodically read each email and write down a quick note to ask a co-worker, or your boss at your next one on one. But when you brought up the alerts you had one of two reactions:

- Oh those ... yeah, you can just delete them. They don't mean anything
- Ugh ... how do you **not** know what that is for? Fine, let me explain it to you ... **again**

The first item is definitely error culture. The second response could be error culture if the person you've asked is just so overwhelmed with all of the alerts ... OR it could just be a toxic culture. If it's a toxic culture, I'm sorry, but this post might not be helpful in solving that problem.

If you're not in the second situation you may (rightfully) ask

> why do we get it if we can just delete it?

And if the answer is 🤷‍♂️ then you might be in an error culture.

In general, if no one knows WHY we're getting an email and there is no actionable direction, you might be in an error culture.

## Email Alerts

Ask yourself, your peers, and your boss this question

> Is this alert we are getting actually important?

If the answer is No, then delete the mechanism that generates the error. Don't just create a rule to delete the alert.

If the answer is Yes, then ask

> Is the alert you are getting actionable?

If the answer is No then update the alert to be actionable. This can be done by

1. Including steps to resolution or documentation link for resolving the error
2. Update the alert to indicate it’s importance
3. Update the alert to go to the correct people

If the answer is Yes then

1. Make sure the error indicates what the fix needs to be
2. Make sure the error indicates why it’s important, or a link to documentation that explains it
3. Make sure the right people are being notified

Point three here is really important. To determine if the correct people are being notified ask this questions of EVERYONE that receives the alert:

> Are you the correct person to do something to fix the error

If the answer is No then getting removed from the email is the best course of action.

Of course, it could be that no one ever told you why you were getting the alert so the decision to remove people from alerts may need to be a management level decision, but it can at least start the conversation.

If the answer is Yes then do you (i.e. the person being asked) know what to do to fix the error

Again, with a simple yes or no response, you have two options:

Yes: Does the error indicate what the fix needs to be or where to go to find out?
No: Work to update the error to make it actionable

This can help to get the right people getting the alerts.

Below is a flow chart to help make alerts better

![Diagram of how to make alerts better]({static}/images/alert_flow_diagram.png)

None of this is easy to change. You may have managers that don't answer your questions when asking about if someone should receive an alert.

You may not get feedback from your peers, or manager about cleaning up the alert system. But if you can become a champion for the effort it will be very helpful for everyone involved.

If you implement something like this you can increase the signal to noise ratio for you and your team. That seems like a big win for everyone.
