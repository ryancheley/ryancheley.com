Title: Setting the Timezone on my server
Date: 2017-12-15 02:41
Author: ryan
Tags: server
Slug: setting-the-timezone-on-my-server
Status: published

When I scheduled my last post on December 14th to be published at 6pm that night I noticed that the schedule time was a bit … off:

![](/images/uploads/2017/12/Image-12-14-17-6-36-PM.jpeg){.alignnone .size-full .wp-image-99 width="601" height="479"}

I realized that the server times as still set to GMT and that I had missed the step in the Linode Getting Started guide to Set the Timezone.

No problem, just found the Guide, went to [this](https://linode.com/docs/getting-started/#set-the-timezone "Set the Timezone") section and ran the following command:

`sudo dpkg-reconfigure tzdata`

I then selected my country (US) and my time zone (Pacific-Ocean) and now the server has the right timezone.
