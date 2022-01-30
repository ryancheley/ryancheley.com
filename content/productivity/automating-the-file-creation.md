Title: Automating the file creation
Date: 2022-02-02
Author: ryan
Tags: automation, makefile
Slug: automating-the-file-creation
Series: Remove if Not Needed
Status: draft

In my last post [Auto Generating the Commit Message](https://www.ryancheley.com/2022/01/28/auto-generating-the-commit-message/) I indicated that this post I would "throw it all together and to get a spot when I can run one make command that will do all of this for me".

I decided to take a brief detour though as I realized I didn't have a good way to create a new post, i.e. the starting point wasn't automated!

In this post I'm going to go over how I create the start to a new post using `Makefile` and the command `make newpost`

My initial idea was to create a new bash script (similar to the `tweet.sh` file), but as a first iteration I went in a different direction based on this post [How to Slugify Strings in Bash](https://blog.codeselfstudy.com/blog/how-to-slugify-strings-in-bash/).

The command that the is finally arrived at in the post above was

```
newpost:
	vim +':r templates/post.md' $(BASEDIR)/content/blog/$$(date +%Y-%m-%d)-$$(echo -n $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
```

which was **really** close to what I needed. My static site is set up a bit differently and I'm not using `vim` (I'm using VS Code) to write my words.

The first change I needed to make was to remove the use of `vim` from the command and instead use `touch` to create the file

```
newpost:
	touch $(BASEDIR)/content/blog/$$(date +%Y-%m-%d)-$$(echo -n $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
```

The second was to change the file path for where to create the file. As I've indicated previously, the structure of my content looks like this:

```
content
├── musings
├── pages
├── productivity
├── professional\ development
└── technology
```

giving me an updated version of the command that looks like this:

```
touch content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
```

Now when I run the command `make newpost title='Automating the file creation' category='productivity'` I get a empty new files created. Now I just need to populate it with the data.

There are seven bits of meta data that need to be added, but four of them are the same for each post

```
Author: ryan
Tags:
Series: Remove if Not Needed
Status: draft
```

That allows me to have the `newpost` command look like this:

```

newpost:
	touch content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Author: ryan" >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Tags: " >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Series: Remove if Not Needed"  >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Status: draft"  >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
```

The remaining metadata to be added are:

- Title:
- Date
- Slug

Of these, `Date` and `Title` is the most straightforward.

`bash` has a command called `date` that can be formatted in the way I want with `%F`. Using this I can get the date like this

```
echo "Date: $$(date +%F)" >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
```

For `Title` I can take the input parameter `title` like this:

```
echo "Title: $${title}" > content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
```

`Slug` is just `Title` but *slugified*. Trying to figure out how to do this is how I found the [article](https://blog.codeselfstudy.com/blog/how-to-slugify-strings-in-bash/) above.

Using a slightly modified version of the code that generates the file, we get this:

```
printf "Slug: " >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
echo "$${title}" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
```

One thing to notice here is that `printf`. I needed/wanted to `echo -n` but `make` didn't seem to like that. [This StackOverflow answer](https://stackoverflow.com/a/14121245) helped me to get a fix (using `printf`) though I'm sure there's a way I can get it to work with `echo -n`.

Essentially, since this was a first pass, and I'm pretty sure I'm going to end up re-writing this as a shell script I didn't want to spend **too** much time getting a perfect answer here.

OK, with all of that, here's the entire `newpost` recipe I'm using now:

```
newpost:
	touch content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Title: $${title}" > content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Date: $$(date +%F)" >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Author: ryan" >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Tags: " >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	printf "Slug: " >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "$${title}" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Series: Remove if Not Needed"  >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Status: draft"  >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
```

This allows me to type `make newpost` and generate a new file for me to start my new post in![ref]This is an issue with the code above when generating the slug. I want the slug to be all lower case, but there's nothing in the code that does that. That's a project for another day![/ref]
