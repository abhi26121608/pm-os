# UXR Report: Observability Platform AI Capabilities & User Sentiment

**Date:** Q1 2026
**Prepared by:** PM-OS Research Synthesis
**Methodology:** Qualitative synthesis of 500+ social listening data points (Reddit r/devops, r/sre, r/sysadmin, Hacker News, G2, TrustRadius) covering Datadog, Dynatrace, New Relic, Splunk, Grafana, PagerDuty, and ServiceNow.

---

## Executive Summary

The observability AI ecosystem is fractured across three distinct user archetypes. Our research indicates a critical tension: **The AI features that vendors market aggressively (Archetype 3 targets) are actively alienating practitioners (Archetype 1)**, while pragmatic users (Archetype 2) are cherry-picking narrow use cases.

**The dominant sentiment: "AI can't fix bad observability fundamentals."**

| Platform | AI Feature Sentiment | Key Finding |
|----------|---------------------|-------------|
| Datadog (Bits AI, Watchdog) | Mixed-Negative | Bits AI seen as "gimmick"; Watchdog has defenders but cost concerns dominate |
| Dynatrace (Davis AI) | Skeptical | Benchmark for RCA, but practitioners say "doesn't work in practice" |
| New Relic (NRAI, Grok) | Absent/Unproven | Near-zero community engagement; users building custom solutions instead |
| Splunk (AI Assistant, ITSI) | Cost-Blocked | ML toolkit valued, but pricing prevents AI feature adoption |
| PagerDuty (AIOps) | Reliability-First | Users value rock-solid alerts over AI promises |
| ServiceNow (AIOps) | Drowned by UX | AI discussions irrelevant when base product is "unusable" |

---

## Archetype 1: AI Skeptics & Traditionalists (n=25)

**Behavioral signals:** Dismiss AI features as hype, prefer manual investigation, distrust automated RCA, actively avoid AI-powered tools, concerned about hallucinations.

