Title: Converting Writing Examples from doc to markdown: My Process
Date: 2016-10-07 16:21
Author: ryan
Category: Musings
Tags: writing
Slug: converting-writing-examples-from-doc-to-markdown-my-process
Status: published

# Converting Writing Examples from doc to markdown: My Process

All of my writing examples were written while attending the [University of Arizona](http://www.arizona.edu) when I was studying Economics.

These writing examples are from 2004 and were written in either [Microsoft Word](https://en.wikipedia.org/wiki/Microsoft_Word) OR the [OpenOffice Writer](https://en.wikipedia.org/wiki/OpenOffice.org)

Before getting the files onto [Github](https://github.com/miloardot/) I wanted to convert them into [markdown](https://en.wikipedia.org/wiki/Markdown) so that they would be in plain text.

I did this mostly as an exercise to see if I could, but in going through it I'm glad I did. Since the files were written in .doc format, and the [.doc](https://en.wikipedia.org/wiki/Doc_(computing)) format has been replaced with the [.docx](https://en.wikipedia.org/wiki/Office_Open_XML) format it could be that at some point my work would be inaccessible. Now, I don't have to worry about that.

So, how did I get from a .doc file written in 2004 to a converted markdown file created in 2016? Here's how:

## Round 1

1.  Downloaded the Doc files from my Google Drive to my local Desktop and saved them into a folder called `Summaries`
2.  Each week of work had it's own directory, so I had to go into each directory individually (not sure how to do recursive work *yet*)
3.  Each of the files was written in 2004 so I had to change the file types from .doc to .docx. This was accomplished with this command:  
   `textutil -convert docx *.doc`
4.  Once the files were converted from .doc to .docx I ran the following commands:
    1.  `cd ../yyyymmdd` where yyyy = YEAR, mm = Month in 2 digits; dd = day in 2 digits
    2.  `for f in *\ *; do mv "$f" "${f// /_}"; done` [\^1](http://stackoverflow.com/questions/2709458/bash-script-to-replace-spaces-in-file-names)- this would replace the space character with an underscore. this was needed so I could run the next command
    3.  `for file in $(ls *.docx); do pandoc -s -S "${file}" -o "${file%docx}md"; done` [\^2](http://stackoverflow.com/questions/11023543/recursive-directory-parsing-with-pandoc-on-mac) - this uses pandoc to convert the docx file into valid markdown files
    4.  `mv *.md ../` - used to move the .md files into the next directory up
5.  With that done I just needed to move the files from my `Summaries` directory to my `writing-examples` github repo. I'm using the GUI for this so I have a folder on my desktop called `writing-examples`. To move them I just used `mv Summaries/*.md writing-examples/`

So that's it. Nothing **too** fancy, but I wanted to write it down so I can look back on it later and know what the heck I did.

## Round 2

The problem I'm finding is that the bulk conversion using `textutil` isn't keeping the footnotes from the original .doc file. These are important though, as they reference the original work. Ugh!

Used this command [\^5](http://stackoverflow.com/questions/2709458/bash-script-to-replace-spaces-in-file-names) to recursively replace the spaces in the files names with underscores:

`find . -depth -name '* *' \ | while IFS= read -r f ; do mv -i "$f" "$(dirname "$f")/$(basename "$f"|tr ' ' _)" ; done`

Used this command [\^3](http://hints.macworld.com/article.php?story=20060309220909384) to convert all of the .doc to .docx at the same time

`find . -name *.doc -exec textutil -convert docx '{}' \;`

Used this command [\^4](https://gist.github.com/bzerangue/2504041) to generate the markdown files recursively:

`find . -name "*.docx" | while read i; do pandoc -f docx -t markdown "$i" -o "${i%.*}.md"; done;`

Used this command to move the markdown files:

Never figured out what to do here :(

## Round 3

OK, I just gave up on using `textutil` for the conversion. It wasn't keeping the footnotes on the conversion from .doc to .docx.

Instead I used the [Google Drive](https://drive.google.com/) add in [Converter for Google Drive Document](https://www.driveconverter.com). It converted the .doc to .docx **AND** kept the footnotes like I wanted it to.

Of course, it output all of the files to the same directory, so the work I did to get the recursion to work previously can't be applied here **sigh**

Now, the only commands to run from the terminal are the following:

    1. `for f in *\ *; do mv "$f" "${f// /_}"; done` [^1]- this would replace the space character with an underscore. this was needed so I could run the next command
    2. `for file in $(ls *.docx); do pandoc -s -S "${file}" -o "${file%docx}md"; done` [^2] - this uses pandoc to convert the docx file into valid markdown files
    3. `mv *.md <directory/path>`

## Round 4

Like any ~~good~~ ~~bad~~ lazy programer I've opted for a rute force method of converting the `doc` files to `docx` files. I opened each one in Word on macOS and saved as `docx`. Problem solved ¯\_(ツ)\_/¯

Step 1: used the command I found here [\^7](http://stackoverflow.com/questions/2709458/bash-script-to-replace-spaces-in-file-names) to recursively replace the spaces in the files names with underscores `_`

> `find . -depth -name '* *' \`  
> `| while IFS= read -r f ; do mv -i "$f" "$(dirname "$f")/$(basename "$f"|tr ' ' _)" ; done`

Step 2: Use the command found here [\^6](https://gist.github.com/bzerangue/2504041) to generate the markdown files recursively:

`find . -name "*.docx" | while read i; do pandoc -f docx -t markdown "$i" -o "${i%.*}.md"; done;`

Step 3: Add the files to my GitHub repo `graduate-writing-examples`

For this I used the GitHub macOS Desktop App to create a repo in my Documents directory, so it lives in `~/Documents/graduate-writing-examples/`

I then used the finder to locate all of the `md` files in the `Summaries` folder and then dragged them into the repo. There were 2 files with the same name `Rose_Summary` and `Libecap_and_Johnson_Summary`. While I'm sure that I could have figured out how to accomplish this with the command line, this took less than 1 minute, and I had just spent 5 minutes trying to find a terminal command to do it. Again, the lazy programmer wins.

Once the files were in the local repo I committed the files and *boom* they were in my [GitHub Writing Examples](https://github.com/miloardot/graduate-writing-examples) repo.
