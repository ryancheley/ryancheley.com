Title: Why We Need to Stop Fighting About AI Tools and Start Teaching Them
Date: 2025-07-25
Author: ryan
Tags: ai, llm
Slug: why-we-need-to-stop-fighting-about-ai-tools-and-start-teaching-them
Status: published

In mid-June, Hynek tooted on Mastodon the [following toot](https://mastodon.social/@hynek/114703485524249737):  

> Watching the frustratingly fruitless fights over the USEFULNESS of LLM-based coding helpers, I've come down to 3 points that explain why ppl seem to live in different realities:
> 
> Most programmers:
> 
> 1) Write inconsequential remixes of trivial code that has been written many times before.
> 
> 2) Lack the taste for good design & suck at code review in general (yours truly included).
> 
> 3) Lack the judgement to differentiate between 1) & FOSS repos of nontrivial code, leading to PR slop avalanche.
> 
> 1/3

> So, if you're writing novel code & not another CRUD app or API wrapper, all you can see is LLMs fall on their faces.
> 
> Same goes for bigger applications if you care about design. Deceivingly, if you lack 2), you won't notice that an architecture is crap b/c it doesn't look worse than your usual stuff.
> 
> That means that the era of six figures for CRUD apps is coming to an end, but it also means that Claude Code et al can be very useful for certain tasks. Not every task involves splitting atoms. 2/3
> 
> 2/3

> There's also a bit of a corollary here. Given that LLMs are stochastic parrots, the inputs determine the outputs.
> 
> And, without naming names, certain communities are more… rigorous… at software design than others.
> 
> It follows that the quality of LLM-generated code will inevitably become a decision factor for choosing frameworks and languages and I'm not sure if I'm ready for that.
> 
> 3/3

I've been having a lot of success with using Claude Code recently so I've been thinking about this toot a lot lately. Simon Willison talks a lot about the things that he's been able to do because he just asks [OpenAI's ChatGPT while walking his dog](https://twimlai.com/podcast/twimlai/supercharging-developer-productivity-with-chatgpt-and-claude/). He's asking a coding agent to help him with ideas he has in languages with which he may not be familiar. However, he's a good enough programmer that he can spot anti-patterns that are being written by the agent.

For me, it comes down to the helpfulness of these agentic coding tools; they can help me write boiler plate code more quickly. What it's really coming down to, for me, is that when something is trivially easy to implement, like another CRUD app or an API wrapper, those problems are solved. We don't need to keep solving them in ways that don't really help. What we need to do in order to be better programmers is figure out how to solve problems most effectively. And if that's creating a CRUD app or an API wrapper or whatever, then yeah, you're not solving any huge problem there. But if you're looking to solve something in a very unique or novel way, agentic coding tools aren't going to help you as much.

I don't need to know how the internal combustion engine of my car works. I do need to know that when the check engine light comes on, I need to take it to a mechanic. And then that mechanic is going to use some device that lets them know what is wrong with the car and what needs to be done to fix it. This seems very analogous to the coding agents that we're seeing now. We don't have to keep trying to solve those problems with well-known solutions. We can and we should rely on the knowledge that is available to us and use that knowledge to solve these problems quickly. This allows us to focus on trying to solve new problems that no one has ever seen. 

This doesn't mean we can skip learning the fundamentals. Like blocking and tackling in football, if you can't handle the basic building blocks of programming, you're not going to succeed with complex projects. That foundational understanding remains essential.

The real value of large language models and coding agents lies in how they can accelerate that learning process. Being able to ask an LLM about how a specific GitHub action works, or why you'd want to use a particular pattern, creates opportunities to understand concepts more quickly. These tools won't solve novel problems for you—that's still the core work of being a software developer. But they can eliminate the repetitive research and boilerplate implementation that used to consume so much of our time, freeing us to focus on the problems that actually require human creativity and problem-solving skills.

How many software developers write in assembly anymore? Some of us maybe, but really what it comes down to is that we don't have to. We've abstracted away a lot of that particular knowledge set to a point where we don't need it anymore. We can write code in higher-level languages to help us get to solutions more quickly. If that's the case, why shouldn't we use LLMs to help us get to solutions even more quickly?

I've noticed a tendency to view LLM-assisted coding as somehow less legitimate, but this misses the opportunity to help developers integrate these tools thoughtfully into their workflow. Instead of questioning the validity of using these tools, we should be focusing on how we can help people learn to use them effectively.

In the same way that we helped people to learn how to use Google, we should help them to use large language models. Back in the early 2000s when Google was just starting to become a thing, knowing how to effectively use it to exclude specific terms, search for exact phrases using quotation marks, that wasn't always known by everybody. But the people who knew how to do that were able to find things more effectively.

I see a parallel here. Instead of dismissing people who use these tools, we should be asking more constructive questions: How do we help them become more effective with LLMs? How do we help them use these tools to actually learn and grow as developers?

Understanding the limitations of large language models is crucial to using them well, but right now we're missing that opportunity by focusing on whether people should use them at all rather than how they can use them better.

We need to take a step back and re-evaluate how we use LLMs and how we encourage others to use them. The goal is getting to a point where we understand that LLMs are one more tool in our developer toolkit, regardless of whether we're working on open-source projects or commercial software. We don't need to avoid these tools. We just need to learn how to use them more effectively, and we need to do this quickly.