Title: CBV - ArchiveIndexView
Date: 2019-11-24 10:00
Author: ryan
Category: Django
Tags: CBV, class based views, django
Slug: cbv-archiveindexview
Status: published

From [Classy Class Based Views](http://ccbv.co.uk/projects/Django/2.2/django.views.generic.dates/ArchiveIndexView/) `ArchiveIndexView`

> > Top-level archive of date-based items.

## Attributes

There are 20 attributes that can be set for the `ArchiveIndexView` but most of them are based on ancestral Classes of the CBV so we won’t be going into them in Detail.

### DateMixin Attributes

-   allow_future: Defaults to False. If set to True you can show items that have dates that are in the future where the future is anything after the current date/time on the server.
-   date_field: the field that the view will use to filter the date on. If this is not set an error will be generated
-   uses_datetime_field: Convert a date into a datetime when the date field is a DateTimeField. When time zone support is enabled, `date` is assumed to be in the current time zone, so that displayed items are consistent with the URL.

### BaseDateListView Attributes

-   allow_empty: Defaults to `False`. This means that if there is no data a `404` error will be returned with the message  

    > > `No __str__ Available` where ‘`__str__`’ is the display of your model

-   date_list_period: This attribute allows you to break down by a specific period of time (years, months, days, etc.) and group your date driven items by the period specified. See below for implementation

For `year`

views.py

    date_list_period='year'

urls.py

Nothing special needs to be done

\<file_name\_\>.html

    {% block content %}
        <div>
            {%  for date in date_list %}
            {{ date.year }}
            <ul>
            {% for p in person %}
                {% if date.year == p.post_date.year %}
                    <li>{{ p.post_date }}: {{ p.first_name }} {{ p.last_name }}</li>
                {% endif %}
            {% endfor %}
            </ul>
            {% endfor %}
        </div>
    {% endblock %}

Will render:

![Rendered Archive Index View](/images/uploads/2019/11/634B59DC-6BA6-4C5F-B969-E8B924123FFA.jpeg){.alignnone .size-full .wp-image-394 width="866" height="542"}

For `month`

views.py

    date_list_period='month'

urls.py

Nothing special needs to be done

\<file_name\_\>.html

    {% block content %}
        <div>
            {%  for date in date_list %}
            {{ date.month }}
            <ul>
            {% for p in person %}
                {% if date.month == p.post_date.month %}
                    <li>{{ p.post_date }}: {{ p.first_name }} {{ p.last_name }}</li>
                {% endif %}
            {% endfor %}
            </ul>
            {% endfor %}
        </div>
    {% endblock %}

Will render:

![](/images/uploads/2019/11/04B40CD4-3B85-440D-810D-4050727D6120.jpeg){.alignnone .size-full .wp-image-395 width="1061" height="668"}

### BaseArchiveIndexView Attributes

-   context_object_name: Name the object used in the template. As stated before, you’re going to want to do this so you don’t hate yourself (or have other developers hate you).

## Other Attributes

### MultipleObjectMixin Attributes

These attributes were all reviewed in the [ListView](/cbv-listview.html) post

-   model = None
-   ordering = None
-   page_kwarg = 'page'
-   paginate_by = None
-   paginate_orphans = 0
-   paginator_class = \<class 'django.core.paginator.Paginator'\>
-   queryset = None

### TemplateResponseMixin Attributes

This attribute was reviewed in the [ListView](/cbv-listview.html) post

-   content_type = None

### ContextMixin Attributes

This attribute was reviewed in the [ListView](/cbv-listview.html) post

-   extra_context = None

### View Attributes

This attribute was reviewed in the [View](/cbv-view.html) post

-   http_method_names = \['get', 'post', 'put', 'patch', 'delete', 'head', 'options', 'trace'\]

### TemplateResponseMixin Attributes

These attributes were all reviewed in the [ListView](/cbv-listview.html) post

-   response_class = \<class 'django.template.response.TemplateResponse'\>
-   template_engine = None
-   template_name = None

## Diagram

A visual representation of how `ArchiveIndexView` is derived can be seen here:

![](https://yuml.me/diagram/plain;/class/%5BMultipleObjectTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BArchiveIndexView%7Bbg:green%7D%5D,%20%5BTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BMultipleObjectTemplateResponseMixin%7Bbg:white%7D%5D,%20%5BBaseArchiveIndexView%7Bbg:white%7D%5D%5E-%5BArchiveIndexView%7Bbg:green%7D%5D,%20%5BBaseDateListView%7Bbg:white%7D%5D%5E-%5BBaseArchiveIndexView%7Bbg:white%7D%5D,%20%5BMultipleObjectMixin%7Bbg:white%7D%5D%5E-%5BBaseDateListView%7Bbg:white%7D%5D,%20%5BContextMixin%7Bbg:white%7D%5D%5E-%5BMultipleObjectMixin%7Bbg:white%7D%5D,%20%5BDateMixin%7Bbg:white%7D%5D%5E-%5BBaseDateListView%7Bbg:white%7D%5D,%20%5BView%7Bbg:lightblue%7D%5D%5E-%5BBaseDateListView%7Bbg:white%7D%5D.svg)

## Conclusion

With date driven data (articles, blogs, etc.) The `ArchiveIndexView` is a great CBV and super easy to implement.
