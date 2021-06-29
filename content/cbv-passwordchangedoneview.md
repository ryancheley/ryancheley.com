Title: CBV - PasswordChangeDoneView
Date: 2019-12-25 10:00
Author: ryan
Category: Technology
Tags: CBV, class based views, django
Slug: cbv-passwordchangedoneview
Status: published

From [Classy Class Based Views](http://ccbv.co.uk/projects/Django/2.2/django.contrib.auth.views/PasswordChangeDoneView/) `PasswordChangeDoneView`

> > Render a template. Pass keyword arguments from the URLconf to the context.

## Attributes

-   template_name: Much like the `LogoutView` the default view is the Django skin. Create your own `password_change_done.html` file to keep the user experience consistent across the site.
-   title: the default uses the function `gettext_lazy()` and passes the string ‘Password change successful’. The function `gettext_lazy()` will translate the text into the local language if a translation is available. I’d just keep the default on this.

## Example

views.py

    class myPasswordChangeDoneView(PasswordChangeDoneView):
        pass

urls.py

    path('password_change_done_view/', views.myPasswordChangeDoneView.as_view(), name='password_change_done_view'),

password_change_done.html

    {% extends "base.html" %}
    {% load i18n %}

    {% block content %}
        <h1>
        {% block title %}
            {{ title }}
        {% endblock %}
        </h1>
    <p>{% trans "Password changed" %}</p>
    {% endblock %}

settings.py

    LOGIN_URL = '/<app_name>/login_view/'

The above assumes that have this set up in your `urls.py`

## Special Notes

You need to set the `URL_LOGIN` value in your `settings.py`. It defaults to `/accounts/login/`. If that path isn’t valid you’ll get a 404 error.

## Diagram

A visual representation of how `PasswordChangeDoneView` is derived can be seen here:

![](https://yuml.me/diagram/plain;/class/%5BPasswordContextMixin%7Bbg:white%7D%5D%5E-%5BPasswordChangeDoneView%7Bbg:green%7D%5D,%20%5BTemplateView%7Bbg:lightblue%7D%5D%5E-%5BPasswordChangeDoneView%7Bbg:green%7D%5D,%20%5BTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BTemplateView%7Bbg:lightblue%7D%5D,%20%5BContextMixin%7Bbg:white%7D%5D%5E-%5BTemplateView%7Bbg:lightblue%7D%5D,%20%5BView%7Bbg:lightblue%7D%5D%5E-%5BTemplateView%7Bbg:lightblue%7D%5D.svg)

## Conclusion

Again, not much to do here. Let Django do all of the heavy lifting, but be mindful of the needed work in `settings.py` and the new template you’ll need/want to create
