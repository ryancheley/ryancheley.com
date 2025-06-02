Title: Fun with MCPs
Date: 2025-06-02
Author: ryan
Tags: mcp, ollama
Slug: fun-with-mcps
Status: published

Special Thanks to [Jeff Triplett](https://mastodon.social/@webology) who provided an example that really got me started on better understanding of how this all works.

In trying to wrap my head around MCPs over the long Memorial weekend I had a breakthrough. I'm not really sure why this was so hard for me to [grok](https://en.wikipedia.org/wiki/Grok), but now something seems to have clicked. 

I am working with [Pydantic AI](https://ai.pydantic.dev/) and so I'll be using that as an example, but since MCPs are a standard protocol, these concepts apply broadly across different implementations. 

## What is Model Context Protocol (MCP)?

Per the [Anthropic announcement](https://www.anthropic.com/news/model-context-protocol) (from November 2024!!!!)

> The Model Context Protocol is an open standard that enables developers to build secure, two-way connections between their data sources and AI-powered tools. The architecture is straightforward: developers can either expose their data through MCP servers or build AI applications (MCP clients) that connect to these servers.

What this means is that there is a standard way to extend models like Claude, or OpenAI to include other information. That information can be files on the file system, data in a database, etc. 

## (Potential) Real World Example

I work for a Healthcare organization in Southern California. One of the biggest challenges with onboarding new hires (and honestly can be a challenge for people that have been with the organization for a long time) is who to reach out to for support on which specific application. 

Typically a user will send an email to one of the support teams, and the email request can get bounced around for a while until it finally lands on the 'right' support desk. There's the potential to have the applications themselves include who to contact, but some applications are vendor supplied and there isn't always a way to do that. 

Even if there were, in my experience those are often not noticed by users OR the users will think that the support email is for non-technical issues, like "Please update the phone number for this patient" and not issues like, "The web page isn't returning any results for me, but it is for my coworker."

## Enter an MCP with a Local LLM

Let's say you have a service that allows you to search through a file system in a predefined set of directories. This service is run with the following command

```bash
npx -y --no-cache @modelcontextprotocol/server-filesystem /path/to/your/files
```

In Pydantic AI the use of the MCPServerStdio is using this same syntax only it breaks it into two parts

- command
- args

The command is any application in your $PATH like `uvx` or `docker` or `npx`, or you can explicitly define where the executable is by calling out its path, like `/Users/ryancheley/.local/share/mise/installs/bun/latest/bin/bunx`

The args are the commands you'd pass to your application.

Taking the command from above and breaking it down we can set up our MCP using the following

```python
MCPServerStdio(
    "npx",
    args=[
        "-y",
        "--no-cache",
        "@modelcontextprotocol/server-filesystem",
        "/path/to/your/files",
    ]
```

## Application of MCP with the Example

Since I work in Healthcare, and I want to be mindful of the protection of patient data, even if that data won't be exposed to this LLM, I'll use ollama to construct my example. 

I created a `support.csv` file that contains the following information

- Common Name of the Application
- URL of the Application
- Support Email
- Support Extension
- Department

I used the following prompt

> Review the file `support.csv` and help me determine who I contact about questions related to CarePath Analytics.

Here are the contents of the `support.csv` file

| Name | URL | Support Email | Support Extension | Department |
|------|-----|---------------|-------------------|------------|
| MedFlow Solutions | https://medflow.com | support@medflow.com | 1234 | Clinical Systems |
| HealthTech Portal | https://healthtech-portal.org | help@medflow.com | 3456 | Patient Services |
| CarePath Analytics | https://carepath.io | support@medflow.com | 4567 | Data Analytics |
| VitalSign Monitor | https://vitalsign.net | support@medflow.com | 1234 | Clinical Systems |
| Patient Connect Hub | https://patientconnect.com | contact@medflow.com | 3456 | Patient Services |
| EHR Bridge | https://ehrbridge.org | support@medflow.com | 2341 | Integration Services |
| Clinical Workflow Pro | https://clinicalwf.com | support@medflow.com | 1234 | Clinical Systems |
| HealthData Sync | https://healthdata-sync.net | sync@medflow.com | 6789 | Integration Services |
| TeleHealth Connect | https://telehealth-connect.com | help@medflow.com | 3456 | Patient Services |
| MedRecord Central | https://medrecord.central | records@medflow.com | 5678 | Medical Records |


The script is below:

```python
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "pydantic-ai",
# ]
# ///

import asyncio
from pydantic_ai import Agent
from pydantic_ai.mcp import MCPServerStdio
from pydantic_ai.models.openai import OpenAIModel
from pydantic_ai.providers.openai import OpenAIProvider

async def main():
    # Configure the Ollama model using OpenAI-compatible API
    model = OpenAIModel(
        model_name='qwen3:8b',  # or whatever model you have installed locally
        provider=OpenAIProvider(base_url='http://localhost:11434/v1')
    )

    # Set up the MCP server to access our support files
    support_files_server = MCPServerStdio(
        "npx",
        args=[
            "-y",
            "@modelcontextprotocol/server-filesystem",
            "/path/to/your/files"  # Directory containing support.csv
        ]
    )

    # Create the agent with the model and MCP server
    agent = Agent(
        model=model,
        mcp_servers=[support_files_server],
    )

    # Run the agent with the MCP server
    async with agent.run_mcp_servers():
        # Get response from Ollama about support contact
        result = await agent.run(
            "Review the file `support.csv` and help me determine who I contact about questions related to CarePath Analytics?"        )
        print(result.output)

if __name__ == "__main__":
    asyncio.run(main())
```

As a user, if I ask, who do I contact about questions related to CarePath Analytics the LLM will search through the `support.csv` file and supply the email contact. 

This example shows a command line script, and a Web Interface would probably be better for most users. That would be the next thing I'd try to do here. 

Once that was done you could extend it to also include an MCP to write an email on the user's behalf. It could even ask probing questions to help make sure that the email had more context for the support team.

Some support systems have their own ticketing / issue tracking systems and it would be really valuable if this ticket could be written directly to that system. With the MCP this is possible. 

We'd need to update the `support.csv` file with some information about direct writes via an API, and we'd need to secure the crap out of this, but it is possible. 

Now, the user can be more confident that their issue will go to the team that it needs to and that their question / issue can be resolved much more quickly. 
