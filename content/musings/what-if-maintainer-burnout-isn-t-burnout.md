Title: What if Maintainer Burnout Isn't Burnout
Date: 2026-08-12
Author: ryan
Tags:
Slug: what-if-maintainer-burnout-isn-t-burnout
Status: draft

Imagine you're staring at your 11th AI-generated pull request of the morning.

The code looks ... fine. The description is polished. Bullet points, a clear rationale, tests, and updated docs. But when you ask the contributor a question about why they'd chosen this approach over the one used everywhere else in the codebase ... nothing. Because they don't know. They'd never read the codebase. An agent had generated something plausible-looking, and a human hit submit.

You're not tired. You're not overworked. Not exactly. You just can't remember why you started doing this.

Yes, this is about AI, but it's also about what open source maintainers were experiencing even before AI.

## Doctor Burnout

Dr. Joseph Silletti is a urologist who wrote a piece for MedPage Today called "What if Burnout Isn't the Problem?" [ref] https://www.medpagetoday.com/opinion/second-opinions/122202 [/ref] He'd noticed something about his colleagues that feels ... familiar.

They weren't exhausted. Or at least, exhaustion wasn't the *only* problem. They were still showing up. The work was manageable. But they'd lost something. Silletti describes it as "quietly losing the thread of **why** the work mattered in the first place." [ref] https://www.medpagetoday.com/opinion/second-opinions/122202 [/ref] (emphasis mine)

He says we're calling it burnout. But it's not burnout. Not exclusively. It's something else.

**Burnout** is a specific psychological construct: emotional exhaustion, depersonalization, diminished sense of personal accomplishment. It's a tank run dry. [ref] https://pmc.ncbi.nlm.nih.gov/articles/PMC4911781/ [/ref]

**Languishing** is different. The term was coined by sociologist Corey Keyes [ref] https://sites.prh.com/languishingbook [/ref] and popularized by Adam Grant during the pandemic. [ref] https://www.nytimes.com/2021/04/19/well/mind/covid-mental-health-languishing.html [/ref] It's the space between mental illness and flourishing. Stagnation. Disconnection. Dimming purpose. The tank has fuel. You've just forgotten where you were going.

Silletti puts it perfectly:

> It isn't that we can't do it. It's, what's the point? [ref] https://www.medpagetoday.com/opinion/second-opinions/122202 [/ref]

Is that how you're feeling, staring at those pull requests?

## Open Source Has the Same Disease

The open source community has been treating maintainer distress as burnout for years. The Tidelift 2024 survey found that 60% of maintainers have quit or considered quitting. [ref] https://www.sonarsource.com/the-2024-tidelift-maintainer-impact-report.pdf [/ref] The top reasons: competing life demands (54%), loss of interest (51%), burnout (44%).

But look at that list again. **Loss of interest is number two.** That's not the tank running dry. That's disengagement. That's someone who still *can* do the work ... they just don't know *why* they're doing it anymore.

The maintainer quotes from a 2025 report on burnout in open source sound *exactly* like Silletti's clinicians:

> "Some also had a sense of directionlessness and loss of meaning in their OSS work." [ref] https://mirandaheath.website/static/oss_burnout_report_mh_25.pdf [/ref]

> "It starts feeling less like building and more like running unpaid support for strangers." [ref] https://www.reddit.com/r/opensource/comments/1q76f90/the_maintainer_burnout_is_real_and_it_is_getting/ [/ref]

They're not describing a tank run dry. They're describing a tank running fine  ... pointed at *nothing*.

## The Sediment

Silletti's key metaphor is **administrative sediment.** He writes about how healthcare accumulated non-clinical work over years. Each piece was reasonable on its own. Each piece had its own justification.

> Taken individually, none seemed unreasonable. Taken collectively, they have quietly buried the work that gives medicine its meaning under an ever-growing layer of administrative sediment. [ref] https://www.medpagetoday.com/opinion/second-opinions/122202 [/ref]

Open source has its own sediment. And it accumulated the same way. Slowly, without malice, each piece seeming reasonable at the time.

Open source was never just about writing code. It was about building something, sometimes just to scratch your own itch. But it was always about building.

GitHub popularized the idea of social coding. It allowed for strangers to submit issues. Some of those strangers also submitted Pull Requests for those issues. Some people would only do a single issue, or a single PR. Others would stay around, forming a community.

The people that helped to form a community were always outnumbered by those that just stopped in to drop a PR or two. The community members were also outnumbered by those that reported issues. Over time, the people that reported issues went from having a sense of 'just wanted to let you know' to 'you need to fix this now'. And the 'you need to fix this now' crowd went from being a small percentage of reporters, to a larger percentage.

Maintainers that were simply offering up something for free were suddenly being treated as tech support. Sometimes by large companies that weren't paying for anything.

And so, as an open source maintainer, issue triage for entitled reporters replaced writing code. PR reviews replaced building features. Security patches replaced creative problem-solving. "Community" management replaced technical mentorship. One analysis found that maintainers spend 80% of their time on support and "community" management, and only 20% actually writing code. [ref] https://medium.com/@sohail_saifii/the-open-source-maintainer-burnout-crisis-nobodys-fixing-5cf4b459a72b [/ref]

Nobody did this to us on purpose. Each task arrived with justification. A bug report needs triaging. A contributor needs guidance. A security advisory needs a response. Each one, individually, is the right thing to do.

But here we are. The meaningful work, the *building*, got buried under the maintenance work. And we called the result burnout.

## Then the Slop Showed Up

Suddenly AI slop arrived, and it made everything worse. But not in the way everyone thinks.

