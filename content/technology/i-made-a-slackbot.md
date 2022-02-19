Title: I made a Slackbot!
Date: 2022-02-19
Author: ryan
Tags: django, drf, slack
Slug: i-made-a-slackbot
Status: published

## Building my first Slack Bot

I had added a project to my OmniFocus database in November of 2021 which was, "Build a Slackbot" after watching a [Video](https://www.youtube.com/watch?v=2X8SrKL7E9A) by [Mason Egger](https://twitter.com/masonegger). I had hoped that I would be able to spend some time on it over the holidays, but I was never able to really find the time.

A few weeks ago, [Bob Belderbos](https://twitter.com/bbelderbos) tweeted:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">If you were to build a Slack bot, what would it do?</p>&mdash; Bob Belderbos (@bbelderbos) <a href="https://twitter.com/bbelderbos/status/1488806429251313666?ref_src=twsrc%5Etfw">February 2, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

And I responded

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">I work in US Healthcare where there are a lot of Acronyms (many of which are used in tech but have different meaning), so my slack bot would allow a user to enter an acronym and return what it means, i.e., CMS = Centers for Medicare and Medicaid Services.</p>&mdash; The B Is Silent (@ryancheley) <a href="https://twitter.com/ryancheley/status/1488879253911261184?ref_src=twsrc%5Etfw">February 2, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

I didn't *really* have anymore time now than I did over the holiday, but Bob asking and me answering pushed me to *actually* write the darned thing.

I think one of the problems I encountered was what backend / tech stack to use. I'm familiar with Django, but going from 0 to something in production has a few steps and although I know how to do them ... I just felt ~overwhelmed~ by the prospect.

I felt equally ~overwhelmed~ by the prospect of trying FastAPI to create the API or Flask, because I am not as familiar with their deployment story.

Another thing that was different now than before was that I had worked on a [Django Cookie Cutter](https://github.com/ryancheley/django-cookiecutter) to use and that was 'good enough' to try it out. So I did.

I ran into a few [problems](https://github.com/ryancheley/django-cookiecutter/compare/de07ba6..cd7c272) while working with my Django Cookie Cutter but I fixed them and then dove head first into writing the Slack Bot

## The model

The initial implementation of the model was very simple ... just 2 fields:

```
class Acronym(models.Model):
    acronym = models.CharField(max_length=8)
    definition = models.TextField()

    def save(self, *args, **kwargs):
        self.acronym = self.acronym.lower()
        super(Acronym, self).save(*args, **kwargs)

    class Meta:
        unique_together = ("acronym", "definition")
        ordering = ["acronym"]

    def __str__(self) -> str:
        return self.acronym
```

Next I created the API using [Django Rest Framework](https://www.django-rest-framework.org) using a single `serializer`

```
class AcronymSerializer(serializers.ModelSerializer):
    class Meta:
        model = Acronym
        fields = [
            "id",
            "acronym",
            "definition",
        ]

```

which is used by a single `view`

```
class AcronymViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = AcronymSerializer
    queryset = Acronym.objects.all()

    def get_object(self):
        queryset = self.filter_queryset(self.get_queryset())
        print(self.kwargs["acronym"])
        acronym = self.kwargs["acronym"]
        obj = get_object_or_404(queryset, acronym__iexact=acronym)

        return obj
```

and exposed on 2 end points:

```
from django.urls import include, path

from .views import AcronymViewSet, AddAcronym, CountAcronyms, Events

app_name = "api"

user_list = AcronymViewSet.as_view({"get": "list"})
user_detail = AcronymViewSet.as_view({"get": "retrieve"})

urlpatterns = [
    path("", AcronymViewSet.as_view({"get": "list"}), name="acronym-list"),
    path("<acronym>/", AcronymViewSet.as_view({"get": "retrieve"}), name="acronym-detail"),
    path("api-auth/", include("rest_framework.urls", namespace="rest_framework")),
]
```

## Getting the data

At my joby-job we use Jira and Confluence. In one of our Confluence spaces we have a Glossary page which includes nearly 200 acronyms. I had two choices:

1. Copy and Paste the acronym and definition for each item
2. Use Python to get the data

I used Python to get the data, via a Jupyter Notebook, but I didn't seem to save the code anywhere (🤦🏻), so I can't include it here. But trust me, it was 💯.


## Setting up the Slack Bot

Although I had watched Mason's video, since I was building this with Django I used [this article](https://medium.com/freehunch/how-to-build-a-slack-bot-with-python-using-slack-events-api-django-under-20-minute-code-included-269c3a9bf64e) as a guide in the development of the code below.

The code from my `views.py` is below:

```

ssl_context = ssl.create_default_context()
ssl_context.check_hostname = False
ssl_context.verify_mode = ssl.CERT_NONE

SLACK_VERIFICATION_TOKEN = getattr(settings, "SLACK_VERIFICATION_TOKEN", None)
SLACK_BOT_USER_TOKEN = getattr(settings, "SLACK_BOT_USER_TOKEN", None)
CONFLUENCE_LINK = getattr(settings, "CONFLUENCE_LINK", None)
client = slack.WebClient(SLACK_BOT_USER_TOKEN, ssl=ssl_context)

class Events(APIView):
    def post(self, request, *args, **kwargs):

        slack_message = request.data

        if slack_message.get("token") != SLACK_VERIFICATION_TOKEN:
            return Response(status=status.HTTP_403_FORBIDDEN)

        # verification challenge
        if slack_message.get("type") == "url_verification":
            return Response(data=slack_message, status=status.HTTP_200_OK)
        # greet bot
        if "event" in slack_message:
            event_message = slack_message.get("event")

            # ignore bot's own message
            if event_message.get("subtype"):
                return Response(status=status.HTTP_200_OK)

            # process user's message
            user = event_message.get("user")
            text = event_message.get("text")
            channel = event_message.get("channel")
            url = f"https://slackbot.ryancheley.com/api/{text}/"
            response = requests.get(url).json()
            definition = response.get("definition")
            if definition:
                message = f"The acronym '{text.upper()}' means: {definition}"
            else:
                confluence = CONFLUENCE_LINK + f'/dosearchsite.action?cql=siteSearch+~+"{text}"'
                confluence_link = f"<{confluence}|Confluence>"
                message = f"I'm sorry <@{user}> I don't know what *{text.upper()}* is :shrug:. Try checking {confluence_link}."

            if user != "U031T0UHLH1":
                client.chat_postMessage(
                    blocks=[{"type": "section", "text": {"type": "mrkdwn", "text": message}}], channel=channel
                )
                return Response(status=status.HTTP_200_OK)
        return Response(status=status.HTTP_200_OK)
```

Essentially what the Slack Bot does is takes in the `request.data['text']` and checks it against the DRF API end point to see if there is a matching Acronym.

If there is, then it returns the acronym and it's definition.

If it's not, you get a message that it's not sure what you're looking for, but that maybe Confluence[ref]You'll notice that I'm using an environment variable to define the Confluence Link and may wonder why. It's mostly to keep the actual Confluence Link used at work non-public and not for any other reason 🤷🏻[/ref] can help, and gives a link to our Confluence Search page.

The last thing you'll notice is that if the User has a specific ID it won't respond with a message. That's because in my initial testing I just had the Slack Bot replying to the user saying 'Hi' with a 'Hi' back to the user.

I had a missing bit of logic though, so once you said hi to the Slack Bot, it would reply back 'Hi' and then keep replying 'Hi' because it was talking to itself. It was comical to see in real time 😂.

## Using ngrok to test it locally

[`ngrok`](https://ngrok.com) is a great tool for taking a local url, like  [localhost:8000/api/entpoint](localhost:8000/api/entpoint), and exposing it on the internet with a url like [https://a123-45-678-901-234.ngrok.io/api/entpoint](https://a123-45-678-901-234.ngrok.io/api/entpoint). This allows you to test your local code and see any issues that might arise when pushed to production.

As I mentioned above the Slack Bot continually said "Hi" to itself in my initial testing. Since I was running ngrok to serve up my local Server I was able to stop the infinite loop by stopping my local web server. This would have been a little more challenging if I had to push my code to an actual web server first and **then** tested.

## Conclusion

This was such a fun project to work on, and I'm really glad that [Bob](https://twitter.com/bbelderbos) tweeted asking what Slack Bot we would build.

That gave me the final push to actually build it.
