Title: My first commit to an Open Source Project: Django
Date: 2019-12-07 15:54
Author: ryan
Tags: django, documentation, Github
Slug: my-first-commit-to-an-open-source-project-django
Status: published

Last September the annual Django Con was held in San Diego. I **really** wanted to go, but because of other projects and conferences for my job, I wasn’t able to make it.

The next best thing to to watch the [videos from DjangoCon on YouTube](https://www.youtube.com/playlist?list=PL2NFhrDSOxgXXUMIGOs8lNe2B-f4pXOX-). I watched a couple of the videos, but one that really caught my attention was by [Carlton Gibson](https://github.com/carltongibson) titled “[Your Web Framework Needs You: An Update by Carlton Gibson](https://www.youtube.com/watch?v=LjTRSH0pNBo)”.

I took what Carlton said to heart and thought, I really should be able to do *something* to help.

I went to the [Django Issues site](https://code.djangoproject.com/) and searched for an **Easy Pickings** issue that involved documentation and found [issue 31006 “Document how to escape a date/time format character for the \|date and \|time filters.”](https://code.djangoproject.com/ticket/31006)

I read the [steps on what I needed to do to submit a pull request](https://docs.djangoproject.com/en/dev/internals/contributing/writing-code/working-with-git/#publishing-work), but since it was my first time **ever** participating like this … I was a bit lost.

Luckily there isn’t anything that you can break, so I was able to wonder around for a bit and get my bearings.

I forked the GitHub repo and I cloned it locally.

I then spent an **embarasingly** long time trying to figure out where the change was going to need to be made, and exactly what needed to change.

Finally, with my changes made, I [pushed my code changes](https://github.com/django/django/pull/12128#issue-344767579) to GitHub and waited.

Within a few hours [Mariusz Felisiak replied back](https://github.com/django/django/pull/12128#issuecomment-557804299) and asked about a suggestion he had made (but which I missed). I dug back into the documentation, found what he was referring to, and made (what I thought) was his suggested change.

Another push and a bit more waiting.

Mariusz Felisiak replied back with some input about the change I pushed up, and I realized I had missed the mark on what he was suggesting.

OK. [Third time’s a charm](#), right?

Turns out, in this case it was. [I pushed up one last time](https://github.com/django/django/pull/12128#issuecomment-560278417) and this time, my changes were [merged](https://github.com/django/django/commit/cd7f48e85e3e4b9f13df6c0ef5f1d95abc079ff6#diff-7be9aaef6dad344e74188264c0e95daa) into the master and just like that, I am now a contributor to Django (albeit a very, very, very minor contributor).

Overall, this was a great experience, both with respect to learning about contributing to an open source project, as well as learning about GitHub.

I’m hoping that with the holidays upon us I’ll be able to find the time to pick up one or two (maybe even three) **Easy Pickings** issues from the Django issue tracker.