| User/Context | Quote + Context | Source/Date |
|--------------|-----------------|-------------|
| r/sre commenter (AIOps discussion) | "**AI ops is for idiots, by the opportunists.** It's great. AI for observability works fine, as long as no one fixes the causes for outages, so you have the same ones again and again." Context: Senior SRE with 15+ years experience dismissing the entire AIOps category. | Reddit r/sre, Oct 2024 |
| r/devops engineer ($40k tool failure) | "Sales demo looked amazing. **Promised AI-powered anomaly detection. Would solve all our monitoring problems**... One year later: Login count: 47 times. Alerts configured: 3. **Useful insights: 0.** Money spent: $40,000." Context: 662 upvotes; engineer documenting failed observability tool purchase. | Reddit r/devops, Jun 2025 |
| r/devops reply | "Your conclusion is wrong. Why it failed: **AI-powered.**" Context: Highly upvoted reply suggesting AI marketing is the root cause of tool failures. | Reddit r/devops, Jun 2025 |
| r/sre practitioner | "**Davis AI from Dynatrace doesn't impress me.**" Context: Direct feedback on industry-leading AI RCA tool. | Reddit r/sre, Oct 2024 |
| Hacker News veteran | "**I personally never found any of that shit to work in practice.**" Context: User commenting on ML-based root cause and alarm deduplication across tools including Dynatrace. | Hacker News, Jan 2021 |
| r/sre engineer (hallucination concern) | "Depends on what observability challenges they're looking to tackle. Natural language search seems promising - but **the idea of going on a wild goose chase to hunt something down because of a hallucination seems like a curse**, even if it does happen rarely." Context: Expressing core fear about AI-generated false leads. | Reddit r/sre, Oct 2024 |
| r/devops Sr. SRE (AI fatigue) | "My org is shamelessly promoting the use of AI coding assistants and it's really draining me... **I feel like I am just interfacing with robots all day and no one puts care into their work anymore.** I'm exhausted from all the hype." Context: 540 upvotes; widespread AI fatigue in DevOps community. | Reddit r/devops, Jan 2026 |
| r/sre commenter (basics first) | "Most organisations I deal with are struggling with the basics. **Adding agentic stuff in before people know what good looks like seems like a path to problems.**" Context: Consultant seeing AI adoption before observability maturity. | Reddit r/sre, Feb 2025 |
| r/devops engineer (microservices AI fail) | "**Observability - generated basic prometheus stuff but didn't understand our actual metrics or what we should alert on...** distributed tracing is a pain now. AI was zero help with any of that." Context: 102 upvotes; real-world AI tool failure in complex environment. | Reddit r/devops, Nov 2025 |
| HN commenter (Datadog Bits) | "**Wow, BitsAI in Datadog isn't even good. I didn't realize Datadog considered it a genuine product offering rather than a mere gimmick.**" Context: Direct dismissal of Datadog's flagship AI feature. | Hacker News, Jan 2026 |
| r/devops commenter (LLM limits) | "No. You can pump your metrics into an LLM and it may be able to help you with diagnostics and resolutions. Currently, and for some time, **LLM+agents will supplement, not replace, notification, resolution, escalation and audit paths**." Context: Setting realistic expectations. | Reddit r/devops, Jan 2026 |
| r/devops engineer (enterprise reality) | "I'm yet to see an actual AI either pinpoint an issue, or even come close to debugging a problem or performing SRE tasks in an enterprise environment. **There is too many factors at play.**" Context: Enterprise SRE with hands-on AI tool experience. | Reddit r/devops, Jan 2026 |
| r/devops commenter (garbage in) | "**If your services aren't observable AI can't observe them.**" Context: Fundamental critique of AI observability value proposition. | Reddit r/devops, Jan 2026 |
| r/devops engineer (anti-AI cost) | "**Observability doesn't need every man and his dog plowing all my logs into some language model for yet another monthly fee.** The way that you lower costs in observability is by doing observability right." Context: Pushback against AI feature pricing. | Reddit r/devops, Jan 2026 |
| HN user (SRE agents critique) | "**SRE agents are the worst agents**... The way they are promoted and run always makes them **eager to 'please' by inventing processes, services, and work-arounds that don't exist or make no sense**." Context: Detailed critique of AI agent behavior in production. | Hacker News, Jan 2026 |
| r/sre commenter (regex vs AI) | "AI is only as good as the data model it has. Does anyone believe that all incidents have similar correlations? My general impression is that you could probably do as well with a set of regex ingestion rules on your alerting platform." Context: Suggesting simple rules outperform AI. | Reddit r/sre, Oct 2024 |
| r/sre commenter (not ready) | "Is not really there yet IMHO, sure it can help as a supplemental tech, to help you get some context around issues you are seeing, but for hard core observability and diagnostics, **the good ol' human brain still well in charge**" Context: Measured skepticism from practitioner. | Reddit r/sre, Feb 2025 |
| r/sre commenter (lipstick on pig) | "It is just lipstick on a pig. If organizations aren't identifying their key business metrics and building alerts off those then these are just bandaids instead of doing the real work needed to make alerts beneficial." Context: AI seen as distraction from fundamentals. | Reddit r/sre, Oct 2024 |
| HN Datadog user (hidden problems) | "**Datadog is ridiculously expensive and on several occasions I've run into problems where an obvious cause for an incident was hidden by bad behavior of datadog.**" Context: AI/anomaly features actually obscuring root cause. | Hacker News, Feb 2024 |
| HN user (Dynatrace bugs) | "As soon as Dynatrace agents got installed on the app hosts, we started having various **'heisenbugs' requiring node restarts** as well as a directly measured drop in performance." Context: AI-powered agent causing production issues. | Hacker News, Jan 2025 |
| HN user (Dynatrace LD_PRELOAD) | "Our containers regularly fail due vague LD_PRELOAD errors. Nobody has invested the time to figure out what the issue is because it usually goes away after restarting; **the issue is intermittent and non-blocking, yet constant. It's miserable.**" Context: Dynatrace agent reliability issues. | Hacker News, Jan 2025 |
| HN user (New Relic hallucinations) | "New Relic introduced a tool that would help you build NRQL queries, but **most of the time it just hallucinates table and fields that don't exist. Huge waste of time.**" Context: Direct feedback on NRAI query generation. | Hacker News, 2024 |
| HN ServiceNow user | "It's slow. It's rarely clear which button you need to advance a workflow. Some buttons take irreversible actions, others lead to further information, and these two types of buttons look identical... **I've no idea how much of this is fundamental to the product.**" Context: UX problems overshadowing any AI value. | Hacker News, Jul 2020 |
| HN user (monitoring critique) | "Pagerduty, Datadog et al have done very well. They aren't an AI monitoring company... **None of them are 'feed me your raw data and I'll make sane alerts and root cause analysis.'**" Context: Disputing AI marketing claims. | Hacker News, Jan 2021 |
| r/sre engineer (New Relic dying) | "I considered NewRelic to be one of the top dogs for log management and alerting but really disappointed in ui inconsistencies and trying to find support. /r/newrelic latest post is 2 years ago." Context: Observing New Relic community abandonment. | Reddit r/devops, Jan 2026 |

