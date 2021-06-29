Title: Writing tests for Django Admin Custom Functionality
Date: 2021-01-27 12:00
Author: ryan
Category: Technology
Tags: admin, tests
Slug: writing-tests-for-django-admin-custom-functionality
Status: published

I’ve been working on a Django app side project for a while and came across the need to write a custom filter for the Django Admin section.

This was a first for me, and it was pretty straight forward to accomplish the task. I wanted to add a filter on the drop down list so that only certain records would appear.

To do this, I sub-classed the Django Admin `SimpleListFilter` with the following code:

``` {.wp-block-code}
class EmployeeListFilter(admin.SimpleListFilter):
    title = "Employee"
    parameter_name = "employee"

    def lookups(self, request, model_admin):
        employees = []
        qs = Employee.objects.filter(status__status="Active").order_by("first_name", "last_name")
        for employee in qs:
            employees.append((employee.pk, f"{employee.first_name} {employee.last_name}"))
        return employees

    def queryset(self, request, queryset):
        if self.value():
            qs = queryset.filter(employee__id=self.value())
        else:
            qs = queryset
        return qs
```

And implemented it like this:

``` {.wp-block-code}
@admin.register(EmployeeO3Note)
class EmployeeO3NoteAdmin(admin.ModelAdmin):
    list_filter = (EmployeeListFilter, "o3_date")
```

This was, as I said, relatively straight forward to do, but what was less clear to me was how to write tests for this functionality. My project has 100% test coverage, and therefore testing isn’t something I’m unfamiliar with, but in this context, I wasn’t sure where to start.

There are two parts that need to be tested:

1.  `lookups`
2.  `queryset `  

Additionally, the `queryset `has two states that need to be tested

1.  With `self.value()`
2.  Without `self.value()`  

This gives a total of 3 tests to write

The thing that helps me out the most when trying to determine how to write tests is to use the Django Shell in PyCharm. To do this I:

1.  Import necessary parts of Django App
2.  Instantiate the `EmployeeListFilter`
3.  See what errors I get
4.  Google how to fix the errors
5.  Repeat  

This is what the test ended up looking like:

``` {.wp-block-code}
import pytest

from employees.models import EmployeeO3Note
from employees.tests.factories import EmployeeFactory, EmployeeO3NoteFactory, EmployeeStatusFactory
from employees.admin import EmployeeListFilter


ACTIVE_EMPLOYEES = 3
TERMED_EMPLOYEES = 1


@pytest.fixture
def active_employees():
    return EmployeeFactory.create_batch(ACTIVE_EMPLOYEES)


@pytest.fixture
def termed_employees():
    termed_employees = TERMED_EMPLOYEES
    termed = EmployeeStatusFactory(status="Termed")
    return EmployeeFactory.create_batch(termed_employees, status=termed)


@pytest.fixture
def o3_notes_for_all_employees(active_employees, termed_employees):
    all_employees = active_employees + termed_employees
    o3_notes = []
    for i in range(len(all_employees)):
        o3_notes.append(EmployeeO3NoteFactory.create_batch(1, employee=all_employees[i]))
    return o3_notes


@pytest.mark.django_db
def test_admin_filter_active_employee_o3_notes(active_employees):
    employee_list_filter = EmployeeListFilter(request=None, params={}, model=None, model_admin=None)
    assert len(employee_list_filter.lookup_choices) == ACTIVE_EMPLOYEES


@pytest.mark.django_db
def test_admin_query_set_unfiltered_results_o3_notes(o3_notes_for_all_employees):
    total_employees = ACTIVE_EMPLOYEES + TERMED_EMPLOYEES
    employee_list_filter = EmployeeListFilter(request=None, params={}, model=None, model_admin=None)
    assert len(employee_list_filter.queryset(request=None, queryset=EmployeeO3Note.objects.all())) == total_employees


@pytest.mark.django_db
def test_admin_query_set_filtered_results_o3_notes(active_employees, o3_notes_for_all_employees):
    employee_to_test = active_employees[0]
    employee_list_filter = EmployeeListFilter(
        request=None, params={"employee": employee_to_test.pk}, model=None, model_admin=None
    )
    queryset_to_test = employee_list_filter.queryset(request=None, queryset=EmployeeO3Note.objects.all())
    assert len(queryset_to_test.filter(employee__id=employee_to_test.pk)) == 1
```
