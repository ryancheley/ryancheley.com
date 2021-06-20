Title: CBV - RedirectView
Date: 2019-11-10 10:00
Author: ryan
Category: Django
Tags: CBV, class based views, django
Slug: cbv-redirectview
Status: published

From [Classy Class Based View](http://ccbv.co.uk/projects/Django/2.2/django.views.generic.base/RedirectView/) the `RedirectView` will

> > Provide a redirect on any GET request.

It is an extension of `View` and has 5 attributes:

-   http_method_names (from `View`)
-   pattern_name: The name of the URL pattern to redirect to. ^[1](#fn1){#ffn1 .footnote}^ This will be used if no `url` is used.
-   permanent: a flag to determine if the redirect is permanent or not. If set to `True`, then the [HTTP Status Code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#3xx_Redirection) [301](https://en.wikipedia.org/wiki/HTTP_301) is returned. If set to `False` the [302](https://en.wikipedia.org/wiki/HTTP_302) is returned
-   query_string: If `True` then it will pass along the query string from the RedirectView. If it’s `False` it won’t. If this is set to `True` and neither `pattern\_name` nor `url` are set then nothing will be passed to the `RedirectView`
-   url: Where the Redirect should point. It will take precedence over the patter_name so you should only `url` or `patter\_name` but not both. This will need to be an absolute url, not a relative one, otherwise you may get a [404](https://en.wikipedia.org/wiki/HTTP_404) error

The example below will give a `301` status code:

    class myRedirectView(RedirectView):
        pattern_name = 'rango:template_view'
        permanent = True
        query_string = True

While this would be a `302` status code:

    class myRedirectView(RedirectView):
        pattern_name = 'rango:template_view'
        permanent = False
        query_string = True

## Methods

The method `get\_redirect\_url` allows you to perform actions when the redirect is called. From the [Django Docs](https://docs.djangoproject.com/en/2.2/ref/class-based-views/base/#redirectview) the example given is increasing a counter on an Article Read value.

## Diagram

A visual representation of how `RedirectView` derives from `View` ^[2](#fn2){#ffn2 .footnote}^

![](https://yuml.me/diagram/plain;/class/%5BView%7Bbg:lightblue%7D%5D%5E-%5BRedirectView%7Bbg:green%7D%5D.svg)

## Conclusion

In general, given the power of the url mapping in Django I’m not sure why you would need to use a the Redirect View. From [Real Python](https://docs.djangoproject.com/en/2.2/ref/class-based-views/base/#redirectview) they concur, stating:

> > As you can see, the class-based approach does not provide any obvious benefit while adding some hidden complexity. That raises the question: **when should you use RedirectView?**

> > If you want to add a redirect directly in your urls.py, using RedirectView makes sense. But if you find yourself overwriting get*redirect*url, a function-based view might be easier to understand and more flexible for future enhancements.

1.  [From the [Django Docs](https://docs.djangoproject.com/en/2.2/ref/class-based-views/base/) [↩](#ffn1)]{#fn1}
2.  [Original Source from Classy Class Based Views [↩](#ffn2)]{#fn2}
