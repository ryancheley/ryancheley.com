Title: The Technical Debt of Others
Date: 2017-07-28 03:21
Author: ryan
Category: Musings
Tags: Work
Slug: the-technical-debt-of-others
Status: published

# The Technical Debt of Others

Technical Debt as defined on [technopendia](https://www.techopedia.com) is:

> a concept in programming that reflects the extra development work that arises when code that is easy to implement in the short run is used instead of applying the best overall solution.

In the management of software development we have to make these types of easy-to-implement-and-we-need-to-ship versus need-to-do-it-right-but-it-will-take-longer decisions all of the time.

These decisions can lead to the dreaded **working as designed** answer to a bug report.

This is infuriating.

It’s even more infuriating when you are on the receiving end of this.

A recent feature enhancement in the EHR we use touted an

> Alert to let proscribing providers know that a medication is a duplicate.

For anyone in the medical field you can know what a nightmare it can be to prescribe a duplicate medication from a patient safety perspective, so we’d obviously want to have this feature on.

During our testing we noticed that if a medication was prescribed in a dose, say 75mg, and stopped and then started again at a new dose, say 50mg, the Duplicate Medication Alert would be presented.

We dutifully submitted a bug report to the vendor and the responded

> The Medication is considered a true duplicate as when a medication is stopped it is stopped for that day it is still considered active till (*sic*) the end of the day due to the current application logic, which cannot be altered or changed. What your providers/users may do is enter a DUR Reason and Acknowledge with something along the lines of "New Prescription". These DUR reasons can be added via Tools \> Preferences \> Medications \> DUR \> Override Reason tab - type in the desired DUR Override Reason \> Select Add \> OK to save.
>
> If functionality and logic outside of this is desired this will need to be submitted as an Idea as well since this is currently **functioning off of development's intended design.**”

Then the design is broken.

From a technical perspective I know exactly what is going on. This particular vendor stores `date` values as `varchar(8)` but stores `datetime` values as `datetime`. There may be some really good reasons for making this design decision.

However, when the `medication` tables were designed, the developers asked the question, "Will we **EVER** care about the time a medication is started or stopped?"

They answered no and decided to set up a `start date` (and by extension an `end date`) for medications to not respect the time that a prescription started or stopped and therefore set them as `varchar(8)` and not as `DATETIME`.

But now they’ve rolled out this **awesome** feature. A feature that would actually allow providers to recognize duplicate medications potentially saving lives. But because they don’t store the time of the stopped medication, their logic can only look at the date. When it sees the same medication (but in different doses) active on the same date a warning appears letting the provider know that they have a duplicate medication (even though they don’t).

Additionally, this warning serves no purpose other than to be **one more damned click** from a provider’s perspective because the vendor is not storing (ie ignoring) the time.

When clinicians complain about the impact of EHRs on their ability to deliver effective care ... when they complain about EHRs not fulfilling their promise of increased patient safety, these are the types of things that they are complaining about.

I think this response from one of the clinicians sums up this issue

> I don't see the logic with the current "intended design" in considering a medication that has just been inactivated STILL ACTIVE until the end of the day. A prescriber would stop current and start new meds all in one sitting (which includes changing doses of the same med), not wait until the next day to do the second step. It decreases workflow efficiency to have to enter a reason when no real reason exists (since there IS no active entry on med list). The whole point is to alert a prescriber to an existing entry of a medication and resolve it by inactivating the duplicate, if appropriate (otherwise, enter reason for having a duplicate), before sending out a new Rx.
>
> While it's relatively easy to follow and resolve the duplication alert if the inactivation and new prescribing is done by the same prescriber, I can see a scenario where prescriber A stops an old ibuprofen 600mg Rx\[\^2\] (say PCP) and patient then goes to see prescriber B (say IC\[\^3\]) who then tries to Rx ibuprofen 800mg…. and end up getting this duplication alert. The second prescriber would almost be lost as to why that message is showing up.
>
> The application logic should augment the processes the application was designed to faciliate, **but right now it is a hindrance**. (emphasis added)

I know that sometimes we need to build it fast so that we can ship, but developers need to remember, *forever* is a long freaking time.

When you make a forever decision, be prepared to have push back from users of your software when those decision are markedly ridiculous. And be prepared to be scoffed at when you answer their bug report with a Working-as–Designed response.

\[\^2\]: Rx = prescription

\[\^3\]: IC = Immediate Care
