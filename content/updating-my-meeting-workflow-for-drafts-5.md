Title: Updating my meeting Workflow for Drafts 5
Date: 2018-05-19 17:56
Author: ryan
Category: Technology
Tags: automation, Workflow, Automation
Slug: updating-my-meeting-workflow-for-drafts-5
Status: published

Drafts is a **productivity** app created by Greg Pierce (\@AgileTortoise).

I’ve loved and used Drafts 4 every day for the last several years. I loved it so much I even contributed to the Tip Jar Greg had in the app. Seriously, it’s an amazing app. If you haven’t [downloaded](https://itunes.apple.com/us/app/drafts-5-capture-act/id1236254471?mt=8) it already you totally should.

Recently, Greg released Drafts 5. With this new version comes a new Business Model as well. Instead of a single pay (and hope people ‘tip’ you) he’s converted to a subscription model.

I signed up for the free week and didn’t have a real opportunity to use it before my free week was converted into a pay week but I’ve no regrets. I like what Greg does and want him to keep updating his app so that I can get the benefits of it once I have a real chance to dive in.

Part of the reason I wasn’t able to really use the new version is the way that I primarily use Drafts. I have a [WorkFlow](https://workflow.is/workflows/fe54a103d8a94faaa5784510001e374e) that takes a meeting on my work calendar and allows me to take notes about that meetings.

It’s one of the most useful **productivity** tools I have during my morning standup meetings with my team, and it’s useful for the other (sometimes endless) meetings that I go to.

With the release of Drafts 5 I was not longer able to use both Drafts 5 AND my workflow, so I needed to update my workflow.

With Drafts 4 it was just one of the built in Apps. Because Drafts 5 limits some of the functionality unless you have the *PRO* version I don’t think that Workflow will be updated to include Drafts 5 like it did Drafts 4.

Once I realized that *AND* since I’m paying for the app I figured I’d need to update my Workflow instead of waiting and hoping that Workflow would be updated to include Drafts 5.

In order to make the update I had to look for [URL Scheme](https://www.w3.org/TR/app-uri/) for Drafts 5 ... but I couldn’t really find one. I assumed that Drafts 5 URL Scheme would be the same as [Drafts 4](https://agiletortoise.zendesk.com/hc/en-us/articles/202771400-Drafts-URL-Schemes) (I was right) and made various attempts at getting a copy of the Workflow to work with Drafts 5.

This is the section of the workflow that needs to be updated:

![](/images/uploads/2018/05/Image-5-19-18-6-37-PM.png){.alignnone .size-full .wp-image-282 width="1619" height="388"}

Since Drafts 5 isn’t included in the Built in Apps I was going to need to pass a URL and open the app.

This would require 3 separate steps in Workflow

1.  Convert Text into URL Encoded string
2.  Prepend the URL Scheme for creating a new draft to the URL Encoded String
3.  Open the URL

![](/images/uploads/2018/05/Image-5-19-18-6-37-PM-1.png){.alignnone .size-full .wp-image-283 width="1622" height="1490"}

This basically means that 1 step is now replaced with 3 ... but hey, that’s the price of progress must be paid!

Both the [Drafts 4](https://workflow.is/workflows/fe54a103d8a94faaa5784510001e374e) and [Drafts 5](https://workflow.is/workflows/dae8898da2c34dcf9eee099c333e749d) versions of these workflows are available.

If you enjoy them, hit me up in the comments or let me know on Twitter \@ryancheley!
