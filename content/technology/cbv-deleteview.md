Title: CBV - DeleteView
Date: 2019-12-11 10:00
Author: ryan
Tags: CBV, class based views, Django
Slug: cbv-deleteview
Status: published

From [Classy Class Based Views](http://ccbv.co.uk/projects/Django/2.2/django.views.generic.edit/DeleteView/) `DeleteView`

> > View for deleting an object retrieved with self.get*object(), with a  
> > *

response rendered by a template.

## Attributes

There are no new attributes, but 2 that we’ve seen are required: (1) `queryset` or `model`; and (2) `success_url`

## Example

views.py

    class myDeleteView(DeleteView):
        queryset = Person.objects.all()
        success_url = reverse_lazy('rango:list_view')

urls.py

    path('delete_view/<int:pk>', views.myDeleteView.as_view(), name='delete_view'),

\<template_name\>.html

Below is just the form that would be needed to get the delete to work.

        <form method="post">
        {% csrf_token %}
        <table border="1">
            <tr>
            <th>First Name</th>
            <th>Last Name</th>
            </tr>
            <tr>
                <td>{{ person.first_name }}</td>
                <td>{{ person.last_name }}</td>
            </tr>
        </table>
        <div>
            <a href="{% url 'rango:list_view' %}">Back</a>
            <input type="submit" value="Delete">
        </div>
        </form>

## Diagram

A visual representation of how `DeleteView` is derived can be seen here:

![DeleteView](https://yuml.me/diagram/plain;/class/%5BSingleObjectTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BDeleteView%7Bbg:green%7D%5D,%20%5BTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BSingleObjectTemplateResponseMixin%7Bbg:white%7D%5D,%20%5BBaseDeleteView%7Bbg:white%7D%5D%5E-%5BDeleteView%7Bbg:green%7D%5D,%20%5BDeletionMixin%7Bbg:white%7D%5D%5E-%5BBaseDeleteView%7Bbg:white%7D%5D,%20%5BBaseDetailView%7Bbg:white%7D%5D%5E-%5BBaseDeleteView%7Bbg:white%7D%5D,%20%5BSingleObjectMixin%7Bbg:white%7D%5D%5E-%5BBaseDetailView%7Bbg:white%7D%5D,%20%5BContextMixin%7Bbg:white%7D%5D%5E-%5BSingleObjectMixin%7Bbg:white%7D%5D,%20%5BView%7Bbg:lightblue%7D%5D%5E-%5BBaseDetailView%7Bbg:white%7D%5D.svg)

## Conclusion

As far as implementations, the ability to add a form to delete data is about the easiest thing you can do in Django. It requires next to nothing in terms of implementing. We now have step 4 of a CRUD app!
