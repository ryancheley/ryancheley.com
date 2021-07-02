Title: CBV - ListView
Date: 2019-11-17 10:00
Author: ryan
Tags: CBV, class based views, django
Slug: cbv-listview
Status: published

From [Classy Class Based Views](http://ccbv.co.uk/projects/Django/2.2/django.views.generic.list/ListView/) `ListView`:

> > Render some list of objects, set by `self.model` or `self.queryset`.
> >
> > `self.queryset` can actually be any iterable of items, not just a queryset.

There are 16 attributes for the `ListView` but only 2 types are required to make the page return something other than a [500](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#5xx_Server_errors) error:

-   Data
-   Template Name

## Data Attributes

You have a choice of either using `Model` or `queryset` to specify **what** data to return. Without it you get an error.

The `Model` attribute gives you less control but is easier to implement. If you want to see ALL of the records of your model, just set

    model = ModelName

However, if you want to have a bit more control over what is going to be displayed you’ll want to use `queryset` which will allow you to add methods to the specified model, ie `filter`, `order_by`.

    queryset = ModelName.objects.filter(field_name='filter')

If you specify both `model` and `queryset` then `queryset` takes precedence.

## Template Name Attributes

You have a choice of using `template_name` or `template_name_suffix`. The `template_name` allows you to directly control what template will be used. For example, if you have a template called `list_view.html` you can specify it directly in `template_name`.

`template_name_suffix` will calculate what the template name should be by using the app name, model name, and appending the value set to the `template_name_suffix`.

In pseudo code:

    templates/<app_name>/<model_name>_<template_name_suffix>.html

For an app named `rango` and a model named `person` setting `template_name_suffix` to `_test` would resolve to

    templates/rango/person_test.html

## Other Attributes

If you want to return something interesting you’ll also need to specify

-   allow_empty: The default for this is true which allows the page to render if there are no records. If you set this to `false` then returning no records will result in a 404 error
-   context_object_name: allows you to give a more memorable name to the object in the template. You’ll want to use this if you want to have future developers (i.e. you) not hate you
-   ordering: allows you to specify the order that the data will be returned in. The field specified must exist in the `model` or `queryset` that you’ve used
-   page_kwarg: this indicates the name to use when going from page x to y; defaults to `name` but overriding it to something more sensible can be helpful for SEO. For example you can use `name` instead of `page` if you’ve got a page that has a bunch of names

![](/images/uploads/2019/11/6FD85C21-0593-42E3-80E3-F835126CDB72_4_5005_c.jpeg){.alignnone .size-full .wp-image-387 width="488" height="37"}

-   paginate_by: determines the maximum number of records to return on any page.
-   paginate_orphans: number of items to add to the last page; this helps keep pages with singletons (or some other small number
-   paginator_class: class that defines several of the attributes above. Don’t mess with this unless you have an actual reason to do so. Also … you’re not a special snowflake, there are literal dragons in down this road. Go back!

## Diagram

A visual representation of how `ListView` is derived can be seen here:

![](https://yuml.me/diagram/plain;/class/%5BMultipleObjectTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BListView%7Bbg:green%7D%5D,%20%5BTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BMultipleObjectTemplateResponseMixin%7Bbg:white%7D%5D,%20%5BBaseListView%7Bbg:white%7D%5D%5E-%5BListView%7Bbg:green%7D%5D,%20%5BMultipleObjectMixin%7Bbg:white%7D%5D%5E-%5BBaseListView%7Bbg:white%7D%5D,%20%5BContextMixin%7Bbg:white%7D%5D%5E-%5BMultipleObjectMixin%7Bbg:white%7D%5D,%20%5BView%7Bbg:lightblue%7D%5D%5E-%5BBaseListView%7Bbg:white%7D%5D.svg)

## Conclusion

The `ListView` CBV is a powerful and highly customizable tool that allows you to display the data from a single model quite easily.