The volume numbers look like pure burnout, I'll grant that. AI-generated pull requests take roughly 12 times longer to review than human ones. [ref] https://webmatrices.com/post/vibe-coding-has-a-12x-cost-problem-maintainers-are-done [/ref] Daniel Stenberg, the creator of `curl`, killed their bug bounty program entirely, writing that "the never-ending slop submissions take a serious mental toll ... hampering our will to live." [ref] https://daniel.haxx.se/blog/2026/01/26/the-end-of-the-curl-bug-bounty/ [/ref] GitHub added PR caps as an emergency measure. [ref] https://www.coderabbit.ai/blog/github-gives-maintainers-a-throttle-for-the-ai-pull-request [/ref]

But read what maintainers are *actually saying*. It's not "I'm too tired." It's this, from RedMonk:

> "AI slop is ripping up the social contract between maintainers and contributors essential to open source development." [ref] https://redmonk.com/kholterhoff/2026/02/03/ai-slopageddon-and-the-oss-maintainers/ [/ref]

*The social contract.* The *relationship.*

The thing that made open source maintenance joyful was that someone cared enough about your work to try to improve it. You mentored them. They learned. The code got better. The community grew. That's the social contract.

AI slop doesn't add work. It *replaces human connection with mechanized noise.*

When the work becomes *pointless,* when you're closing PR #50 from an agent that couldn't tell you what design patterns your project uses if its "life" depended on it, the question isn't "I need a break."

It's **"what's the point?"**

That's not burnout. That's languishing. And slop is pouring gasoline on that fire.

## Why Our Fixes Aren't Working

Here's where the framing matters. Silletti again:

> The solution is one of subtraction, not supplementation. [ref] https://www.medpagetoday.com/opinion/second-opinions/122202 [/ref]

We've been treating open source maintainer distress as a workload problem. And our solutions reflect that:

Pay them. Get more contributors. Add tooling. Build AI triage bots.

But slop *is* more contributors. AI triage bots just automate the emptiness. GitHub's PR caps reduce the volume but don't restore the meaning.

*The yoga class for clinicians is the "pay maintainers" campaign for open source.* Both treat symptoms without addressing the core issue: the work itself has lost its meaning.

Silletti proposes a test for healthcare leaders. He says they should ask of every task: does this bring the clinician closer to the patient or further away? [ref] https://www.medpagetoday.com/opinion/second-opinions/122202 [/ref]

Here's my version for open source: **does this task bring the maintainer closer to building or further away?**

Triage of intentional, well thought out and reported issues? Closer. PR review for a human who wants to learn? Closer. Mentoring a new human contributor? Closer. AI-generated spam? Further.

## Am I Wrong?

Christina Maslach, the person who literally *invented* burnout research, I think would push back hard on this whole framing. Her three-dimensional model already includes cynicism (detachment from work) and reduced personal efficacy (loss of belief in your competence). [ref] https://pmc.ncbi.nlm.nih.gov/articles/PMC4911781/ [/ref] Those overlap heavily with what I'm calling languishing.

And her Six Areas of Worklife framework lists *values* as one of the mismatch areas that cause burnout. A values mismatch IS a meaning crisis. [ref] https://www.demenzemedicinagenerale.net/images/mens-sana/Burnout_Organizational_Predictor.pdf [/ref] So maybe languishing is just burnout without the exhaustion dimension? Maybe the distinction is academic.

The slop numbers are real. Twelve times the review time. DDoS-level volume. When you're drowning in 500 AI-generated PRs, calling it a "meaning crisis" might feel like calling a flood a water quality issue.

I get it. I might be wrong. Maybe Languishing is just Burnout by a different name ... but I don't think so.

## Maybe It's Both

I think the truth is exhaustion *and* emptiness, feeding each other in a loop:

1. Slop increases the workload. Exhaustion sets in. (Burnout.)

2. Exhaustion reduces capacity for the meaningful work. Disconnection grows. (Languishing.)

3. Languishing kills motivation to keep fighting the slop. More slop gets through. Workload increases.

4. *Repeat.*

But here's the thing. The *intervention* matters. If we only treat the burnout side (reduce workload, add tooling, cap PRs), the languishing continues. If we only treat the languishing side (restore purpose, reconnect to meaning), the workload crushes people before the reconnection takes hold.

We need both. But we've been doing *neither.* We've been doing GitHub Sponsors and calling it done.

The distinction isn't about diagnostic purity. It's about what you reach for first. If you call it burnout, you reach for workload reduction. If you call it languishing, you reach for purpose. The loop needs both interventions. But we've only ever tried one.

## What Do We Actually Do?

Silletti's prescription:

> They must examine the job itself and identify the sediment of nonclinical tasks. The solution is not to work harder, or faster, or more resiliently through that sediment. The solution is to remove it. [ref] https://www.medpagetoday.com/opinion/second-opinions/122202 [/ref]

For us, that means:

- **Remove the slop.** Not just cap it. Reject the premise that all contributions are equal. A PR from someone who understands your codebase is worth a thousand PRs from an agent that doesn't.

- **Protect the social contract.** The maintainer-contributor relationship is the meaning. Don't let AI industrialize it into spam.

- **Ask the question** of every maintainer task: does this bring you closer to the building or further away? And if it takes you further away ... maybe stop doing it.

I'll be honest. I maintain a few, trivial, open source projects. I'm on the Django Software Foundation board. I'm on the Django Commons admin team. And I've felt this. Not the exhaustion, the *emptiness.* The mechanical closing of PRs. The realization that I'm going through the motions.

I think if we're honest, a lot of us are languishing. Not burning out. The tank has gas.

We've just forgotten where we were going.

*But that's a fixable problem. If we stop calling it the wrong thing.*