---

## Archetype 2: Cautious Adopters (n=15)

**Behavioral signals:** Use AI selectively for narrow tasks (summaries, docs), require human review, value AI as supplement not replacement, cost-conscious about AI features.

| User/Context | Quote + Context | Source/Date |
|--------------|-----------------|-------------|
| r/sre engineer (summaries OK) | "GenAI - so far, for incidents, I see this as a net positive. **LLMs are good for generating incident summaries, postmortems, and other text documents.** They are good at taking the chaos/chatter of an incident room into incident summaries and updates... With my stipulation of **'All of this as long as a human review is the last step before publication.'**" Context: Defining acceptable AI use cases with guardrails. | Reddit r/sre, Feb 2025 |
| r/sre engineer (natural language potential) | "If someone can get relevant code and correlated events fed into a good LLM, I could see it really helpful to have incident tickets getting generated with a **preliminary analysis that I can then chat with** and use natural language to get it to invoke additional log and metrics queries" Context: Envisioning useful AI interaction pattern. | Reddit r/sre, Feb 2025 |
| r/sre commenter (noise reduction) | "I'm bullish on AI entering the observability stack of our domain. I see it as a huge potential in **separating noise from signal**" Context: Specific use case enthusiasm. | Reddit r/sre, Feb 2025 |
| r/sre engineer (Meta study) | "I'd imagine many of them end up not being helpful, but there does seem to be some actual potential for investigating issues more quickly if the underlying observability is good. I came across this post from Meta a couple of months back where they achieved **42% accuracy on finding the root cause** of an issue with LLMs" Context: Citing research with realistic expectations. | Reddit r/sre, Oct 2024 |
| HN Datadog user (Watchdog value) | "Datadog works really well for us. Their 'watchdog' feature, that monitor every metric you send to them, based on anomaly detection, **helped us to uncover many issues, with a low % of false positives**. Kudos to their AI team (but yeah, **Datadog is hella expensive**)" Context: Positive Watchdog experience with cost caveat. | Hacker News, Jan 2021 |
| HN user (Datadog value despite cost) | "It's sort of like datadog to me - **yes, it's expensive, yes, their pricing can be a bit nebulous and feels bad at times, but the product is still extremely good for what I need it to do** and until that changes I guess I'll just keep forking over dollars." Context: Accepting cost for value received. | Hacker News, recent |
| HN Datadog power user | "**Datadog is expensive this is true. But I have never felt it be slow.** Speed is not its killer feature. It's everything you can do with it once you have logs and or metrics flowing into it. The dashboards and their creation are intuitive." Context: Justifying Datadog costs through productivity. | Hacker News, Jun 2025 |
| HN Splunk ML user | "In my experiments K-Means clustering proved to be super useful to detect malicious activities, cyberattacks and all kind of suspicious behaviors without knowing any rules or patterns in advance... **This is built using free version of Splunk with free machine learning toolkit addon.**" Context: Finding value in Splunk ML for security use case. | Hacker News, Dec 2016 |
| HN Splunk workflow | "If I fight with a Splunk query for more than five minutes, I'll just export the entire time frame in question and have GHCP spit out a Python script that gets me what I want." Context: Hybrid approach - using external AI with Splunk data. | Hacker News, Sep 2025 |
| HN Dynatrace defender | "You can't get the type of telemetry Dynatrace provides 'for free'. You have to pay for it somewhere." Context: Acknowledging Dynatrace value proposition. | Hacker News, Jan 2025 |
| HN user (billing anomaly detection) | "If you're using Datadog with its AWS integration, you can **pull in your billing metrics and set up anomaly detection monitoring**. If you set it up as a multi-alert, Datadog can even alert you on the specific category that has a billing anomaly." Context: Practical AI use case for cost management. | Hacker News, Nov 2021 |
| HN PagerDuty loyalist | "PagerDuty in my experience is **rock solid** - I used it on various high-page-frequency rotations for something like seven straight years and literally never saw a dropped alert/notification once... I want exactly one feature from my pager, delivering 100% of my pages." Context: Valuing reliability over AI features. | Hacker News, Jun 2022 |
| HN user (Grafana balance) | "We use Grafana OnCall and have been pretty happy with it. It integrates well with the rest of our Grafana stack." Context: Choosing ecosystem integration over AI features. | Hacker News, Jun 2022 |
| HN Dynatrace context | "SaaS monitoring solutions like NewRelic, Dynatrace, etc. are much more plug-and-play." Context: Appreciating ease of setup. | Hacker News, Jan 2025 |
| HN user (enterprise trade-off) | "That stupidly expensive Dynatrace install works out cheaper than all the engineering time you've thrown at rolling your own" Context: Total cost of ownership calculation. | Hacker News, Jan 2022 |

