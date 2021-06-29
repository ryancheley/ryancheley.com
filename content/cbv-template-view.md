Title: CBV - Template View
Date: 2019-11-03 10:00
Author: ryan
Category: Technology
Tags: CBV, class based views, django
Slug: cbv-template-view
Status: published

From [Classy Class Based Views](http://ccbv.co.uk/projects/Django/2.2/django.views.generic.base/TemplateView/) the `TemplateView` will

> > Render a template. Pass keyword arguments from the URLconf to the context.

It is an extended version of the `View` CBV with the the `ContextMixin` and the `TemplateResponseMixin` added to it.

It has several attributes that can be set

-   content_type: will allow you to define the MIME type that the page will return. The default is `DEFAULT\_CONTENT\_TYPE` but can be overridden with this attribute.
-   extra_context: this can be used as a keyword argument in the `as\_view()` but not in the class of the CBV. Adding it there will do nothing
-   http_method_name: derived from `View` and has the same definition
-   response_classes: The response class to be returned by render_to_response method it defaults to a TemplateResponse. See below for further discussion
-   template_engine: can be used to specify which template engine to use IF you have configured the use of multiple template engines in your `settings.py` file. See the [Usage](https://docs.djangoproject.com/en/2.2/topics/templates/#usage) section of the Django Documentation on Templates
-   template_name: this attribute is required IF the method `get\_template\_names()` is not used.

## More on `response_class`

This confuses the ever living crap out of me. The best (only) explanation I have found is by GitHub user `spapas` in his article [Django non-HTML responses](https://spapas.github.io/2014/09/15/django-non-html-responses/#rendering-to-non-html):

> > From the previous discussion we can conclude that if your non-HTML response needs a template then you just need to create a subclass of TemplateResponse and assign it to the response*class attribute (and also change the content*type attribute). On the other hand, if your non-HTML respond does not need a template to be rendered then you have to override render*to*response completely (since the template parameter does not need to be passed now) and either define a subclass of HttpResponse or do the rendering in the render*to*response.

Basically, if you ever want to use a non-HTML template you’d set this attribute, but it seems available mostly as a ‘just-in-case’ and not something that’s used every day.

My advise … just leave it as is.

## When to use the `get` method

An answer which makes sense to me that I found on [StackOverflow](https://stackoverflow.com/questions/35824904/django-view-get-context-data-vs-get) was (slightly modified to make it more understandable)

> > if you need to have data available every time, use get_context_data(). If you need the data only for a specific request method (eg. in get), then put it in get.

## When to use the `get_template_name` method

This method allows you to easily change a template being used based on values passed through GET.

This can be helpful if you want to have one template for a super user and another template for a basic user. This helps to keep business logic out of the template and in the view where it belongs.

This can also be useful if you want to specify several possible templates to use. A list is passed and Django will work through that list from the first element to the last until it finds a template that exists and render it.

If you don’t specify template_name you have to use this method.

## When to use the `get_context_data` method

See above in the section When to use the `get` method

## Diagram

A visual representation of how `TemplateView` derives from `View` ^[1](#fn1){#ffn1 .footnote}^

![](https://yuml.me/diagram/plain;/class/%5BTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BTemplateView%7Bbg:green%7D%5D,%20%5BContextMixin%7Bbg:white%7D%5D%5E-%5BTemplateView%7Bbg:green%7D%5D,%20%5BView%7Bbg:lightblue%7D%5D%5E-%5BTemplateView%7Bbg:green%7D%5D.svg)

## Conclusion

If you want to roll your own CBV because you have a super specific use case, starting at the `TemplateView` is going to be a good place to start. However, you may find that there is already a view that is going to do what you need it to. Writing your own custom implementation of `TemplateView` may be a waste of time **IF** you haven’t already verified that what you need isn’t already there.

1.  [Original Source from Classy Class Based Views [↩](#ffn1)]{#fn1}
