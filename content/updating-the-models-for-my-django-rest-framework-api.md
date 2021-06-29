Title: Updating the models for my Django Rest Framework API
Date: 2019-11-06 20:02
Author: ryan
Category: Technology
Tags: PyCharm, python
Slug: updating-the-models-for-my-django-rest-framework-api
Status: published

I’ve been working on a Django project which would allow users to track games that they’ve seen and, therefore, see what stadia they have visited.

This is all being done at a site i set up called [StadiaTracker.com](https://www.stadiatracker.com). Initially when constructing my model I kept it relatively simple. I had one model that had two fields. The two fields tied the User from my CustomUser Model to a Game ID that I retrieve from an API that MLB provides.

I thought this simple approach would be the best approach. In addition to having a Django App I set up a Django Rest Framework (DRF) API. My initial plan was to have a DRF backend with a Vue (or React) front end. (I still want to do that, but I really wanted to try and finish a project before proceeding down that path).

After some development and testing I quickly realized that the page loads for the app were suffering because of the number of API calls to MLB that were being made.

I created a new model to tie the user id (still from the CustomUser model I’d created) to the game id, but in addition I’d get and store the following information:

-   Home Team Name
-   Home Team Score
-   Home Team Hits
-   Home Team Errors
-   Away Team Name
-   Away Team Score
-   Away Team Hits
-   Away Team Errors
-   Game Recap Headline
-   Game Recap Summary
-   Game Date / Time

By storing all of this my views could render more quickly because they didn’t have to go to the MLB API to get the information.

Of course, once I did this I realized that the work I had done on the DRF API would also need to be updated.

Initially I kept putting off the refactoring that was going to have to be done. Finally, I just sat down and did it. And you know what, within 10 minutes I was done.

I only had to change 3 files:

-   serializers.py
-   urls.py
-   views.py

For the `searializers.py` and `views.py` all I had to do was add the new model and then copy and paste what I had done for the previous model.

For the `urls.py` it was just a simple matter of updating the the DRF path and detail path to use the new views I had just created.

It was so amazingly simple I could barely believe it. This thing I had put off for a couple of weeks because I was afraid it was going to be really hard, just wasn't.
