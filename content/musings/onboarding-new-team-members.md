Title: Onboarding new team members
Date:
Author: ryan
Tags:
Slug: onboarding-new-team-members
Series: Remove if Not Needed
Status: draft

Due to some structural changes at work we have 2 new employees from a sister organization starting with a department I oversee. We'll call this Department N.

Department N doesn't have a formal onboarding process and I wanted to make sure that these 2 new team members had a great experience onboarding with us. My other department, Department B, does have a robust, formal onboarding process that has been very successful over the last 6+ years. I wanted to apply the model used by Department B to Department N to help make it successful.

But I also knew that there were *some* differences that would need to be accounted for. I decided that I could use Claude's help for this!

My first prompt was

> Department N just had 2 new employees from our sister company transfer into the department. I would like to construct an onboarding plan for them for the next 90 days to review with the management team of the department.
>
> What information do you need to help construct an effective onboarding experience for these employees?

Claude output a good set of questions which I answered. A few minutes later Claude came up with a 90 day onboarding plan that was about 90% the way there. I gave Claude the feedback

> I like most of this, but what I’d like to have is the ability for each of the transfers to sit with each type of Department N employee for some period of time to review what they do. For example, there are SC, PMC, EC, and SA on the Ops team, and TS, DBA, and NSD on the Technical team. They should expect to spend about 2 hours with each of the technical team members and up to 4 hours with each of the operations roles. This time should be done within the first four weeks to help orient them to the team members

The response I got seemed to think that the work being done was in office, but it's remote. So I clarified that

> one thing to note, all of the roles are remote. they already have their desks setup. Some applications that are specific to the new organization (like YouTrack) will need to be setup.

With that, I had a robust onboarding document for the first 90 days which will (hopefully) be very successful. It's actually more thorough than the onboarding process for the BI department.

The full onboarding plan looked like this

# 90-Day Onboarding Plan

**Start Date:** 01/21.2026

---

## Overview

This onboarding plan is designed to team members to the Department N over 90 days. The plan focuses on:

- Understanding Company A processes, tools, and team structure
- Learning YouTrack and Service Desk systems
- Building relationships across operations and technical teams
- Achieving dual support capability for both Company D and Company H application environments

---

## Week 1-4: Foundation, Access & Team Role Exposure

### **Week 1: Initial Setup & Orientation**

**Objectives:** Get oriented to Company D environment, obtain necessary access, understand team structure, begin role shadowing

**Activities:**
- **Day 1-2:**
  - Welcome meeting with supervisor via Teams/Zoom
  - Review organizational chart and reporting structure
  - Virtual introduction to all team members - could be done via team meeting or individual 15-min intros
  - Verify existing equipment/setup is adequate for Company D work
  - **Schedule role shadowing calendar for Weeks 1-4** (see rotation schedule below)

- **Day 3-5:**
  - **Company D-specific application setup:**
    - YouTrack account creation and initial training (navigation, creating issues, searching, using knowledge base)
    - Service Desk account creation and initial training (ticket lifecycle, categories, priorities)
    - Any Company D-specific VPN, remote desktop, or network access
  - Review Company D support hours, on-call rotation clarification, and escalation paths
  - Access provisioning: NextGen environments (Company D and Company H), databases (read-only to start), network drives, SharePoint/OneDrive
  - **Begin role shadowing: 4 hours with Support Coordinator(s)** (via screen share/Zoom)

**Checkpoint:** End of Week 1 - Meet with supervisor to confirm all access is working, initial questions answered, shadowing schedule on track

---

### **Week 2: Observation & Role Shadowing Continues**

**Objectives:** Continue building understanding of all team roles, start shadowing technical team, begin standup observation

**Activities:**
- Assign a "buddy" from the existing NextGen team for daily questions
- Shadow existing team members during daily standup (observe only)
- Review existing Company D NextGen support documentation in YouTrack knowledge base
- Compare Company H processes to Company D processes - identify major differences (document these notes)
- Begin attending team meetings as observer

**Role Shadowing This Week:**
- **4 hours with PMC**
- **4 hours with EC**
- **2 hours with DBA**

**Checkpoint:** End of Week 2 - Mid-shadowing check-in: supervisor reviews observations, addresses questions from shadowing sessions

---

### **Week 3: Active Participation Begins & Complete Role Shadowing**

