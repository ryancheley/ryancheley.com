Title: Logging in a Django App
Date: 2020-10-21 17:39
Author: ryan
Category: Django
Tags: digital ocean, django
Slug: logging-in-a-django-app
Status: published

Per the [Django Documentation](https://docs.djangoproject.com/en/3.1/ref/settings/#std:setting-ADMINS) you can set up

> A list of all the people who get code error notifications. When DEBUG=False and AdminEmailHandler is configured in LOGGING (done by default), Django emails these people the details of exceptions raised in the request/response cycle.

In order to set this up you need to include in your `settings.py` file something like:

``` {.wp-block-code}
ADMINS = [
    ('John', 'john@example.com'), 
    ('Mary', 'mary@example.com')
]
```

The difficulties I always ran into were:

1.  How to set up the AdminEmailHandler
2.  How to set up a way to actually email from the Django Server  

Again, per the [Django Documentation](https://docs.djangoproject.com/en/3.1/topics/logging/#django.utils.log.AdminEmailHandler "AdminEmailHandler"):

> Django provides one log handler in addition to those provided by the Python logging module

Reading through the documentation didn’t **really** help me all that much. The docs show the following example:

``` {.wp-block-code}
'handlers': {
    'mail_admins': {
        'level': 'ERROR',
        'class': 'django.utils.log.AdminEmailHandler',
        'include_html': True,
    }
},
```

That’s great, but there’s not a direct link (that I could find) to the example of how to configure the logging in that section. It is instead at the **VERY** bottom of the documentation page in the Contents section in the [Configured logging \> Examples](https://docs.djangoproject.com/en/3.1/topics/logging/#configuring-logging) section ... and you *really* need to know that you have to look for it!

The important thing to do is to include the above in the appropriate `LOGGING` setting, like this:

``` {.wp-block-code}
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'mail_admins': {
            'level': 'ERROR',
            'class': 'django.utils.log.AdminEmailHandler',
            'include_html': True,
        }
       },
    },
}
```

## Sending an email with Logging information

We’ve got the logging and it will be sent via email, but there’s no way for the email to get sent out yet!

In order to accomplish this I use [SendGrid](https://sendgrid.com "SendGrid"). No real reason other than that’s what I’ve used in the past.

There are [great tutorials online](https://sendgrid.com/docs/for-developers/sending-email/django/ "Django and SendGrid Tutorials") for how to get SendGrid integrated with Django, so I won’t rehash that here. I’ll just drop my the settings I used in my `settings.py`

``` {.wp-block-code}
SENDGRID_API_KEY = env("SENDGRID_API_KEY")

EMAIL_HOST = "smtp.sendgrid.net"
EMAIL_HOST_USER = "apikey"
EMAIL_HOST_PASSWORD = SENDGRID_API_KEY
EMAIL_PORT = 587
EMAIL_USE_TLS = True
```

One final thing I needed to do was to update the email address that was being used to send the email. By default it uses `root@localhost` which isn’t ideal.

You can override this by setting

``` {.wp-block-code}
SERVER_EMAIL = myemail@mydomain.tld
```

With those three settings, everything should just work.
