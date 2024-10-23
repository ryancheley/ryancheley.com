Title: Django Commons
Date: 2024-10-23
Author: ryan
Tags: django, oss, django-commons
Slug: django-commons
Status: published

First, what are "the commons"? The concept of "the commons" refers to resources that are shared and managed collectively by a community, rather than being owned privately or by the state. This idea has been applied to natural resources like air, water, and grazing land, but it has also expanded to include digital and cultural resources, such as open-source software, knowledge databases, and creative works.

As Organization Administrators of Django Commons, we're focusing on sustainability and stewardship as key aspects.

Asking for help is hard, but it can be done more easily in a safe environment. As we saw with the [xz utils backdoor](https://en.wikipedia.org/wiki/XZ_Utils_backdoor) attack, maintainer burnout is real. And while there are several arguments about being part of a 'supply chain' if we can, as a community, offer up a place where maintainers can work together for the sustainability and support of their packages, Django community will be better off!

From the [README](https://github.com/django-commons/membership/blob/main/README.md) of the membership repo in Django Commons

> Django Commons is an organization dedicated to supporting the community's efforts to maintain packages. It seeks to improve the maintenance experience for all contributors; reducing the barrier to entry for new contributors and reducing overhead for existing maintainers.

OK, but what does this new organization get me as a maintainer? The (stretch) goal is that we'll be able to provide support to maintainers. Whether that's helping to identify best practices for packages (like requiring tests), or normalize the idea that maintainers can take a step back from their project and know that there will be others to help keep the project going. Being able to accomplish these two goals would be amazing ... but we want to do more!

In the long term we're hoping that we're able to do something to help provide compensation to maintainers, but as I said, that's a long term goal.

The project was spearheaded by Tim Schilling and he was able to get lots of interest from various folks in the Django Community. But I think one of the great aspects of this community project is the transparency that we're striving for. You can see [here](https://github.com/orgs/django-commons/discussions/19) an example of a discussion, out in the open, as we try to define what we're doing, together. Also, while Tim spearheaded this effort, we're really all working as equals towards a common goal.

What we're building here is a sustainable infrastructure and community. This community will allow packages to have a good home, to allow people to be as active as they want to be, and also allow people to take a step back when they need to.

Too often in tech, and especially in OSS, maintainers / developers will work and work and work because the work they do is generally interesting, and has interesting problems to try and solve.

But this can have a downside that we've all seen .. burnout.

By providing a platform for maintainers to 'park' their projects, along with the necessary infrastructure to keep them active, the goal is to allow maintainers the opportunity to take a break if, or when, they need to. When they're ready to return, they can do so with renewed interest, with new contributors and maintainers who have helped create a more sustainable environment for the open-source project.

The idea for this project is very similar to, but different from, Jazz Band. Again, from the [README](https://github.com/django-commons/membership/blob/main/README.md)

> Django Commons and Jazzband have similar goals, to support community-maintained projects. There are two main differences. The first is that Django Commons leans into the GitHub paradigm and centers the organization as a whole within GitHub. This is a risk, given there's some vendor lock-in. However, the repositories are still cloned to several people's machines and the organization controls the keys to PyPI, not GitHub. If something were to occur, it's manageable.

> The second is that Django Commons is built from the beginning to have more than one administrator. Jazzband has been [working for a while to add additional roadies](https://github.com/jazzband/help/issues/196) (administrators), but there hasn't been visible progress. Given the importance of several of these projects it's a major risk to the community at large to have a single point of failure in managing the projects. By being designed from the start to spread the responsibility, it becomes easier to allow people to step back and others to step up, making Django more sustainable and the community stronger.

One of the goals for Django Commons is to be very public about what's going on. We actively encourage use of the [Discussions](https://github.com/orgs/django-commons/discussions) feature in GitHub and have several active conversations happening there now[ref][How to approach existing libraries](https://github.com/orgs/django-commons/discussions/52)[/ref] [ref][Creating a maintainer-contributor feedback loop](https://github.com/orgs/django-commons/discussions/61)[/ref] [ref][DjangoCon US 2024 Maintainership Open pace](https://github.com/orgs/django-commons/discussions/42)[/ref]

So far we've been able to migrate ~3~ 4 libraries[ref][django-tasks-scheduler](https://github.com/django-commons/django-tasks-scheduler)[/ref] [ref][django-typer](https://github.com/django-commons/django-typer)[/ref] [ref][django-fsm-2](https://github.com/django-commons/django-fsm-2)[/ref] [ref][django-debug-toolbar](https://github.com/django-commons/django-debug-toolbar/)[/ref]into Django Commons. Each one has been a great learning experience, not only for the library maintainers, but also for the Django Commons admins.

We're working to automate as much of the work as possible. [Daniel Moran](https://github.com/cunla/) has done an amazing job of writing Terraform scripts to help in the automation process.

While there are still several manual steps, with each new library, we discover new opportunities for automation.

This is an exciting project to be a part of. If you're interested in joining us you have a couple of options

1. [Transfer your project](https://github.com/django-commons/membership/issues/new?assignees=django-commons%2Fadmins&labels=Transfer+project+in&projects=&template=transfer-project-in.yml&title=%F0%9F%9B%AC+%5BINBOUND%5D+-+%3Cproject%3E) into Django Commons
2. [Join as member](https://github.com/django-commons/membership/issues/new?assignees=django-commons%2Fadmins&labels=New+member&projects=&template=new-member.yml&title=%E2%9C%8B+%5BMEMBER%5D+-+%3Cyour+handle%3E) and help contribute to one of the projects that's already in Django Commons

I'm looking forward to seeing you be part of this amazing community!
