Title: Django-Commons
Date: 2024-10-22
Author: ryan
Tags: django, oss, django-commons
Slug: django-commons
Status: draft

First, what are 'the commons'? The concept of "the commons" refers to resources that are shared and managed collectively by a community, rather than being owned privately or by the state. This idea has been applied to natural resources like air, water, and grazing land, but it has also expanded to include digital and cultural resources, such as open-source software, knowledge databases, and creative works.

One of the big aspects of this concept that we as the maintainers are really trying to lean into is "Sustainability and Stewardship"

Our hope is that providing these commons we'll be able to help various maintainers keep their projects going, even if they've decided to step away.

Asking for help is hard, but it can be easier if done in a safe environment. As we saw with the [xz utils backdoor](https://en.wikipedia.org/wiki/XZ_Utils_backdoor) attack, maintainer burnout is real. And while there are several arguments about being part of a 'supply chain' if we can, as a community, offer up a place where maintainers can work toghether for the sustainability and support of their packages, the better off the Django community will be!

From the [README](https://github.com/django-commons/membership/blob/main/README.md) of the membership repo in Django Commons

> Django Commons is an organization dedicated to supporting the community's efforts to maintain packages. It seeks to improve the maintenance experience for all contributors; reducing the barrier to entry for new contributors and reducing overhead for existing maintainers.

OK, but what does this new organization get me as a maintainer? The (stretch) goal is that we'll be able to provide support to maintainers. Whether that's helping to identify best practices for pacakges (like requiring tests), or normalize the idea that maintainers can take a step back from their project and know that there will be others to help keep the project going.

These two items in and of themselves are great goals to try and get accomplished, but it's also more. By providing this forum we're hoping to allow maintainers to have a good spot to ask for help, and an ever better spot where people can jump in and start contributing.

In the long term we're hoping that we're able to do something to help provide compensation to maintainers, but that's a long term goal.

The project was spearheaded by Tim Shilling and he was able to get lots of interest from various folks in the Django Community.

What we're really trying to build here is a sustainable infrastructure and community that allows packages to have a good home, and to allow people to be as active as they want to be, but also allow people to take a step back when they need to.

Too often in tech, and espcially in OSS, maintainers / developers will work and work and work because the work they do is generally interesting, and has interesting problems to try and solve.

But this can have a downside that we've all seen .. burnout.

By providing a platform for maintainers to 'park' their projects, along with the necessary infrastructure to keep them active, the goal is to allow maintainers to take a break. When they're ready to return, they can do so with renewed interest, potentially finding new contributors and maintainers who have helped create a more sustainable environment for the open-source project.

The idea for this project is very similar to, but different from, Jazz Band. Again, from the [README](https://github.com/django-commons/membership/blob/main/README.md)

> Django Commons and Jazzband have similar goals, to support community-maintained projects. There are two main differences. The first is that Django Commons leans into the GitHub paradigm and centers the organization as a whole within GitHub. This is a risk, given there's some vendor lock-in. However, the repositories are still cloned to several people's machines and the organization controls the keys to PyPI, not GitHub. If something were to occur, it's manageable.

> The second is that Django Commons is built from the beginning to have more than one administrator. Jazzband has been [working for a while to add additional roadies](https://github.com/jazzband/help/issues/196) (administrators), but there hasn't been visible progress. Given the importance of several of these projects it's a major risk to the community at large to have a single point of failure in managing the projects. By being designed from the start to spread the responsibility, it becomes easier to allow people to step back and others to step up, making Django more sustainable and the community stronger.

One of the goals for Django Commons is to be very public about what's going on. We actively encourage use of the [Discussions](https://github.com/orgs/django-commons/discussions) feature in GitHub and have several active conversations happening there now (add them here)

So far we've been able to migrate 3 libraries into Django-Commons. Each one has been a great learning experience, not only for the library maintainers, but also for the Django-Commons admins.

Additionally we're trying to automate as much of the work as possible. [Daniel](https://github.com/cunla/) has done an amazing job of writing up Terraform scripts to help in the automation process.

While there are still several manual steps, with each new library we discover new opportunities for automation.

This is an exciting project to be a part of. If you're interested in joining [open a new issue](https://github.com/django-commons/membership/issues/new?assignees=django-commons%2Fadmins&labels=Transfer+project+in&projects=&template=transfer-project-in.yml&title=%F0%9F%9B%AC+%5BINBOUND%5D+-+%3Cproject%3E) and we'll work together to get your project transferred into Django Commons.