**Objectives:** Finish role shadowing rotation, start handling Company D tickets with guidance, begin standup participation

**Activities:**
- Start participating in daily standup (can be brief: "I shadowed X, learning Y, no roadblocks")
- Take ownership of 2-3 low-complexity Company D tickets with buddy review before closing
- Document observed differences between Company H and Company D workflows in personal notes
- YouTrack intermediate training: linking issues, time tracking, workflows, project boards
- **Complete shadowing debrief document** (1-page summary of key takeaways from each role)

**Role Shadowing This Week:**
- **4 hours with SA**
- **2 hours with TS**
- **2 hours with NSD**

**Checkpoint:** End of Week 3 - Review shadowing debrief document with supervisor; discuss how different roles interact in support scenarios

---

### **Week 4: Full Participation & Integration**

**Objectives:** Apply learning from shadowing, increase ticket volume, understand escalation touchpoints

**Activities:**
- Full participation in daily standup with actual work updates
- Take ownership of 5-7 Company D tickets (mix of difficulty) with supervisor spot-checks
- Service Desk intermediate training: SLAs, reporting, escalation procedures
- Review Company D escalation matrix - **connect escalation paths to specific people shadowed**
- **Present 5-minute summary at team meeting**: "What I learned from shadowing each role"

**Checkpoint:** End of Week 4 - Formal review with supervisor: tickets closed, feedback on standup participation, shadowing insights applied, adjust Month 2 plan if needed

---

## Month 2 (Days 31-60): Increasing Independence

**Objectives:** Handle full Company D ticket load independently, begin documentation project, maintain 14-day ticket closure or escalation

**Activities:**

### **Weeks 5-6:**
- Full ticket ownership for Company D issues (target: manage own queue independently)
- Begin tracking: can you close tickets within 14 days or convert to projects appropriately?
- Start documentation project: create list of Company H-specific processes/procedures that need Company D equivalents
- Participate in at least one technical team meeting to understand project escalation process
- Introduction to upgrade project (attend kickoff or review planning docs)

### **Weeks 7-8:**
- Continue independent Company D ticket management
- Start drafting documentation for first 2-3 Company H processes using Company D standards/templates
- Review documentation with supervisor for feedback on format and completeness
- Begin taking Company H tickets again (with Company D tools and processes) - start small
- Shadow technical team on one escalated issue to understand handoff process

**Checkpoint:** Day 60 - Formal review meeting with supervisor and director
- Review ticket metrics (closure rate, 14-day goal achievement)
- Review first draft documentation
- Assess comfort level with dual support (Company D/Company H)
- Identify any skill gaps or additional training needs

---

## Month 3 (Days 61-90): Dual Support & Documentation Completion

**Objectives:** Comfortable supporting both Company D and Company H, complete documentation updates, prepare for upgrade involvement

**Activities:**

### **Weeks 9-10:**
- Full dual support: manage tickets from both Company D and Company H queues
- Continue documentation work: aim to have 75% of Company H processes documented to Company D standards
- Participate in upgrade planning discussions (understand timeline, your role)
- Lead resolution of at least one moderately complex issue end-to-end

### **Weeks 11-12:**
- Continue dual support with minimal supervision
- Finalize documentation: complete Company H process documentation and submit for team review
- Present one topic at team meeting (could be Company H-specific workflow, lessons learned, or upgrade-related)
- Review personal goals and development areas with supervisor
- Participate in creating knowledge base articles from resolved tickets

**Checkpoint:** Day 90 - Final onboarding review with supervisor and director
- Ticket metrics review: closure rates, quality, escalation appropriateness
- Documentation completion and quality assessment
- Self-assessment and supervisor assessment of competency
- Set goals for next 90 days (including upgrade project involvement)
- Transition from "onboarding" to "fully integrated team member"

---

## Success Metrics Summary

| Timeframe | Key Metrics |
|-----------|-------------|
| **30 Days** | • Full daily standup participation<br>• Successfully closed 10+ Company D tickets<br>• All system access confirmed working<br>• Completed all role shadowing sessions |
| **60 Days** | • Consistently meeting 14-day ticket closure/escalation goal<br>• First draft documentation for 2-3 Company H processes complete<br>• Beginning to take Company H tickets using Company D processes |
| **90 Days** | • Comfortable supporting both Company D and Company H<br>• Company H process documentation complete and reviewed<br>• Ready to contribute to NextGen upgrade project |

