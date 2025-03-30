Title: Error Culture
Date: 2023-10-29
Author: ryan
Tags: culture, programming
Slug: error-culture
Series: Error Culture
Status: published

## What is Error Culture?

It's inevitable that at some point a service [ref]When I say service here I mean very loosely anything from a micro service up to a physical server.[/ref] will fail. When that service fails you can either choose to be alerted, or not. Because technology is so important to so many aspects of work, not getting an alert for a failing service isn't really an option. So we enable alerts ... for EVERYTHING.

This is good in that we know when things have gone bad ... but it's bad in that we can start to ignore these alerts because we get false positives. If you hear comments like,

> Oh yeah, that error always comes up, but we just ignore it because it doesn't mean anything

 or

> We don't really know why that error occurs, but it doesn't seem to impact anything, so we just ignore it

This is what I am calling, "Error Culture".

## OK, but why is that bad?

Initially, it might not *feel* bad.

**EVERYONE** knows that you can ignore that error because it doesn't mean anything. Of course, this knowledge tends to **NOT** be documented anywhere, so when you onboard new team members they don't know what **EVERYONE** knows ... because they weren't part of the **EVERYONE** that learned the lesson.

Additionally, if you're getting error messages and nothing truly bad every happens, then a few things can happen:

1. People start to question ALL of the alerts. I mean, if this one isn't valid, why is this OTHER one valid? Maybe I can ignore both 🤷‍♂️
2. You may be getting an alert about a small thing that can be ignored until it's a BIG thing. I think this image does good job of illustrating the point (found [here](https://naksecurity.medium.com/the-detriments-of-hero-culture-3fc455963d6e))

![We have a Problem Here!](https://miro.medium.com/v2/resize:fit:854/format:webp/1*QQvTuD-5AH2NKdh1_B_teQ.jpeg)

## Why does it happen?

In general, I've found that error culture can happen for a few reason

### Error Fatigue

If you get 1000 alerts every day, you're not going to be able to do anything about anything. This is similar phenomenon to 'Alert Fatgiue' which can happen in software applications (my experience is in Electronic Health Record systems) where users can just click `OK` or `Cancel` when an alert shows up and users may not actually see that there is a problem

### Lack of understanding of what the error is

It's surprising to find that people that receive alerts and they just delete them. They do this not out malice, but because they honeslty do not know what the alert is for. They were maybe opted into the alert (with no way to opt out) and therefore have no idea why they get it or what they are supposed to do with it. They may also be in an organization where asking questions to learn isn't encouraged and will therefore not ask why they are getting the alert.

### Lack of understanding of why the error is important

Related to the item above, but different, a person can receive an alert, but they don't understand why it's important. This is usually manifested in some of the things mentioned before. Ideas like,

> well, I've ignored this alert every day for 6 months, I don't know why I need to do anything about it now!

### Lack of understand of who the error will impact

I'm reminded of the Episode of [Friends](https://youtu.be/pMuVm1Y669U?si=--E-MDfTWPlHjBqk&t=180) where there is a light switch in Chandler and Joey's apartment and they don't know what it's for. At the end of the episide Monica is idly flipping the switch off and on and the camera pans to a Monica and Rachel's apartment where their TV keeps turning off and on.

Error culture can have a similar feeling. If I get an error every few days, but it doesn't impact me or my work I am likely to ignore it. It could be that the error is unimporatnt for me, but HUGELY important for you. This is a case where the error is being directled incorrectly. If we both got the error you could see that I got the email and then ask, hey, are you going to do anything about this?

### Emphasis on Hero Culture

This is probably the worst of all possibilities. Some cultures tend to emphasize Heroes or White Knights. They appreciate when someone comes in and 'Saves the Day'. Sometimes people get promoted because of this.

This tends to disincentivize the idea of fixing small problems before they become BIG problems. I might be getting an alert about an issue, but it's not a BIG deal and won't be for some time. Once it becomes a big deal I'll know how to fix it quickly, and I will. When I do, I'll be celebrated. Who wouldn't want that?

In this post I've identified some of the characteristics of Error Culture.

In the next post I'll talk about how to tell if you're in an Error Culture.

In the final post I'll write about what you might be able to do to mitigate, and maybe even eliminate, Error Culture where you are.
