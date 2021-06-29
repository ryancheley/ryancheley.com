Title: CBV - View
Date: 2019-10-27 10:00
Author: ryan
Category: Technology
Tags: CBV, class based views, django
Slug: cbv-view
Status: published

`View` is the ancestor of ALL Django CBV. From the great site [Classy Class Based Views](http://ccbv.co.uk), they are described as

> > Intentionally simple parent class for all views. Only implements dispatch-by-method and simple sanity checking.

This is no joke. The `View` class has almost nothing to it, but it’s a solid foundation for everything else that will be done.

Its implementation has just one attribute `http_method_names` which is a list that allows you to specify what http verbs are allowed.

Other than that, there’s really not much to it. You just write a simple method, something like this:

    def get(self, _):
        return HttpResponse('My Content')

All that gets returned to the page is a simple HTML. You can specify the `content_type` if you just want to return JSON or plain text but defining the content_type like this:

    def get(self, _):
        return HttpResponse('My Content', content_type='text plain')

You can also make the text that is displayed be based on a variable defined in the class.

First, you need to define the variable

    content = 'This is a {View} template and is not used for much of anything but '   
                 'allowing extensions of it for other Views'

And then you can do something like this:

    def get(self, _):
        return HttpResponse(self.content, content_type='text/plain')

Also, as mentioned above you can specify the allowable methods via the attribute `http_method_names`.

The following HTTP methods are allowed:

-   get
-   post
-   put
-   patch
-   delete
-   head
-   options
-   trace

By default all are allowed.

If we put all of the pieces together we can see that a really simple `View` CBV would look something like this:

    class myView(View):
        content = 'This is a {View} template and is not used for much of anything but '   
                 'allowing extensions of it for other Views'
        http_method_names = ['get']

        def get(self, _):
            return HttpResponse(self.content, content_type='text/plain')

This `View` will return `content` to the page rendered as plain text. This CBV is also limited to only allowing `get` requests.

Here’s what it looks like in the browser:

![](/images/uploads/2019/10/F817D382-9A10-45C6-B30A-D66AAD942F80_4_5005_c.jpeg){.alignnone .size-full .wp-image-374 width="952" height="320"}

## Conclusion

`View` doesn’t do much, but it’s the case for everything else, so understanding it is going to be important.
