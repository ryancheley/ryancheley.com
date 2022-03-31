Title: Logging Part 1
Date: 2022-03-30
Author: ryan
Tags: logging, python
Slug: logging-part-1
Series: Logging
Status: published

# Logging

Last year I worked on an update to the package [tryceratops](https://pypi.org/project/tryceratops/) with [Gui Latrova](https://twitter.com/guilatrova) to include a verbose flag for logging.

Honestly, Gui was a huge help and I wrote about my experience [here]([link](https://www.ryancheley.com/2021/08/07/contributing-to-tryceratops/)) but I didn't really understand why what I did worked.

Recently I decided that I wanted to better understand logging so I dove into some posts from Gui, and sat down and read the documentation on the logging from the standard library.

My goal with this was to (1) be able to use logging in my projects, and (2) write something that may be able to help others.

Full disclosure, Gui has a **really** [good article explaining logging](https://guicommits.com/how-to-log-in-python-like-a-pro/) and I think everyone should read it. My notes below are a synthesis of his article, my understanding of the [documentation from the standard library](https://docs.python.org/3/library/logging.html), and the [Python HowTo](https://docs.python.org/3/howto/logging.html) written in a way to answer the [Five W questions](https://www.education.com/game/five-ws-song/) I was taught in grade school.

## The Five W's

**Who are the generated logs for?**

Anyone trying to troubleshoot an issue, or monitor the history of actions that have been logged in an application.

**What is written to the log?**

The [formatter](https://docs.python.org/3/library/logging.html#formatter-objects) determines what to display or store.

**When is data written to the log?**

The [logging level](https://docs.python.org/3/library/logging.html#logging-levels) determines when to log the issue.

**Where is the log data sent to?**

The [handler](https://docs.python.org/3/library/logging.html#handler-objects) determines where to send the log data whether that's a file, or stdout.

**Why would I want to use logging?**

To keep a history of actions taken during your code.

**How is the data sent to the log?**

The [loggers](https://docs.python.org/3/library/logging.html#logger-objects) determine how to bundle all of it together through calls to various methods.

## Examples

Let's say I want a logger called `my_app_errors` that captures all ERROR level incidents and higher to a file and to tell me the date time, level, message, logger name, and give a trace back of the error, I could do the following:

```
import logging

message='oh no! an error occurred'
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s - %(name)s')
logger = logging.getLogger('my_app_errors')
fh = logging.FileHandler('errors.log')
fh.setFormatter(formatter)
logger.addHandler(fh)
logger.error(message, stack_info=True)
```

The code above would generate something like this to a file called `errors.log`

```
2022-03-28 19:45:49,188 - ERROR - oh no! an error occurred - my_app_errors
Stack (most recent call last):
  File "/Users/ryan/Documents/github/logging/test.py", line 9, in <module>
    logger.error(message, stack_info=True)
```

If I want a logger that will do all of the above AND output debug information to the console I could:

```
import logging

message='oh no! an error occurred'

logger = logging.getLogger('my_app_errors')

ch = logging.StreamHandler()
fh = logging.FileHandler('errors.log')

formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s - %(name)s')

fh.setFormatter(formatter)
ch.setFormatter(formatter)

logger.addHandler(fh)
logger.addHandler(ch)

logger.error(message, stack_info=True)
logger.debug(message, stack_info=True)
```

Again, the code above would generate something like this to a file called `errors.log`

```
2022-03-28 19:45:09,406 - ERROR - oh no! an error occurred - my_app_errors
Stack (most recent call last):
  File "/Users/ryan/Documents/github/logging/test.py", line 18, in <module>
    logger.error(message, stack_info=True)
```

but it would also output to stderr in the terminal something like this:

```
2022-03-27 13:18:45,367 - ERROR - oh no! an error occurred - my_app_errors
Stack (most recent call last):
  File "<stdin>", line 1, in <module>
```

The above it a bit hard to scale though. What happens when we want to have multiple formatters, for different levels that get output to different places? We can incorporate all of that into something like what we see above, OR, we can stat to leverage the use of logging configuration files.

Why would we want to have multiple formatters? Perhaps the DevOps team wants robust logging messages on anything `ERROR` and above, but the application team wants to have `INFO` and above in a rotating file name schema, while the QA team needs to have the `DEBUG` and up output to standard out.

You CAN do all of this inline with the code above, but would you **really** want to? Probably not.

Enter configuration files to allow easier management of log files (and a potential way to make everyone happy) which I'll cover in the next post.
