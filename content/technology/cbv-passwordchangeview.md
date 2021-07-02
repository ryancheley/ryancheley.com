Title: CBV - PasswordChangeView
Date: 2019-12-22 10:00
Author: ryan
Tags: CBV, class based views, django
Slug: cbv-passwordchangeview
Status: published

From [Classy Class Based Views](http://ccbv.co.uk/projects/Django/2.2/django.contrib.auth.views/PasswordChangeView/) `PasswordChangeView`

> > A view for displaying a form and rendering a template response.

## Attributes

-   form_class: The form that will be used by the template created. Defaults to Django’s `PasswordChangeForm`
-   success_url: If you’ve created your own custom PasswordChangeDoneView then you’ll need to update this. The default is to use Django’s but unless you have a top level `urls.py` has the name of `password_change_done` you’ll get an error.
-   title: defaults to ‘Password Change’ and is translated into local language

## Example

views.py

    class myPasswordChangeView(PasswordChangeView):
        success_url = reverse_lazy('rango:password_change_done_view')

urls.py

    path('password_change_view/', views.myPasswordChangeView.as_view(), name='password_change_view'),

password_change_form.html

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

## Diagram

A visual representation of how `PasswordChangeView` is derived can be seen here:

![](https://yuml.me/diagram/plain;/class/%5BPasswordContextMixin%7Bbg:white%7D%5D%5E-%5BPasswordChangeView%7Bbg:green%7D%5D,%20%5BFormView%7Bbg:lightblue%7D%5D%5E-%5BPasswordChangeView%7Bbg:green%7D%5D,%20%5BTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BFormView%7Bbg:lightblue%7D%5D,%20%5BBaseFormView%7Bbg:white%7D%5D%5E-%5BFormView%7Bbg:lightblue%7D%5D,%20%5BFormMixin%7Bbg:white%7D%5D%5E-%5BBaseFormView%7Bbg:white%7D%5D,%20%5BContextMixin%7Bbg:white%7D%5D%5E-%5BFormMixin%7Bbg:white%7D%5D,%20%5BProcessFormView%7Bbg:white%7D%5D%5E-%5BBaseFormView%7Bbg:white%7D%5D,%20%5BView%7Bbg:lightblue%7D%5D%5E-%5BProcessFormView%7Bbg:white%7D%5D.svg)

## Conclusion

The only thing to keep in mind here is the success_url that will most likely need to be set based on the application you’ve written. If you get an error about not being able to use `reverse` to find your template, that’s the issue.
