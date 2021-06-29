Title: CBV - UpdateView
Date: 2019-12-08 10:00
Author: ryan
Category: Technology
Tags: CBV, class based views, django
Slug: cbv-updateview
Status: published

From [Classy Class Based Views](http://ccbv.co.uk/projects/Django/2.2/django.views.generic.edit/UpdateView/) `UpdateView`

> > View for updating an object, with a response rendered by a template.

## Attributes

Two attributes are required to get the template to render. We’ve seen `queryset` before and in [CreateView](/cbv-createview/) we saw `fields`. As a brief refresher

-   fields: specifies what fields from the model or queryset will be displayed on the rendered template. You can you set `fields` to `__all__` if you want to return all of the fields
-   success_url: you’ll want to specify this after the record has been updated so that you know the update was made.

## Example

views.py

    class myUpdateView(UpdateView):
        queryset = Person.objects.all()
        fields = '__all__'
        extra_context = {
            'type': 'Update'
        }
        success_url = reverse_lazy('rango:list_view')

urls.py

    path('update_view/<int:pk>', views.myUpdateView.as_view(), name='update_view'),

\<template\>.html

    {% block content %}
        <h3>{{ type }} View</h3>
        {% if type == 'Create' %}
            <form action="." method="post">
        {% else %}
            <form action="{% url 'rango:update_view' object.id %}" method="post">
        {% endif %}
        {% csrf_token %}
        <table>
        {{ form.as_p }}
        </table>
        <button type="submit">SUBMIT</button>
        </form>
    {% endblock %}

## Diagram

A visual representation of how `UpdateView` is derived can be seen here:

![](https://yuml.me/diagram/plain;/class/%5BSingleObjectTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BUpdateView%7Bbg:green%7D%5D,%20%5BTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BSingleObjectTemplateResponseMixin%7Bbg:white%7D%5D,%20%5BBaseUpdateView%7Bbg:white%7D%5D%5E-%5BUpdateView%7Bbg:green%7D%5D,%20%5BModelFormMixin%7Bbg:white%7D%5D%5E-%5BBaseUpdateView%7Bbg:white%7D%5D,%20%5BFormMixin%7Bbg:white%7D%5D%5E-%5BModelFormMixin%7Bbg:white%7D%5D,%20%5BContextMixin%7Bbg:white%7D%5D%5E-%5BFormMixin%7Bbg:white%7D%5D,%20%5BSingleObjectMixin%7Bbg:white%7D%5D%5E-%5BModelFormMixin%7Bbg:white%7D%5D,%20%5BContextMixin%7Bbg:white%7D%5D%5E-%5BSingleObjectMixin%7Bbg:white%7D%5D,%20%5BProcessFormView%7Bbg:white%7D%5D%5E-%5BBaseUpdateView%7Bbg:white%7D%5D,%20%5BView%7Bbg:lightblue%7D%5D%5E-%5BProcessFormView%7Bbg:white%7D%5D.svg)

## Conclusion

A simple way to implement a form to update data in a model. Step 3 for a CR**U**D app is now complete!
