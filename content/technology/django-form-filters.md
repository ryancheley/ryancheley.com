Title: Django form filters
Date: 2021-01-23 12:00
Author: ryan
Tags: filters, forms
Slug: django-form-filters
Status: published

I’ve been working on a Django Project for a while and one of the apps I have tracks candidates. These candidates have dates of a specific type.

The models look like this:

## Candidate

``` {.wp-block-code}
class Candidate(models.Model):
    first_name = models.CharField(max_length=128)
    last_name = models.CharField(max_length=128)
    resume = models.FileField(storage=PrivateMediaStorage(), blank=True, null=True)
    cover_leter = models.FileField(storage=PrivateMediaStorage(), blank=True, null=True)
    email_address = models.EmailField(blank=True, null=True)
    linkedin = models.URLField(blank=True, null=True)
    github = models.URLField(blank=True, null=True)
    rejected = models.BooleanField()
    position = models.ForeignKey(
        "positions.Position",
        on_delete=models.CASCADE,
    )
    hired = models.BooleanField(default=False)
```

## CandidateDate

``` {.wp-block-code}
class CandidateDate(models.Model):
    candidate = models.ForeignKey(
        "Candidate",
        on_delete=models.CASCADE,
    )
    date_type = models.ForeignKey(
        "CandidateDateType",
        on_delete=models.CASCADE,
    )
    candidate_date = models.DateField(blank=True, null=True)
    candidate_date_note = models.TextField(blank=True, null=True)
    meeting_link = models.URLField(blank=True, null=True)

    class Meta:
        ordering = ["candidate", "-candidate_date"]
        unique_together = (
            "candidate",
            "date_type",
        )
```

## CandidateDateType

``` {.wp-block-code}
class CandidateDateType(models.Model):
    date_type = models.CharField(max_length=24)
    description = models.CharField(max_length=255, null=True, blank=True)
```

You’ll see from the CandidateDate model that the fields `candidate` and `date_type` are unique. One problem that I’ve been running into is how to help make that an easier thing to see in the form where the dates are entered.

The Django built in validation will display an error message if a user were to try and select a `candidate` and `date_type` that already existed, but it felt like this could be done better.

I did a fair amount of Googling and had a couple of different *bright* ideas, but ultimately it came down to a pretty simple implementation of the `exclude` keyword in the ORM

The initial `Form` looked like this:

``` {.wp-block-code}
class CandidateDateForm(ModelForm):
   class Meta:
        model = CandidateDate
        fields = [
            "candidate",
            "date_type",
            "candidate_date",
            "meeting_link",
            "candidate_date_note",
        ]
        widgets = {
            "candidate": HiddenInput,
        }
```

I updated it to include a `__init__` method which overrode the options in the drop down.

``` {.wp-block-code}
def __init__(self, *args, **kwargs):
    super(CandidateDateForm, self).__init__(*args, **kwargs)
    try:
        candidate = kwargs["initial"]["candidate"]
        candidate_date_set = CandidateDate.objects.filter(candidate=candidate).values_list("date_type", flat=True)
        qs = CandidateDateType.objects.exclude(id__in=candidate_date_set)
        self.fields["date_type"].queryset = qs
    except KeyError:
        pass
```

Now, with this method the drop down will only show items which can be selected, not all `CandidateDateType` options.

Seems like a better user experience AND I got to learn a bit about the Django ORM
