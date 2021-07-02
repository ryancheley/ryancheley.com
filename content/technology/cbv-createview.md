Title: CBV - CreateView
Date: 2019-12-01 10:00
Author: ryan
Tags: CBV, class based views, Django
Slug: cbv-createview
Status: published

From [Classy Class Based Views](http://ccbv.co.uk/projects/Django/2.2/django.views.generic.edit/CreateView/) `CreateView`

> > View for creating a new object, with a response rendered by a template.

## Attributes

Three attributes are required to get the template to render. Two we’ve seen before (`queryset` and `template_name`). The new one we haven’t see before is the `fields` attribute.

-   fields: specifies what fields from the model or queryset will be displayed on the rendered template. You can you set `fields` to `__all__` if you want to return all of the fields

## Example

views.py

    queryset = Person.objects.all()
    fields = '__all__'
    template_name = 'rango/person_form.html'

urls.py

    path('create_view/', views.myCreateView.as_view(), name='create_view'),

\<template\>.html

    {% extends 'base.html' %}

        <h1>
        {% block title %}
            {{ title }}
        {% endblock %}
        </h1>


    {% block content %}
        <h3>{{ type }} View</h3>
        <form action="." method="post">
        {% csrf_token %}
        <table>
        {{ form.as_p }}
        </table>
        <button type="submit">SUBMIT</button>
        </form>
    {% endblock %}

## Diagram

A visual representation of how `CreateView` is derived can be seen here:

![](https://yuml.me/diagram/plain;/class/%5BSingleObjectTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BCreateView%7Bbg:green%7D%5D,%20%5BTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BSingleObjectTemplateResponseMixin%7Bbg:white%7D%5D,%20%5BBaseCreateView%7Bbg:white%7D%5D%5E-%5BCreateView%7Bbg:green%7D%5D,%20%5BModelFormMixin%7Bbg:white%7D%5D%5E-%5BBaseCreateView%7Bbg:white%7D%5D,%20%5BFormMixin%7Bbg:white%7D%5D%5E-%5BModelFormMixin%7Bbg:white%7D%5D,%20%5BContextMixin%7Bbg:white%7D%5D%5E-%5BFormMixin%7Bbg:white%7D%5D,%20%5BSingleObjectMixin%7Bbg:white%7D%5D%5E-%5BModelFormMixin%7Bbg:white%7D%5D,%20%5BContextMixin%7Bbg:white%7D%5D%5E-%5BSingleObjectMixin%7Bbg:white%7D%5D,%20%5BProcessFormView%7Bbg:white%7D%5D%5E-%5BBaseCreateView%7Bbg:white%7D%5D,%20%5BView%7Bbg:lightblue%7D%5D%5E-%5BProcessFormView%7Bbg:white%7D%5D.svg)

## Conclusion

A simple way to implement a form to create items for a model. We’ve completed step 1 for a basic **C**RUD application.
