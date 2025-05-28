Title: Fun with MCPs
Date: 2025-05-28
Author: ryan
Tags: mcp, claude
Slug: fun-with-mcps
Series: Remove if Not Needed
Status: draft

In trying to get my head wrapped around MCPs over the long Memorial weekend I had a break through. I'm not really sure why this was so hard for me to [grok](https://en.wikipedia.org/wiki/Grok), but now something seems to have clicked. 

I am working with [Pydantic AI](https://ai.pydantic.dev/) and so I'll be using that as an example, but since MCPs are a 'standard protocol' I'm guessing that it will broadly apply. 

## What is Model Context Protocol (MCP)?

Per the [Anthoropic announcement](https://www.anthropic.com/news/model-context-protocol) (from November 2024!!!!)

> The Model Context Protocol is an open standard that enables developers to build secure, two-way connections between their data sources and AI-powered tools. The architecture is straightforward: developers can either expose their data through MCP servers or build AI applications (MCP clients) that connect to these servers.

What this means is that there is a standard way to extend models like Claude, or OpenAI to include other information. That information can be files on the files system, data in a database, etc. 

## (Potential) Real World Example

I work for a Healthcare organization in Southern California. One of the biggest challenges with onboarding new hires (and hoesntly can be a challenge for people that have been with the organization for a long time) is who to reach out to for support on which specific application. 

Typically a user will send an email to one of the support teams, and the email request can get bounced around for a while until it finally lands on the 'right' support desk. There's the potential to have the applications themselves include who to contact, but some applications are vendor supplied and there isn't always a way to do that. 

Even if there were, in my experience those are often not noticed by users OR the users will thing that the support email is for non-technical issues, like "Please update the phone number for this patient" and not issues like, "The web page isn't returning any results on my query for me, but it is for my coworker."

## Enter an MCP with a local LLM

Let's say you have a service that allows you to search through a file system in a predefined set of directories. This service is run with the following command

```bash
npx -y --no-cache @modelcontextprotocol/server-filesystem \path\to\your\files
```

In Pydantic AI the use of the MCPServerStdio is using this same syntax only it breaks it into two parts

- command
- args

The command is any application in your $PATH like `uvx` or `docker` or `npm`, or you can explicitly define where the executable is by calling out it's path, like `/Users/ryancheley/.local/share/mise/installs/bun/latest/bin/bunx`

The args are the commands you'd pass to your application.

Taking the command from above and breaking it down we can set up our MCP using the following

```python
MCPServerStdio(
    "npx",
    args=[
        "-y",
        "--no-cache",
        "@modelcontextprotocol/server-filesystem",
                    "\path\to\your\files",
    ]
```

## Application of MCP with the Example

Since I work in Healthcare, and I want to be mindful of the protection of patient data, even if that data won't be exposed to this LLM, I'll use ollama to contruct my example. 

I created a support.txt file that contains the following information

- Common Name of the Application
- URL of the Application
- Support Email
- Support Extension

I also use the following prompt

```text
You are a helpful chatbot that works for a healthcare organization. You are designed to help end users determine where to send their support requests via email. You will provide a phone number if asked for it explicitly. 

Once you've provided the user with the support email you will ask them if they'd like to create an email to send to the support address. If they indicate "Yes" then you will ask 3 - 5 follow up questions to help them submit their issue to the support team.
```

```code
insert code here
```

As a user, if I ask, who do I contact about questions related to Project A the llm will search through the support.txt file and supply the email contact. It will then ask the user if they want to submit a ticket to the support email. If they answer yes, they will be asked 3 - 5 questions and will have an email they can send to the support system

Now, some support systems have their own ticketing / issue tracking systems and it would be super neat if this ticket could be written directly to that system. With the MCP this is possible. 

We'd need to update the support.txt file with some information about direct writes via an API, and we'd need to secure the crap out of this, but it is possible. 

Now, the user can be more confident that their issue will go to the team that it needs to and that their question / issue can be resolved much more quickly. 