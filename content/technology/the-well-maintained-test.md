Title: The Well Maintained Test
Date: 2021-11-22 19:57
Tags: Python, python package
Slug: the-well-maintained-test
Authors: ryan
Status: published

At the beginning of November Adam Johnson [tweeted](https://twitter.com/AdamChainz/status/1456347321415917569) 

>  I’ve come up with a test that we can use to decide whether a new package we’re considering depending on is well-maintained.

and linked to an article he [wrote](https://adamj.eu/tech/2021/11/04/the-well-maintained-test/). 

He came up ([with the help of Twitter](https://twitter.com/AdamChainz/status/1454041660879421442)) twelve questions to ask of any library that you're looking at:

1. Is it described as “production ready”?
2. Is there sufficient documentation?
3. Is there a changelog?
4. Is someone responding to bug reports?
5. Are there sufficient tests?
6. Are the tests running with the latest <Language\> version?
7. Are the tests running with the latest <Integration\> version?
8. Is there a Continuous Integration (CI) configuration?
9. Is the CI passing?
10. Does it seem relatively well used?
11. Has there been a commit in the last year?
12. Has there been a release in the last year?

I thought it would be interesting to turn that checklist into a Click App using [Simon Willison's Click App Cookiecutter](https://github.com/simonw/click-app). 

I set out in earnest to do just that on [November 8th](https://github.com/ryancheley/the-well-maintained-test/commit/94e8028e4d3a817ab0b26168b4285231de6f141c). 

What started out as just a simple Click app, quickly turned in a pretty robust CLI using [Will McGugan](https://twitter.com/willmcgugan)'s [Rich](https://github.com/willmcgugan/rich) library. 

I started by using the GitHub API to try and answer the questions, but quickly found that it couldn't answer them all. Then I cam across the PyPI API which helped to answer almost all of them programatically. 

There's still a [bit of work](https://github.com/ryancheley/the-well-maintained-test/issues) to do to get it where I want it to, but it's pretty sweet that I can now run a simple command and review the output to see if the package is well maintained. 

You can even try it on the package I wrote!

    the-well-maintained-test https://github.com/ryancheley/the-well-maintained-test

Which will return (as of this writing) the output below:

    1. Is it described as 'production ready'?
            The project is set to Development Status Beta
    2. Is there sufficient documentation?
            Documentation can be found at 
    https://github.com/ryancheley/the-well-maintained-test/blob/main/README.md
    3. Is there a changelog?
            Yes
    4. Is someone responding to bug reports?
            The maintainer took 0 days to respond to the bug report
            It has been 2 days since a comment was made on the bug.
    5. Are there sufficient tests? [y/n]: y
            Yes
    6. Are the tests running with the latest Language version?
            The project supports the following programming languages
                    - Python 3.7
                    - Python 3.8
                    - Python 3.9
                    - Python 3.10

    7. Are the tests running with the latest Integration version?
            This project has no associated frameworks
    8. Is there a Continuous Integration (CI) configuration?
            There are 2 workflows
             - Publish Python Package
             - Test

    9. Is the CI passing?
            Yes
    10.  Does it seem relatively well used?
            The project has the following statistics:
            - Watchers: 0
            - Forks: 0
            - Open Issues: 1
            - Subscribers: 1
    11.  Has there been a commit in the last year?
            Yes. The last commit was on 11-20-2021 which was 2 days ago
    12. Has there been a release in the last year?
            Yes. The last commit was on 11-20-2021 which was 2 days ago

There is still one question that I haven't been able to answer programmatically  with an API and that is:

    Are there sufficient tests?

When that question comes up, you're prompted in the terminal to answer either `y/n`. 

But, it does leave room for a fix by someone else! 