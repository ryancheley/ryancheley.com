Title: Debugging Setting up a Django Project
Date: 2021-06-13 11:00
Author: ryan
Category: Technology
Tags: Debugging, macOS, python
Slug: debugging-setting-up-a-django-project
Status: published

Normally when I start a new Django project I’ll use the PyCharm setup wizard, but recently I wanted to try out VS Code for a Django project and was super stumped when I would get a message like this:

``` {.wp-block-code}
ERROR:root:code for hash md5 was not found.
Traceback (most recent call last):
  File "/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/hashlib.py", line 147, in <module>
    globals()[__func_name] = __get_hash(__func_name)
  File "/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/hashlib.py", line 97, in __get_builtin_constructor
    raise ValueError('unsupported hash type ' + name)
ValueError: unsupported hash type md5
ERROR:root:code for hash sha1 was not found.
Traceback (most recent call last):
  File "/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/hashlib.py", line 147, in <module>
    globals()[__func_name] = __get_hash(__func_name)
  File "/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/hashlib.py", line 97, in __get_builtin_constructor
    raise ValueError('unsupported hash type ' + name)
ValueError: unsupported hash type sha1
ERROR:root:code for hash sha224 was not found.
Traceback (most recent call last):
  File "/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/hashlib.py", line 147, in <module>
    globals()[__func_name] = __get_hash(__func_name)
  File "/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/hashlib.py", line 97, in __get_builtin_constructor
    raise ValueError('unsupported hash type ' + name)
ValueError: unsupported hash type sha224
ERROR:root:code for hash sha256 was not found.
Traceback (most recent call last):
  File "/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/hashlib.py", line 147, in <module>
    globals()[__func_name] = __get_hash(__func_name)
  File "/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/hashlib.py", line 97, in __get_builtin_constructor
    raise ValueError('unsupported hash type ' + name)
ValueError: unsupported hash type sha256
ERROR:root:code for hash sha384 was not found.
Traceback (most recent call last):
  File "/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/hashlib.py", line 147, in <module>
    globals()[__func_name] = __get_hash(__func_name)
  File "/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/hashlib.py", line 97, in __get_builtin_constructor
    raise ValueError('unsupported hash type ' + name)
ValueError: unsupported hash type sha384
ERROR:root:code for hash sha512 was not found.
Traceback (most recent call last):
  File "/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/hashlib.py", line 147, in <module>
    globals()[__func_name] = __get_hash(__func_name)
  File "/usr/local/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/hashlib.py", line 97, in __get_builtin_constructor
    raise ValueError('unsupported hash type ' + name)
ValueError: unsupported hash type sha512
```

Here are the steps I was using to get started

From a directory I wanted to create the project I would set up my virtual environment

``` {.wp-block-code}
python3 -m venv venv
```

And then activate it

``` {.wp-block-code}
source venv/bin/activate
```

Next, I would install Django

``` {.wp-block-code}
pip install django
```

