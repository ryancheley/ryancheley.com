Title: CBV - FormView
Date: 2019-12-04 10:00
Author: ryan
Tags: CBV, class based views, django
Slug: cbv-formview
Status: published

From [Classy Class Based Views](http://ccbv.co.uk/projects/Django/2.2/django.views.generic.edit/FormView/) `FormView`

> > A view for displaying a form and rendering a template response.

## Attributes

The only new attribute to review this time is `form_class`. That being said, there are a few implementation details to cover

-   form_class: takes a Form class and is used to render the form on the `html` template later on.

## Methods

Up to this point we haven’t really needed to override a method to get any of the views to work. This time though, we need someway for the view to verify that the data is valid and then save it somewhere.

-   form_valid: used to verify that the data entered is valid and then saves to the database. Without this method your form doesn’t do anything

## Example

This example is a bit more than previous examples. A new file called `forms.py` is used to define the form that will be used.

forms.py

    from django.forms import ModelForm
    from rango.models import Person


    class PersonForm(ModelForm):
        class Meta:
            model = Person
            exclude = [
                'post_date',
            ]

views.py

    class myFormView(FormView):
        form_class = PersonForm
        template_name = 'rango/person_form.html'
        extra_context = {
            'type': 'Form'
        }
        success_url = reverse_lazy('rango:list_view')

        def form_valid(self, form):
            person = Person.objects.create(
                first_name=form.cleaned_data['first_name'],
                last_name=form.cleaned_data['last_name'],
                post_date=datetime.now(),
            )
            return super(myFormView, self).form_valid(form)

urls.py

    path('form_view/', views.myFormView.as_view(), name='form_view'),

\<template_name\>.html

        <h3>{{ type }} View</h3>
        {% if type != 'Update' %}
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

## Diagram

A visual representation of how `FormView` is derived can be seen here:

![](https://yuml.me/diagram/plain;/class/%5BTemplateResponseMixin%7Bbg:white%7D%5D%5E-%5BFormView%7Bbg:green%7D%5D,%20%5BBaseFormView%7Bbg:white%7D%5D%5E-%5BFormView%7Bbg:green%7D%5D,%20%5BFormMixin%7Bbg:white%7D%5D%5E-%5BBaseFormView%7Bbg:white%7D%5D,%20%5BContextMixin%7Bbg:white%7D%5D%5E-%5BFormMixin%7Bbg:white%7D%5D,%20%5BProcessFormView%7Bbg:white%7D%5D%5E-%5BBaseFormView%7Bbg:white%7D%5D,%20%5BView%7Bbg:lightblue%7D%5D%5E-%5BProcessFormView%7Bbg:white%7D%5D.svg)

## Conclusion

I really struggled with understanding *why* you would want to implement `FormView`. I found this explanation on [Agiliq](https://www.agiliq.com/blog/2019/01/django-formview/) and it helped me grok the why:

> > FormView should be used when you need a form on the page and want to perform certain action when a valid form is submitted. eg: Having a contact us form and sending an email on form submission.
> >
> > CreateView would probably be a better choice if you want to insert a model instance in database on form submission.

While my example above works, it’s not the intended use of `FormView`. Really, it’s just an implementation of `CreateView` using `FormView`
