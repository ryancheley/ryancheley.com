Title: CBV - BaseListView
Date: 2019-11-17 10:00
Author: ryan
Category: Django
Tags: CBV, class based views, django
Slug: cbv-baselistview
Status: published

From [Classy Class Based Views](http://ccbv.co.uk/projects/Django/2.2/django.views.generic.list/BaseListView/) `BaseListView`

> > A base view for displaying a list of objects.

And from the [Django Docs](https://docs.djangoproject.com/en/2.2/ref/class-based-views/generic-display/#listview):

> > A base view for displaying a list of objects. It is not intended to be used directly, but rather as a parent class of the django.views.generic.list.ListView or other views representing lists of objects.

Almost all of the functionality of `BaseListView` comes from the `MultipleObjectMixin`. Since the Django Docs specifically say don’t use this directly, I won’t go into it too much.

## Diagram

A visual representation of how `BaseListView` is derived can be seen here:

![](https://yuml.me/diagram/plain;/class/%5BMultipleObjectMixin%7Bbg:white%7D%5D%5E-%5BBaseListView%7Bbg:green%7D%5D,%20%5BContextMixin%7Bbg:white%7D%5D%5E-%5BMultipleObjectMixin%7Bbg:white%7D%5D,%20%5BView%7Bbg:lightblue%7D%5D%5E-%5BBaseListView%7Bbg:green%7D%5D.svg)

## Conclusion

Don’t use this. It should be subclassed into a usable view (a la `ListView`).

There are many **Base** views that are ancestors for other views. I’m not going to cover any more of them going forward **UNLESS** the documentation says there’s a specific reason to.
