Title: Pushing Changes from Pythonista to GitHub - Step 1
Date: 2016-10-29 16:00
Author: ryan
Category: Technology
Tags: Github, Workflow, Automation
Slug: pushing-changes-from-pythonista-to-github-step1
Status: published

With the most recent release of the iOS app [Workflow](https://workflow.is) I was toying with the idea of writing a workflow that would allow me to update / add a file to a [GitHub repo](https://github.com) via a workflow.

My thinking was that since [Pythonista](http://omz-software.com/pythonista/) is only running local files on my iPad if I could use a workflow to access the api elements to push the changes to my repo that would be pretty sweet.

In order to get this to work I'd need to be able to accomplosh the following things (not necessarily in this order)

-   Have the workflow get a list of all of the repositories in my GitHub
-   Get the current contents of the app to the clip board
-   Commit the changes to the master of the repo

I have been able to write a [Workflow](https://workflow.is/workflows/8e986867ff074dbe89c7b0bf9dcb72f5) that will get all of the public repos of a specified github user. Pretty straight forward stuff.

The next thing I'm working on getting is to be able to commit the changes from the clip board to a specific file in the repo (if one is specified) otherwise a new file would be created.

I really just want to 'have the answer' for this, but I know that the journey will be the best part of getting this project completed.

So for now, I continue to read the [GitHub API Documentation](https://developer.github.com/v3/) to discover exactly how to do what I want to do.