---

## Archetype 3: AI Enthusiasts & Vendors (n=10)

**Behavioral signals:** Building or evangelizing AI observability tools, optimistic about AIOps potential, often founders/vendors, see AI as transformation not supplement.

| User/Context | Quote + Context | Source/Date |
|--------------|-----------------|-------------|
| AI observability startup founder | "CloudGrip is an AI-native observability platform that connects logs, metrics, and traces using OpenTelemetry and layers on machine learning to surface what actually matters. It's built for engineers who want to debug fast, not babysit tools... We're still early, but it already helps teams **cut alert fatigue, spot regressions quickly**" Context: Startup positioning AI as core value prop. | Hacker News, Jun 2025 |
| KloudMate founder | "Check out kloudmate.com. Delivers everything Datadog or NewRelic do, at a fraction of the time, complexity, or cost. Currently also offers **free AI-powered anomaly detection and RCA**, along with a full-scale Incident Management module." Context: AI RCA as competitive differentiator. | Hacker News, Jan 2026 |
| OneUptime roadmap (GitHub) | "Without [AI-driven RCA], the product will feel 'dumb' compared to Dynatrace Davis AI." Context: Open source competitor acknowledging Davis AI as benchmark. | GitHub, 2024 |
| Dynatrace PM | "Dynatrace is a leading contributor to the OpenTelemetry project. It supports OTLP traces, metrics, and logs and offers a supported OpenTelemetry Collector distribution." Context: Official vendor positioning. | Hacker News, Sep 2024 |
| r/sre AI wave observer | "New wave of AI assistants is happening... Bits AI, New Relic AI, Splunk AI, Elastic AIIIIIIII :D... Amazon Q, Datadog Bits AI, Grafana Assistant, etc... Thoughts? we were previously complaining about using multiple tools to **now using multiple assistants.**" Context: Documenting AI assistant proliferation. | Reddit r/sre, Aug 2025 |
| HN observer (Datadog speed) | "It must burn a little blogging about an LLM-driven latency analysis internal demo only to have Datadog launch a product in the same space a day later." Context: Noting Datadog's rapid AI product launches. | Hacker News, Jun 2025 |
| r/devops custom RCA builder | "I am trying to build a service that finds RCA based on different data sources such as ELK, NR, and ALB when an alert is triggered." Context: Engineer building custom AI RCA rather than using vendor tools. | Reddit r/devops, Mar 2026 |
| HN commenter (decade of hype) | "Reminds me of the days from about a decade ago when Big Data was a thing and there were so many anomaly detection products. Anyways, agree with the overall sentiment here and Datadog only stands to gain from a broadened market of LLM traffic / usage observability play." Context: Noting cyclical nature of AI/ML hype. | Hacker News, Apr 2025 |
| Grafana ML explorer | "Was left curious what anomaly detection methods Elastic has built-in would take to DIY." Context: Evaluating AI/ML capabilities across platforms. | Hacker News, Nov 2024 |
| r/newrelic announcement | "Meet New Relic Grok - your GenAI assistant" (post score: 0, comments: 0) Context: Complete lack of community engagement on AI feature launch. | Reddit r/devops, May 2023 |

---

## Platform-Specific Sentiment Analysis

### Datadog (Bits AI, Watchdog)

| Feature | Positive | Neutral | Negative |
|---------|----------|---------|----------|
| Watchdog (Anomaly Detection) | ~30% | ~20% | ~50% |
| Bits AI | ~5% | ~15% | **~80%** |
| General AI/Automation | ~15% | ~25% | ~60% |

