Title: Keeping track of which movies I want to watch
Date: 2016-11-28 01:53
Author: ryan
Tags: iTunes, Workflow
Slug: keeping-track-of-which-movies-i-want-to-watch
Status: published

One thing I like to do with my family is watch movies. But not just any movies, Comic Book movies. We've seen both [Thor](https://itun.es/us/ieifP) and [Thor: The Dark World](https://itun.es/us/7tLNR), [Iron Man](https://itun.es/us/sLibP) and [Guardians of the Galaxy](https://itun.es/us/KoVM1). It's not a lot, but we're working on it.

I've mapped out the [Marvel Cinematic Universe](https://en.m.wikipedia.org/wiki/Marvel_Cinematic_Universe) movies for us to watch, and it's OK, but there wasn't a easy way to link into the iTunes store from the list.

I decided that I could probably use [Workflow](https://appsto.re/us/2IzJ2.i) to do this, but I hadn't really worked with it to do it, but today I had a bit of time and figured, "what they heck ... why not?"

My initial attempt was clunky. It required to workflows to accomplish what I needed. This was because I had to split the work of [Workflow](https://appsto.re/us/2IzJ2.i) into 2 workflows:

-   Get the Name
-   Get the Link

Turns out there's a much easier way, so I'll post the link to that workflow, and not the workflows that are much harder to use!

The workflow [Add Movie to Watch](https://workflow.is/workflows/66f269ed34cb42469df4de8dcb7739e7) accepts `iTunes products`. The workflow then does the following:

-   It saves the `iTunes products` URL as a variable called `iTunes`
-   It then gets the `iTunes` variable to retrieve the `Name` and sets the value to a variable called `Movie`
-   Next it asks 'Who is the movie being added by?' This is important for my family as we want a common list, but it's also good to know who added the movie!
-   This value is saved to a variable called `User`
-   Finally, I want to know when the movie was added so I get the current date.

We take all of the items and construct a bit of `text` that looks like this:

` [{Movie}]({iTunes}) - Added on {Input} by {User}`

Where each of the words above surrounded by the {} are the variable names previously mentioned ({Input} is from the get current date and doesn't need to be saved to a variable).

In my last step I take this text and append it to a file in Dropbox called `Movies to Watch.md`.

It took **way** longer than I would have liked to finish this up, but at the end of the day, I'm glad that I was able to get it done.
