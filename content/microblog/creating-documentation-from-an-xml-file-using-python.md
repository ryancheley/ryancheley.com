Title: Creating Documentation from an XML file using Python
Date: 2025-02-13
Author: ryan
Tags:
Slug: creating-documentation-from-an-xml-file-using-python
Status: published

This will be one of those frustrating blog posts where I'll wave my hands about the code that I wrote but not actually be able to post it because I did it for work.

A very specific (to my department) challenge we have is that we use a tool called [Crush FTP](https://www.crushftp.com/index.html) to automate several things. This automation is mostly around file movement, and file renaming. Because this tool has permissions which are higher than my team and I, we have to work with our IT team in order to set up various jobs. The IT team is always really responsive when we need to make a change, or check on something, but I really wanted to have an ability to be able to have my own documentation to be able to answer questions about the jobs.

I recently discovered that each job can be exported out as an XML file, and while XML has a very 'thar be dragons' vibe to it, these XML files were **mostly** fine. I say mostly because there is a node called <emailBody> that has all manner of problematic text in it that causes all sorts of parsing failures. To 'fix' this I simply remove the content from that node and replace it with placeholder text (for now).

The final product will output plain text with details about each job, each task in that job, and then a mermaid diagram of the flow at the bottom.

This is pretty much everything that my team and I need to have the documentation to answer questions.

Some future improvements I'd like to implement are:

1. Automation of the XML file generation from the Crush FTP application
2. Automatic writing of the documentation to our Knowledge Management System[ref]We use [YouTrack](https://www.jetbrains.com/youtrack/) which is a really good Jira / Confluence replacement if you're looking for one[/ref]
3. Write the data to a SQLite database so I can leverage [datasette](https://datasette.io/) to help clean up names, and various attributes of the tasks and jobs