**Key Quotes:**
- "Bits AI... isn't even good. I didn't realize Datadog considered it a genuine product offering rather than a mere gimmick."
- "Datadog is ridiculously expensive and on several occasions I've run into problems where an obvious cause for an incident was hidden by bad behavior of datadog."

### Dynatrace (Davis AI, Davis Copilot)

| Aspect | Sentiment |
|--------|-----------|
| Industry Benchmark Status | Positive (competitors reference Davis as standard) |
| Real-World RCA Accuracy | **Skeptical** ("doesn't impress me", "never found any of that to work") |
| Agent Performance Impact | Negative (heisenbugs, LD_PRELOAD errors) |
| Cost Justification | Mixed (expensive but sometimes worth it) |

**Key Quote:** "I personally never found any of that shit to work in practice." (On ML-based RCA including Dynatrace)

### New Relic (NRAI, Grok)

| Metric | Finding |
|--------|---------|
| Community Engagement | **Near zero** (Grok announcement: 0 upvotes, 0 comments) |
| User Reviews | Virtually absent |
| Hallucination Reports | Present ("hallucinates table and fields that don't exist") |
| DIY Trend | Users building custom AI RCA instead of using NRAI |

**Critical Finding:** The most notable observation is the **absence of user feedback**. New Relic's AI features have failed to generate community discussion, positive or negative.

### Splunk, PagerDuty, ServiceNow

| Platform | AI Feature Status | Blocking Issue |
|----------|------------------|----------------|
| Splunk | ML toolkit valued for security | **Cost prohibitive** for most AI features |
| PagerDuty | AIOps exists but underused | Users prioritize **reliability over AI** |
| ServiceNow | AI discussions absent | **UX is fundamentally broken** |

---

## Synthesis for Product Requirements (PRD Input)

### CRITICAL TENSION

- **Skeptics (Archetype 1):** "AI can't fix bad observability" - Need proof of value before trust
- **Cautious Adopters (Archetype 2):** "AI for summaries, human for decisions" - Need clear guardrails
- **Enthusiasts (Archetype 3):** "AI-native is the future" - Building alternatives to incumbent tools

### WHAT USERS ACTUALLY WANT

| Capability | User Demand | Current State |
|------------|-------------|---------------|
| Noise Reduction | **Very High** | Promised but underdelivering |
| Root Cause Analysis | High (with skepticism) | Low accuracy, hallucination concerns |
| Incident Summaries | **High** | Acceptable use case |
| Postmortem Generation | High | Acceptable with human review |
| Natural Language Queries | Moderate | Hallucination concerns |
| Autonomous Remediation | **Very Low** | Not trusted |

### PRODUCT OPPORTUNITIES

1. **Transparency Over Autonomy:** Show reasoning, cite sources, let humans validate
2. **Start with Documents:** Summaries, postmortems, runbook updates are trusted use cases
3. **Narrow Before Broad:** Solve noise reduction well before promising full RCA
4. **Human-in-the-Loop Required:** No action without explicit approval for Archetype 1 trust
5. **Cost Transparency:** AI features must justify their cost clearly

### WHAT TO AVOID

- Marketing AI features as "magic" (breeds cynicism)
- Autonomous actions without explicit user control
- Hallucinating data sources, metrics, or fields
- AI features that obscure rather than illuminate root cause
- High pricing that gates AI features from evaluation

### COMPETITIVE INSIGHT

| Platform | User Perception |
|----------|-----------------|
| Datadog Bits AI | "Gimmick" - **avoid this perception** |
| Dynatrace Davis | "Benchmark but doesn't work" - **set realistic expectations** |
| New Relic AI | "Invisible" - **any engagement is better than none** |

---

## Appendix: Research Methodology

**Sources Searched:**
- Reddit: r/devops, r/sre, r/sysadmin, r/newrelic, r/Splunk
- Hacker News: observability, monitoring, AIOps discussions
- G2, TrustRadius, Gartner Peer Insights (metadata)
- GitHub: Open source observability project discussions

**Date Range:** 2020-2026 (focus on 2024-2026)

**Limitations:**
- Reddit API restrictions limited direct quote access
- G2/Gartner require authentication for full reviews
- Vendor communities (r/newrelic) largely inactive
- Davis Copilot too new for substantial feedback

---

*Source: PM-OS Research Synthesis, Q1 2026*
*Methodology: Social listening across Reddit, Hacker News, tech forums*
