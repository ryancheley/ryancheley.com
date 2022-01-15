Title: Styling Clean Up with Bash
Date: 2021-10-26 19:23
Tags: css, tailwind, bash
Slug: styling-cleanup
Authors: ryan
Status: published

I have a side project I've been working on for a while now. One thing that happened overtime is that the styling of the site grew organically. I'm not a designer, and I didn't have a master set of templates or design principals guiding the development. I kind of hacked it together and made it look "nice enough"

That was until I really starting going from one page to another and realized that there styling of various pages wasn't just a little off ... but A LOT off.

As an aside, I'm using [tailwind](https://www.tailwind.com) as my CSS Framework

I wanted to make some changes to the styling and realized I had two choices:

1. Manually go through each html template (the project is a Django project) and catalog the styles used for each element

OR

2. Try and write a `bash` command to do it for me

Well, before we jump into either choice, let's see how many templates there are to review!

As I said above, this is a Django project. I keep all of my templates in a single `templates` directory with each app having it's own sub directory.

I was able to use this one line to count the number of `html` files in the templates directory (and all of the sub directories as well)

    ls -R templates | grep html | wc -l

There are 3 parts to this:

1. `ls -R templates` will list out all of the files recursively list subdirectories encountered in the templates directory
2. `grep html` will make sure to only return those files with `html`
3. `wc -l` uses the word, line, character, and byte count to return the number of lines return from the previous command

In each case one command is piped to the next.

This resulted in 41 `html` files.

OK, I'm not going to want to manually review 41 files. Looks like we'll be going with option 2, "Try and write a `bash` command to do it for me"

In the end the `bash` script is actually relatively straight forward. We're just using `grep` two times. But it's the options on `grep` that change (as well as the regex used) that are what make the magic happen

The first thing I want to do is find all of the lines that have the string `class=` in them. Since there are `html` templates, that's a pretty sure fire way to find all of the places where the styles I am interested in are being applied

I use a package called `djhtml` to lint my templates, but just in case something got missed, I want to ignore case when doing my regex, i.e, `class=` should be found, but so should `cLass=` or `Class=`. In order to get that I need to have the `i` flag enabled.

Since the `html` files may be in the base directory `templates` or one of the subdirectories, I need to recursively search, so I include the `r` flag as well

This gets us

    grep -ri "class=" templates/*


That command will output a whole lines like this:

    templates/tasks/steps_lists.html:    <table class="table-fixed w-full border text-center">
    templates/tasks/steps_lists.html:                <th class="w-1/2 flex justify-left-2 p-2">Task</th>
    templates/tasks/steps_lists.html:                <th class="w-1/4 justify-center p-2">Edit</th>
    templates/tasks/steps_lists.html:                <th class="w-1/4 justify-center p-2">Delete</th>
    templates/tasks/steps_lists.html:                    <td class="flex justify-left-2 p-2">
    templates/tasks/steps_lists.html:                    <td class="p-2 text-center">
    templates/tasks/steps_lists.html:                        <a class="block hover:text-gray-600"
    templates/tasks/steps_lists.html:                            <i class="fas fa-edit"></i>
    templates/tasks/steps_lists.html:                    <td class="p-2 text-center">
    templates/tasks/steps_lists.html:                        <a class="block hover:text-gray-600"
    templates/tasks/steps_lists.html:                            <i class="fas fa-trash-alt"></i>
    templates/tasks/step_form.html:        <section class="bg-gray-400 text-center py-2">
    templates/tasks/step_form.html:            <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">{{view.action|default:"Add"}} </button>

Great! We have the data we need, now we just want to clean it up.

Again, we'll use `grep` onl this time we want to look for an honest to goodness regular expression. We're trying to identify everything in between the first open angle brackey (<) and the first closed angle bracket (>)

A bit of googling, searching stack overflow, and playing with the great site [regex101.com](https://regex101.com) gets you this

    <[^\/].*?>

OK, we have the regular expression we need, but what options do we need to use in `grep`? In this case we actually have two options:

1. Use `egrep` (which allos for extended regular expressions)
2. Use `grep -E` to make grep behave like `egrep`

I chose to go with option 2, use `grep -E`. Next, we want to return ONLY the part of the line that matches the regex. For that, we can use the option `o`. Putting it all together we get

    grep -Eo "<[^\/].*?>"

Now, we can pipe the results from our first command into our second command and we get this:

    grep -ri "class=" templates/* | grep -Eo "<[^\/].*?>"

This will output to standard out, but next I really want to use a tool for aggregation and comparison. It was at this point that I decided the best next tool to use would be Excel. So I sent the output to a text file and then opened that text file in Excel to do the final review. To output the above to a text file called `tailwind.txt` we

    grep -ri "class=" templates/* | grep -Eo "<[^\/].*?>" > tailwind.txt

With these results I was able to find several styling inconsistencies and then fix them up. In all it took me a few nights of working out the bash commands and then a few more nights to get the styling consistent. In the process I learned **so** much about `grep` and `egrep`. It was a good exercise to have gone through.
