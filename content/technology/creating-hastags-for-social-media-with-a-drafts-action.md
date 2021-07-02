Title: Creating Hastags for Social Media with a Drafts Action
Date: 2019-03-30 05:46
Author: ryan
Tags: Drafts, JavaScript, Social Media, Automation
Slug: creating-hastags-for-social-media-with-a-drafts-action
Status: published

Creating meaningful, long \#hastags can be a pain in the butt.

There you are, writing up a witty tweet or making that perfect caption for your instagram pic and you realize that you have a fantastic idea for a hash tag that is more of a sentence than a single word.

You proceed to write it out and unleash your masterpiece to the world and just as you hit the submit button you notice that you have a typo, or the wrong spelling of a word and \#ohcrap you need to delete and retweet!

That lead me to write a [Drafts](https://getdrafts.com) Action to take care of that.

I’ll leave [others to write about the virtues of Drafts](https://www.macstories.net/reviews/drafts-5-the-macstories-review/), but it’s fantastic.

The Action I created has two steps: (1) to run some JavaScript and (2) to copy the contents of the draft to the Clipboard. You can get my action [here](https://actions.getdrafts.com/a/1Uo).

Here’s the JavaScript that I used to take a big long sentence and turn it into a social media worthy hashtag

    var contents = draft.content;
    var newContents = "#";


    editor.setText(newContents+contents.replace(/ /g, "").toLowerCase());

Super simple, but holy crap does it help!
