Title: Logging Part 2
Date: 2022-04-07
Author: ryan
Tags: logging, python
Slug: logging-part-2
Series: Logging
Status: published

In my [previous post](https://www.ryancheley.com/2022/03/30/logging-part-1/) I wrote about inline logging, that is, using logging in the code without a configuration file of some kind.

In this post I'm going to go over setting up a configuration file to support the various different needs you may have for logging.

Previously I mentioned this scenario:

> Perhaps the DevOps team wants robust logging messages on anything `ERROR` and above, but the application team wants to have `INFO` and above in a rotating file name schema, while the QA team needs to have the `DEBUG` and up output to standard out.


Before we get into how we may implement something like what's above, let's review the parts of the Logger which are:

* [formatters](https://docs.python.org/3/library/logging.html#formatter-objects)
* [handlers](https://docs.python.org/3/library/logging.html#handler-objects)
* [loggers](https://docs.python.org/3/library/logging.html#logger-objects)

## Formatters

In a logging configuration file you can have multiple formatters specified. The above example doesn't state WHAT each team need, so let's define it here:

* DevOps: They need to know **when** the error occurred, what the **level** was, and what **module** the error came from
* Application Team: They need to know **when** the error occurred, the **level**, what **module** and **line**
* The QA Team: They need to know when the error occurred, the **level**, what **module** and **line**, and they need a **stack trace**

For the Devops Team we can define a formatter as such[ref]full documentation on what is available for the formatters can be found here: https://docs.python.org/3/library/logging.html#logrecord-attributes[/ref]:

```
'%(asctime)s - %(levelname)s - %(module)s'
```

The Application team would have a formatter like this:

```
'%(asctime)s - %(levelname)s - %(module)s - %(lineno)s'
```

while the QA team would have one like this:

```
'%(asctime)s - %(levelname)s - %(module)s - %(lineno)s'
```

## Handlers

The Handler controls *where* the data from the log is going to be sent. There are several kinds of handlers, but based on our requirements above, we'll only be looking at three of them (see the [documentation](https://docs.python.org/3/howto/logging.html#useful-handlers) for more types of handlers)

From the example above we know that the DevOps team wants to save the output to a file, while the Application Team wants to have the log data saved in a way that allows the log files to not get **too** big. Finally, we know that the QA team wants the output to go directly to `stdout`

We can handle all of these requirements via the handlers. In this case, we'd use

- [FileHandler](https://docs.python.org/3/library/logging.handlers.html#filehandler) for the DevOps team
- [RotatingFileHandler](https://docs.python.org/3/library/logging.handlers.html#rotatingfilehandler) for the Application team
- [StreamHandler](https://docs.python.org/3/library/logging.handlers.html#streamhandler) for the QA team


## Configuration File

Above we defined the formatter and handler. Now we start to put them together. The basic format of a logging configuration has 3 parts (as described above). The example I use below is `YAML`, but a dictionary or a `conf` file would also work.

Below we see five keys in our `YAML` file:

```yaml
version: 1
formatters:
handlers:
loggers:
root:
  level:
  handlers:
```

The `version` key is to allow for future versions in case any are introduced. As of this writing, there is only 1 version ... and it's `version: 1`

### Formatters

We defined the formatters above so let's add them here and give them names that map to the teams

```yaml
version: 1
formatters:
  devops:
    format: '%(asctime)s - %(levelname)s - %(module)s'
  application:
    format: '%(asctime)s - %(levelname)s - %(module)s - %(lineno)s'
  qa:
    format: '%(asctime)s - %(levelname)s - %(module)s - %(lineno)s'
```

Right off the bat we can see that the formatters for `application` and `qa` are the same, so we can either keep them separate to help allow for easier updates in the future (and to be more explicit) OR we can merge them into a single formatter to adhere to `DRY` principals.

I'm choosing to go with option 1 and keep them separate.

### Handlers

Next, we add our handlers. Again, we give them names to map to the team. There are several keys for the handlers that are specific to the type of handler that is used. For each handler we set a level (which will map to the level from the specs above).

Additionally, each handler has keys associated based on the type of handler selected. For example, `logging.FileHandler` needs to have the filename specified, while `logging.StreamHandler` needs to specify where to output to.

When using `logging.handlers.RotatingFileHandler` we have to specify a few more items in addition to a filename so the logger knows how and when to rotate the log writing.

```yaml
version: 1
formatters:
  devops:
    format: '%(asctime)s - %(levelname)s - %(module)s'
  application:
    format: '%(asctime)s - %(levelname)s - %(module)s - %(lineno)s'
  qa:
    format: '%(asctime)s - %(levelname)s - %(module)s - %(lineno)s'
handlers:
  devops:
    class: logging.FileHandler
    level: ERROR
    filename: 'devops.log'
  application:
    class: logging.handlers.RotatingFileHandler
    level: INFO
    filename: 'application.log'
    mode: 'a'
    maxBytes: 10000
    backupCount: 3
  qa:
    class: logging.StreamHandler
    level: DEBUG
    stream: ext://sys.stdout
```

What the setup above does for the `devops` handler is to output the log data to a file called `devops.log`, while the `application` handler outputs to a rotating set of files called `application.log`. For the `application.log` it will hold a maximum of 10,000 bytes. Once the file is 'full' it will create a new file called `application.log.1`, copy the contents of `application.log` and then clear out the contents of `application.log` to start over. It will do this 3 times, giving the application team the following files:

- application.log
- application.log.1
- application.log.2

Finally, the handler for QA will output directly to stdout.

### Loggers

Now we can take all of the work we did above to create the `formatters` and `handlers` and use them in the `loggers`!

Below we see how the loggers are set up in configuration file. It seems a *bit* redundant because I've named my formatters, handlers, and loggers all matching terms, but 🤷‍♂️

The only new thing we see in the configuration below is the new `propagate: no` for each of the loggers. If there were parent loggers (we don't have any) then this would prevent the logging information from being sent 'up' the chain to parent loggers.

The [documentation](https://docs.python.org/3/howto/logging.html#logging-flow) has a good diagram showing the workflow for how the `propagate` works.

Below we can see what the final, fully formed logging configuration looks like.

```yaml
version: 1
formatters:
  devops:
    format: '%(asctime)s - %(levelname)s - %(module)s'
  application:
    format: '%(asctime)s - %(levelname)s - %(module)s - %(lineno)s'
  qa:
    format: '%(asctime)s - %(levelname)s - %(module)s - %(lineno)s'
handlers:
  devops:
    class: logging.FileHandler
    level: ERROR
    filename: 'devops.log'
  application:
    class: logging.handlers.RotatingFileHandler
    level: INFO
    filename: 'application.log'
    mode: 'a'
    maxBytes: 10000
    backupCount: 3
  qa:
    class: logging.StreamHandler
    level: DEBUG
    stream: ext://sys.stdout
loggers:
  devops:
    level: ERROR
    formatter: devops
    handlers: [devops]
    propagate: no
  application:
    level: INFO
    formatter: application
    handlers: [application]
    propagate: no
  qa:
    level: DEBUG
    formatter: qa
    handlers: [qa]
    propagate: no
root:
  level: ERROR
  handlers: [devops, application, qa]
```

In my next post I'll write about how to use the above configuration file to allow the various teams to get the log output they need.
