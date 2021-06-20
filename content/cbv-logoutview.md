Title: CBV - LogoutView
Date: 2019-12-15 10:00
Author: ryan
Category: Django
Tags: authentication, CBV, class based views, django
Slug: cbv-logoutview
Status: published

From [Classy Class Based Views](http://ccbv.co.uk/projects/Django/2.2/django.contrib.auth.views/LogoutView/) `LogoutView`

> > Log out the user and display the 'You are logged out' message.

## Attributes

-   next_page: redirects the user on logout.
-   [redirect_field_name](https://docs.djangoproject.com/en/2.2/topics/auth/default/#django.contrib.auth.views.LogoutView): The name of a GET field containing the URL to redirect to after log out. Defaults to next. Overrides the next_page URL if the given GET parameter is passed.^[1](#fn1){#ffn1 .footnote}^
-   template_name: defaults to `registration\logged_out.html `. Even if you don’t have a template the view does get rendered but it uses the default Django skin. You’ll want to create your own to allow the user to logout AND to keep the look and feel of the site.

## Example

views.py

    class myLogoutView(LogoutView):
        pass

urls.py

    path('logout_view/', views.myLogoutView.as_view(), name='logout_view'),

registrationlogged_out.html

    {% extends "base.html" %}
    {% load i18n %}

    {% block content %}
    <p>{% trans "Logged out" %}</p>
    {% endblock %}

## Diagram

A visual representation of how `LogoutView` is derived can be seen here:

Image Link from CCBV YUML goes here

## Conclusion

I’m not sure how it could be much easier to implement a logout page.

1.  [Per Django Docs [↩](#ffn1)]{#fn1}
