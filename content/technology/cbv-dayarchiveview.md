Title: CBV - DayArchiveView
Date: 2019-11-27 10:00
Author: ryan
Tags: CBV, class based views, Django
Slug: cbv-dayarchiveview
Status: published

From [Classy Class Based Views](http://ccbv.co.uk/projects/Django/2.2/django.views.generic.dates/DayArchiveView/) `DayArchiveView`

> > List of objects published on a given day.

## Attributes

There are six new attributes to review here … well really 3 new ones and then a formatting attribute for each of these 3:

-   day: The day to be viewed
-   day_format: The format of the day to be passed. Defaults to `%d`
-   month: The month to be viewed
-   month_format: The format of the month to be passed. Defaults to `%b`
-   year: The year to be viewed
-   year_format: The format of the year to be passed. Defaults to `%Y`

## Required Attributes

-   day
-   month
-   year
-   date_field: The field that holds the date that will drive every else. We saw this in [ArchiveIndexView](/cbv-archiveindexview)

Additionally you also need `model` or `queryset`

The `day`, `month`, and `year` can be passed via `urls.py` so that they do’t need to be specified in the view itself.

## Example:

views.py

    class myDayArchiveView(DayArchiveView):
        month_format = '%m'
        date_field = 'post_date'
        queryset = Person.objects.all()
        context_object_name = 'person'
        paginate_by = 10
        page_kwarg = 'name'

urls.py

    path('day_archive_view/<int:year>/<int:month>/<int:day>/', views.myDayArchiveView.as_view(), name='day_archive_view'),

\<model_name\>\_archiveday.html

    {% extends 'base.html' %}

        <h1>
        {% block title %}
            {{ title }}
        {% endblock %}
        </h1>


    {% block content %}
        <div>
            <ul>
            {% for p in person %}
                <li><a href="{% url 'rango:detail_view' p.first_name %}">{{ p.post_date }}: {{ p.first_name }} {{ p.last_name }}</a></li>
            {% endfor %}
            </ul>
        </div>
        <div class="">
        {% if is_paginated %}
          <ul class="mui-list--inline mui--text-body2">
            {% if page_obj.has_previous %}
              <li><a href="?name={{ page_obj.previous_page_number }}">&laquo;</a></li>
            {% else %}
              <li class="disabled"><span>&laquo;</span></li>
            {% endif %}
            {% for i in paginator.page_range %}
              {% if page_obj.number == i %}
                <li class="active"><span>{{ i }} <span class="sr-only">(current)</span></span></li>
              {% else %}
                <li><a href="?name={{ i }}">{{ i }}</a></li>
              {% endif %}
            {% endfor %}
            {% if page_obj.has_next %}
              <li><a href="?name={{ page_obj.next_page_number }}">&raquo;</a></li>
            {% else %}
              <li class="disabled"><span>&raquo;</span></li>
            {% endif %}
          </ul>
        {% endif %}
        </div>
    {% endblock %}

## Diagram

A visual representation of how `DayArchiveView` is derived can be seen here:

![DayArchiveView](https://yuml.me/diagram/plain;/class/%5BMultipleObjectTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BDayArchiveView%7Bbg:green%7D%5D,%20%5BTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BMultipleObjectTemplateResponseMixin%7Bbg:white%7D%5D,%20%5BBaseDayArchiveView%7Bbg:white%7D%5D%5E-%5BDayArchiveView%7Bbg:green%7D%5D,%20%5BYearMixin%7Bbg:white%7D%5D%5E-%5BBaseDayArchiveView%7Bbg:white%7D%5D,%20%5BMonthMixin%7Bbg:white%7D%5D%5E-%5BBaseDayArchiveView%7Bbg:white%7D%5D,%20%5BDayMixin%7Bbg:white%7D%5D%5E-%5BBaseDayArchiveView%7Bbg:white%7D%5D,%20%5BBaseDateListView%7Bbg:white%7D%5D%5E-%5BBaseDayArchiveView%7Bbg:white%7D%5D,%20%5BMultipleObjectMixin%7Bbg:white%7D%5D%5E-%5BBaseDateListView%7Bbg:white%7D%5D,%20%5BContextMixin%7Bbg:white%7D%5D%5E-%5BMultipleObjectMixin%7Bbg:white%7D%5D,%20%5BDateMixin%7Bbg:white%7D%5D%5E-%5BBaseDateListView%7Bbg:white%7D%5D,%20%5BView%7Bbg:lightblue%7D%5D%5E-%5BBaseDateListView%7Bbg:white%7D%5D.svg)

## Conclusion

If you have date based content a great tool to use and again super easy to implement.

There are other time based CBV for Today, Date, Week, Month, and Year. They all do the same thing (generally) so I won’t review those.