---

## Role Shadowing Structure & Guidelines (Remote Edition)

### **Suggested Rotation Schedule**

| Week | Role | Time | Focus Areas |
|------|------|------|-------------|
| 1 (Days 3-5) | Support Coordinator | 4 hours | Daily ticket triage, user communication, priority setting |
| 2 | PMC | 4 hours | Provider workflows, practice-specific configurations, scheduling/billing interfaces |
| 2 | EC | 4 hours | User training delivery, documentation creation, tip sheet development |
| 2 | DBA | 2 hours | Database structure, reporting queries, data integrity checks |
| 3 | SA | 4 hours | Administrative support, follow-up processes, documentation maintenance |
| 3 | TS | 2 hours | Technical troubleshooting, system configurations, server/client issues |
| 3 | NSD(s) | 2 hours | Custom development, EPM customization, upgrade implications |

**Total Shadowing Time:** 24 hours over 3 weeks

---

### **Shadowing Session Structure**

**Preparation (sent 1 day before):**
- New Team Member reviews role description and prepares 3-5 questions
- Role owner identifies 1-2 typical tasks/tickets to walk through
- **Calendar invite sent with Zoom/Teams link and screen sharing enabled**

**During Session (All Remote via Video Call):**
- First 15 min: Role overview, typical day, how they interact with other teams (cameras on)
- Next 60-90 min: **Screen share** - observe live work (tickets, projects, meetings)
- Next 45-60 min: Deep dive on 1-2 specific processes or tools (role owner shares screen, walks through)
- Last 15-30 min: Q&A, discuss common escalation scenarios

**After Session:**
- New Team Member adds notes to shadowing debrief document
- New Team Member sends thank you message to role owner (Teams/email)
- Role owner provides brief feedback to supervisor on engagement/questions

---

### **Remote Shadowing Best Practices**

**For New Team Member:**
- Keep camera on during intros and Q&A portions
- Take notes in shared document or personal OneNote
- Ask questions via chat if role owner is deep in concentration
- Record sessions if permitted (and role owner agrees) for later review

**For Role Owners:**
- Share entire screen or specific application as appropriate
- Narrate your thought process while working through tickets
- Use annotation tools to highlight important areas
- Provide links to documentation/tools in chat during session

---

### **Shadowing Debrief Document Template**

New Team Member completes this throughout Weeks 1-3, reviews with supervisor at end of Week 3:

**For Each Role:**
1. **Key Responsibilities:** 3-5 bullet points
2. **Primary Tools/Systems Used:** List
3. **How This Role Interacts with My Position:** 2-3 sentences
4. **When to Escalate/Collaborate:** Specific scenarios
5. **Top Takeaway:** 1-2 sentences

**Overall Synthesis:**
- How do all these roles work together to support end users?
- Where do I fit in this ecosystem?
- What surprised me most about Company D's structure vs Company H?

---

## Additional Considerations

### **Regular Check-ins**
- **Daily:** Standup participation
- **Weekly:** 15-minute 1-on-1 with supervisor (Weeks 1-4), then biweekly
- **Monthly:** Formal progress review with supervisor and director

### **Training Resources Needed**
- YouTrack documentation/training materials
- Service Desk training guide
- Company D NextGen support runbooks/SOPs
- Documentation templates and standards
- NextGen 8.3.1 upgrade project charter
- Access to Company D knowledge base

### **Buddy System**
- Assign experienced team member as primary resource for questions
- Rotate to second buddy at day 45 for broader exposure

### **Documentation Standards**
- All Company H process documentation should follow Company D templates
- Documentation should be created in YouTrack knowledge base
- Supervisor reviews all documentation before publication

### **NextGen 8.3.1 Upgrade Context**
- Upgrade deadline: June 30, 2026 (5.5 months from onboarding start)
- New Team Member should be familiar with upgrade scope by Day 60
- New Team Member should be contributing to upgrade tasks by Day 90

---

## Appendix: Team Structure Reference

### **NextGen Support Services Department**
- **Total Team Size:** 6 people + 1 supervisor
- **Operations Roles:**
  - Support Coordinators
  - PMCs
  - ECs
  - SAs

### **Technical Team**
- **Total Team Size:** 4 people + 1 supervisor (Director)
- **Technical Roles:**
  - TS
  - DBA
  - NSDs


---

**Document Version:** 1.0
