Title: Error Culture Part II
Date: 2023-11-09
Author: ryan
Tags: culture, programming
Slug: error-culture-part-ii
Series: Error Culture
Status: published

In my last post I spoke about the idea of [Error Culture](https://www.ryancheley.com/2023/10/29/error-culture/). In that post I define what error culture. This time I'll talk about when it starts to happen. For a recap go back and read that before diving in here.

# When does error culture start?

Error culture can start because of internal reason, external reason, or both and are almost always driven by the best of intentions. Error culture starts to happen because we don't finish the alert process. That is, we set up the alerts, but we don't indicate why they are important or what to do about them when we're notified.

## Internal

Internal pressures driving error culture can usually be traced back to someone (usually someone important [ref]important here just means someone with influence[/ref]) declaring that ‘we’ need to be notified of when ‘this’ happens again. In and of itself self, this is actually a really good idea.

But if the important person doesn't identify **why** we need to be notified all that happens is that an alert is set up and NO ONE knows what to do when it fires off.

The opposite side of the coin here is being proactive in wanting to be notified when a bad thing **might** happen and being notified **might** be useful. Again, if there is no definition for why the alert might be useful, you're simply creating noise and encouraging alerts to be ignored.

## External

External pressures that can drive error culture are similar to internal ones. There are some slight differences though.

For example, a consultant might indicate that it is `best practice TM` to be notified of an alert. However, they don't provide more context for why it's best practice. It could very well be that the recommendation IS best practice, but for a user base that is 100x your user base, or for an organization that is 1/10th your size. Context matters and while best practices should scale, they don't always.

Another example of external drivers are software applications provided by third party vendors with default alerts enabled but no context or steps for resolution. Sometimes there will be documentation describing the alert process, but without the context for why the alert is important it's just as likely to be ignored.

So far in this series we've seen what error culture is,and when it starts to happen. In the next post I'll talk about how to identify if you're in an error culture.