Next, using the `startproject` command per the [docs](https://docs.djangoproject.com/en/3.2/ref/django-admin/#startproject "Start a new Django Project") I would

``` {.wp-block-code}
django-admin startproject my_great_project .
```

And get the error message above 🤦🏻‍♂️

The strangest part about the error message is that it references Python2.7 everywhere … which is odd because I’m in a Python3 virtual environment.

I did a `pip list` and got:

``` {.wp-block-code}
Package    Version
---------- -------
asgiref    3.3.4
Django     3.2.4
pip        21.1.2
pytz       2021.1
setuptools 49.2.1
sqlparse   0.4.1
```

OK … so everything is in my virtual environment. Let’s drop into the REPL and see what’s going on

![](/images/uploads/2021/06/Screen-Shot-2021-06-13-at-7.52.36-AM.png){.wp-image-506}

Well, that looks to be OK.

Next, I checked the contents of my directory using `tree -L 2`

``` {.wp-block-code}
├── manage.py
├── my_great_project
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
└── venv
    ├── bin
    ├── include
    ├── lib
    └── pyvenv.cfg
```

Yep … that looks good too.

OK, let’s go look at the installed packages for Python 2.7 then. On macOS they’re installed at

``` {.wp-block-code}
/usr/local/lib/python2.7/site-packages
```

Looking in there and I see that Django is installed.

OK, let’s use pip to uninstall Django from Python2.7, except that `pip` gives essentially the same result as running the `django-admin` command.

OK, let’s just remove it manually. After a bit of googling I found this [Stackoverflow](https://stackoverflow.com/a/8146552) answer on how to remove the offending package (which is what I assumed would be the answer, but better to check, right?)

After removing the `Django` install from Python 2.7 and running `django-admin --version` I get

![](/images/uploads/2021/06/Screen-Shot-2021-06-13-at-8.05.55-AM.png){.wp-image-507}

So I googled that error message and found another answers on [Stackoverflow](https://stackoverflow.com/a/10756446) which lead me to look at the `manage.py` file. When I `cat` the file I get:

``` {.wp-block-code}
#!/usr/bin/env python
import os
import sys

...
```

That first line SHOULD be finding the Python executable in my virtual environment, but it’s not.

Next I googled the error message `django-admin code for hash sha384 was not found `

Which lead to this [Stackoverflow](https://stackoverflow.com/a/60575879) answer. I checked to see if Python2 was installed with brew using

``` {.wp-block-code}
brew leaves | grep python
```

which returned `python@2`

Based on the answer above, the solution was to uninstall the Python2 that was installed by `brew`. Now, although [Python2 has retired](https://www.python.org/doc/sunset-python-2/), I was leery of uninstalling it on my system without first verifying that I could remove the brew version without impacting the system version which is needed by macOS.

Using `brew info python@2 ` I determined where `brew` installed Python2 and compared it to where Python2 is installed by macOS and they are indeed different

Output of `brew info python@2`

``` {.wp-block-code}
...
/usr/local/Cellar/python@2/2.7.15_1 (7,515 files, 122.4MB) *
  Built from source on 2018-08-05 at 15:18:23
...
```

Output of `which python`

`/usr/bin/python`

OK, now we can remove the version of Python2 installed by `brew`

``` {.wp-block-code}
brew uninstall python@2
```

Now with all of that cleaned up, lets try again. From a clean project directory:

``` {.wp-block-code}
python3 -m venv venv
source venv/bin/activate
pip install django
django-admin --version
```

The last command returned

``` {.wp-block-code}
zsh: /usr/local/bin/django-admin: bad interpreter: /usr/local/opt/python@2/bin/python2.7: no such file or directory
3.2.4
```

OK, I can get the version number and it mostly works, but can I create a new project?

``` {.wp-block-code}
django-admin startproject my_great_project .
```

Which returns

``` {.wp-block-code}
zsh: /usr/local/bin/django-admin: bad interpreter: /usr/local/opt/python@2/bin/python2.7: no such file or directory
```

BUT, the project was installed

``` {.wp-block-code}
├── db.sqlite3
├── manage.py
├── my_great_project
│   ├── __init__.py
│   ├── __pycache__
│   ├── asgi.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
└── venv
    ├── bin
    ├── include
    ├── lib
    └── pyvenv.cfg
```

And I was able to run it

``` {.wp-block-code}
python manage.py runserver
```

![](/images/uploads/2021/06/Screen-Shot-2021-06-13-at-9.01.19-AM.png){.wp-image-508}

Success! I’ve still got that last bug to deal with, but that’s a story for a different day!

## Short Note

My initial fix, and my initial draft for this article, was to use the old adage, turn it off and turn it back on. In this case, the implementation would be the `deactivate` and then re `activate` the virtual environment and that’s what I’d been doing.

As I was writing up this article I was hugely influenced by the work of [Julie Evans](https://twitter.com/b0rk) and kept asking, “but why?”. She’s been writing a lot of awesome, amazing things, and has several [zines for purchase](https://wizardzines.com) that I would highly recommend.

She’s also generated a few [debugging ‘games’](https://jvns.ca/blog/2021/04/16/notes-on-debugging-puzzles/) that are a lot of fun.

Anyway, thanks Julie for pushing me to figure out the why for this issue.

## Post Script

I figured out the error message above and figured, well, I might as well update the post! I thought it had to do with `zsh`, but no, it was just more of the same.

The issue was that Django had been installed in the base Python2 (which I knew). All I had to do was to uninstall it with pip.

``` {.wp-block-code}
pip uninstall django
```

The trick was that pip wasn't working out for me ... it was generating errors. So I had to run the command

``` {.wp-block-code}
python -m pip uninstall django
```

I had to run this AFTER I put the Django folder back into `/usr/local/lib/python2.7/site-packages` (if you'll recall from above, I removed it from the folder)

After that clean up was done, everything worked out as expected! I just had to keep digging!
