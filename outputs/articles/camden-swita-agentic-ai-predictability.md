# How to design agentic AI systems for predictability, not just autonomy

*By Camden Swita, Head of AI and Machine Learning, New Relic*

---

An AI agent logged into a production database at 2:47am. It was supposed to clean up stale records. Instead, it deleted 340,000 rows from a table it wasn't supposed to touch.

The incident took six engineers 11 hours to diagnose and reverse. Not because recovery was technically hard. Because nobody could tell them, definitively, what the agent had actually decided and why.

That's agentic AI's real production problem. Not capability. Visibility.

Quote me on this:

> **If your engineering team can't explain exactly what an agent decided, why it decided it, and what it touched downstream, you don't have an AI system. You have an autonomous liability.**

I've spent the last two years building and operating AI systems at New Relic, where our platform sits inside production environments for thousands of companies. Here's what I've learned the hard way.

*This is the most practical framework I know for building agentic AI you can actually trust:*

1. The 3 generations of AI risk, and why generation 3 is different
2. The brutal math behind agentic failures
3. The ILTI framework: observability for non-deterministic systems
4. The 3-filter ROI test before you deploy
5. Escalation design that actually works in production
6. Orchestration patterns that scale
7. What great looks like vs. what most teams build

---

## 1. The 3 generations of AI risk

Enterprise AI risk has gone through three distinct phases. Most teams are applying generation 1 thinking to a generation 3 problem.

---
> 📸 **[IMAGE 1 — Generate with ChatGPT/Gemini]**
>
> **Prompt:** "Create a clean infographic titled '3 Generations of Enterprise AI Risk' as a horizontal timeline with 3 stages connected by arrows. Stage 1: label 'Generation 1: Rule-based (1990s–2010s)', subtitle 'Deterministic. Fully auditable.', small risk badge in teal reading 'LOW RISK'. Stage 2: label 'Generation 2: ML + Chat AI (2010s–2023)', subtitle 'Probabilistic. Single-step.', small risk badge in yellow reading 'MEDIUM RISK'. Stage 3: label 'Generation 3: Agentic AI (2024–now)', subtitle 'Autonomous. Multi-step. Compounding.', small risk badge in coral red reading 'HIGH RISK'. DESIGN SYSTEM: Background #0A0F1E deep navy. All text white. Stage cards with subtle #1A2540 fill and rounded corners. Accent color #00C8FF electric blue for arrows and stage numbers. Risk badges use teal #00D4A0, amber #F5A623, coral #FF4D4D respectively. Font: clean sans-serif bold for headers, regular for subtitles. No gradients. No stock photos. No clipart."
---

**Generation 1: Rule-based systems**
If X, then Y. Explicit logic. Fully auditable. When something went wrong, you found the rule and fixed it. Risk was contained, traceable, and fixable.

**Generation 2: ML and chat AI**
Models started making predictions. Outputs became probabilistic. But the interaction was still single-step: input in, output out. If the model gave a bad answer, that was the entire blast radius.

**Generation 3: Agentic AI**
This is where we are now. Agents interpret goals, select tools, retrieve context, and execute sequences of actions across live infrastructure. A single run might involve 20 tool calls across 8 systems before a human sees anything.

The problem isn't that agents make mistakes. It's that mistakes compound.

A wrong inference in step 3 shapes the context for step 7. By step 12, you're looking at a failure that traces back to an ambiguous instruction four hours ago, running through six different APIs.

Going from generation 2 to generation 3 isn't an upgrade. The risk model changes entirely.

---

## 2. The brutal math behind agentic failures

Large organizations lose an average of **$9,000 per minute** during unplanned outages, according to [Splunk's Hidden Costs of Downtime report, co-authored with Oxford Economics](https://www.splunk.com/en_us/form/the-hidden-costs-of-downtime.html). For financial services the number is higher. For e-commerce at peak it's basically uncapped.

The [New Relic 2025 Observability Forecast](https://newrelic.com/resources/report/observability-forecast/2025) puts it even more bluntly: **many high-impact outages now cost $2 million per hour**. Full-stack observability cuts that financial hit in half.

And we're deploying agentic systems into environments that still don't have full coverage. Our research at New Relic shows nearly three-quarters of organizations lack full-stack observability — a unified view across applications, infrastructure, clouds, and services. Blind spots already exist. Autonomous agents make those blind spots dangerous in a new way.

Now add agents.

Research from Princeton shows that focused coding agents average 30+ actions per task on standard software engineering benchmarks. ([SWE-agent, Yang et al., 2024](https://arxiv.org/abs/2405.15793)) That's a contained, single-system task. An enterprise incident response workflow spans log retrieval, trace correlation, alert deduplication, root cause analysis, and remediation steps across multiple live systems. The action count is higher. Run dozens of these workflows in parallel and you're looking at thousands of autonomous actions per hour across systems you're already watching through imperfect telemetry.

---
> 📸 **[IMAGE 2 — Generate with ChatGPT/Gemini]**
>
> **Prompt:** "Create a stat-block infographic titled 'The Brutal Math of Agentic Failures'. Show 4 large cards in a 2x2 grid. Card 1: large text '$9,000/min', subtitle 'avg cost of an IT outage — Splunk 2024'. Card 2: large text '$2M/hr', subtitle 'high-impact outages — New Relic 2025'. Card 3: large text '30+', subtitle 'agent actions per task, single-system (SWE-agent, Princeton 2024) — enterprise multi-system workflows run longer'. Card 4: large text '72 hrs+', subtitle 'avg time to detect silent agent drift'. Below the grid, a full-width banner with text: 'Every untraced agent action is a liability you have deferred, not eliminated.' DESIGN SYSTEM: Background #0A0F1E deep navy. Card fill #1A2540 with rounded corners. Large stat numbers in electric blue #00C8FF. Subtitles in white, small regular weight. Banner background #FF4D4D coral red, text white bold. Font: clean sans-serif. No gradients. No icons. No stock photos."
---

| Factor | Number |
|---|---|
| Average IT outage cost per minute | $9,000 (Splunk & Oxford Economics, 2024) |
| High-impact outage cost per hour | $2 million (New Relic 2025 Observability Forecast) |
| Agent actions per coding task (SWE-bench baseline) | 30+ (SWE-agent, Princeton 2024) |
| Average hours before silent drift is detected | 72+ *(internal estimate; needs published validation)* |

The failure mode that scares me most isn't the dramatic crash. It's gradual drift. An agent runs correctly for six weeks, then starts behaving slightly differently. Nobody catches it for three more weeks. By the time you investigate, you're tracing an impact that started 45 days ago and touched 12 systems. Every agentic action that isn't traced is a liability you've deferred, not eliminated.

---

## 3. The ILTI framework: observability for non-deterministic systems

Traditional observability is built around MELT: metrics, events, logs, traces. It works for deterministic systems. You know what the system should do, and you watch to see if it does it.

Agentic AI breaks this.

Agents are non-deterministic. The same goal, the same context, can produce different action sequences on different runs. You can't just monitor outputs. You have to capture the reasoning layer.

*That's what I call the ILTI framework.* Every agent action should emit telemetry across four dimensions:

---
> 📸 **[IMAGE 3 — Generate with ChatGPT/Gemini]**
>
> **Prompt:** "Create a layered stack diagram titled 'The ILTI Framework: Observability for Agentic AI'. Show 4 horizontal bars stacked vertically, each a slightly lighter shade of navy from bottom to top. Bar 1 (bottom): large letter 'I' in electric blue, label 'Intent — The goal the agent was given'. Bar 2: large letter 'L', label 'Logic — Context and reasoning steps taken'. Bar 3: large letter 'T', label 'Tools — APIs, services, and databases invoked'. Bar 4 (top): large letter 'I', label 'Impact — Downstream changes and configs altered'. On the right side, a vertical bracket with label in coral red: 'Most teams only capture these two' pointing to bars 3 and 4. On the left side, a vertical bracket in teal: 'Production-ready teams capture all 4' spanning all bars. DESIGN SYSTEM: Background #0A0F1E. Bar fills from #1A2540 (bottom) to #2A3F6F (top), rounded corners. ILTI letters in electric blue #00C8FF bold. Label text white. Right bracket coral #FF4D4D. Left bracket teal #00D4A0. Font: clean sans-serif. No gradients. No icons."
---

| Layer | What to capture | Why it matters |
|---|---|---|
| **I - Intent** | The goal the agent was trying to achieve | Without this, you can't evaluate whether the action was appropriate |
| **L - Logic** | Input context and reasoning steps taken | This is where drift becomes visible before it becomes damage |
| **T - Tools** | Which APIs, services, databases were invoked | The audit trail that proves what actually changed |
| **I - Impact** | Downstream changes and configs altered | The blast radius map for any given agent run |

Most teams capture Tools and sometimes Impact. Almost nobody captures Intent and Logic at the moment of the action. That's the gap that turns a recoverable incident into an 11-hour investigation with six engineers.

There's a specific failure mode worth calling out: silent retries. An agent that silently retries an action, applies an incorrect configuration, or makes an unexpected approval can introduce risk without triggering any traditional alert. It's not a crash. It's a quiet wrong turn that only shows up later in the data.

ILTI is also what makes drift detection possible. Once you have logic baselines — a record of what "normal" execution looks like for a given agent — you can run four types of ongoing checks:

- **Real-time anomaly detection:** Spot deviation from normal execution paths instantly, not via customer complaint
- **Logic baselines:** Compare current reasoning patterns against known-good states from prior runs
- **Policy guardrails:** Automate detection when an agent's goal or actions violate compliance rules
- **Impact correlation:** Trace telemetry across the full stack to distinguish agent-driven changes from organic system noise

When observability is done well, teams don't just detect failures — they prevent them.

In practice, ILTI means instrumenting at the framework level, not just the API level. If you're using LangChain, LlamaIndex, or a custom orchestrator, every reasoning step should emit an OpenTelemetry span — capturing the agent's goal, the context it was working with, the tool it invoked, and the result it got. ([OpenTelemetry GenAI semantic conventions](https://opentelemetry.io/docs/specs/semconv/gen-ai/gen-ai-spans/))

Teams with full ILTI data can ask: "Over the last 30 days, when our incident triage agent escalated versus resolved, what was the reasoning, and were those calls correct?" That's how you improve agent performance. Not guesswork. Traced evidence.

---

## 4. The 3-filter ROI test before you deploy

The teams that get into trouble fastest ask "what can we automate?" before asking "what should we automate?"

Here's the test I run before committing any workflow to agentic automation. All three filters have to pass.

---
> 📸 **[IMAGE 4 — Generate with ChatGPT/Gemini]**
>
> **Prompt:** "Create a vertical decision flowchart titled 'The 3-Filter ROI Test'. Show 3 diamond-shaped decision nodes stacked vertically, connected by arrows. Node 1: 'Filter 1 — Is human effort the real bottleneck?' YES arrow continues down, NO arrow exits right to a card labeled 'Stop. Wrong use case.' Node 2: 'Filter 2 — Can you measure success in numbers?' YES arrow continues down, NO arrow exits right to same 'Stop.' card. Node 3: 'Filter 3 — Is your data real-time and authoritative?' YES arrow leads to a final card labeled 'Deploy with confidence', NO arrow exits right to a card labeled 'Fix your data pipeline first.' DESIGN SYSTEM: Background #0A0F1E deep navy. Diamond nodes fill #1A2540, border electric blue #00C8FF, text white. YES arrows in teal #00D4A0. NO arrows in coral #FF4D4D. Stop cards fill coral. Deploy card fill teal. Font: clean sans-serif bold for node text. No gradients. No stock photos."
---

**Filter 1: Is human effort actually the bottleneck?**
Incident triage, change intelligence, and operational recommendations pass this test easily. A senior engineer might spend 45 minutes pulling logs, correlating traces, and assembling context before diagnosing anything. An agent can do that in 90 seconds with better recall. Things that fail this filter: creative judgment calls, relationship-sensitive communication, any decision where knowing the room matters more than knowing the data.

**Filter 2: Can you define "good" in numbers?**
MTTR reduction. False positive rate on escalations. Cost per resolved ticket. If you can't define success numerically, you can't tell whether the agent is getting better or worse. And when someone questions the investment — and they will — you have nothing.

**Filter 3: Do you have real-time, authoritative data?**
An agent working off a metrics pipeline that's 20 minutes delayed, or log data missing 15% of events due to sampling, will produce confident-sounding decisions that are wrong in hard-to-catch ways.

Quick check: take the last 10 incidents your team resolved. Could an agent have accessed all the data your engineers used to diagnose them? If the answer is no for more than half, you're not ready.

The irony of Filter 3 is it forces you to fix your data infrastructure first. That's not a tax on AI. It's instrumentation you should've built years ago.

---

## 5. Escalation design that actually works in production

Most HITL implementations land in one of two failure modes.

Too aggressive: agents ask for approval on every significant action, teams rubber-stamp without reading. You end up with the illusion of control, not the substance of it.

Completely absent: agents run autonomously, failures surface hours later, no way to intervene mid-run.

The right model is threshold-based escalation. Three signals drive it:

**Confidence.** Good agents know when they're uncertain. If confidence drops below a threshold, the agent pauses and surfaces it to an operator. OpenAI's structured outputs and Anthropic's extended thinking modes both give you ways to extract this signal. If you're not capturing agent confidence, you're missing the most actionable escalation trigger available.

**Blast radius.** Every proposed action should carry an estimate of what it could affect. Read query: low. Config change: medium. Database write: high. Set thresholds per category and auto-escalate when the agent proposes something in the high zone.

**Novelty.** If the agent hits a situation that matches nothing in its historical action log, that's a flag. An agent that encounters something genuinely new and keeps going is more dangerous than one that stops and asks.

---
> 📸 **[IMAGE 5 — Generate with ChatGPT/Gemini]**
>
> **Prompt:** "Create a threshold zone diagram titled 'The 3 Escalation Signals'. Show a horizontal layout with 3 stacked risk zones. Bottom zone (wide, teal fill): label 'LOW RISK — Agent handles autonomously'. Middle zone (medium, amber fill): label 'MEDIUM — Confidence drops or novelty detected → Surface to operator'. Top zone (narrow, coral fill): label 'HIGH — Large blast radius action → Auto-escalate, require human approval'. To the right of the zones, show two labeled failure modes in small cards: one card in muted red labeled 'Failure Mode A: Too aggressive — teams rubber-stamp everything'; one card in muted orange labeled 'Failure Mode B: Fully absent — failures discovered via production outage'. DESIGN SYSTEM: Background #0A0F1E deep navy. Zone fills: teal #00D4A0 at 40% opacity, amber #F5A623 at 40% opacity, coral #FF4D4D at 40% opacity. Zone text white bold. Failure mode cards #1A2540 with rounded corners, border in respective zone color. Font: clean sans-serif. No gradients. No icons."
---

An agent that knows when to stop is more trustworthy than one that always pushes forward.

And here's the counterintuitive part: good escalation design makes agents more autonomous over time, not less. When operators see intelligent escalation, they start approving faster. Trust accumulates, exactly the way it does with a new hire who asks the right questions.

This is how the human role evolves. The goal isn't to remove humans from the loop. It's to elevate them — to make engineers stewards of systems that can explain their own behavior and surface their own risks. Agents handle the repetitive, data-intensive execution. Humans focus on why a decision matters, not how to execute it.

Trust in automation isn't earned once. It's earned continuously through transparency.

---

## 6. Orchestration patterns that scale

Connecting agents and tools is the easy part. The hard part is designing what happens when things go wrong: dependencies fail, outputs are ambiguous, retries create duplicate state. That's where most teams underinvest.

Three patterns separate teams running agentic AI reliably from teams constantly firefighting.

**Explicit dependency graphs.** The most common orchestration mistake is agents that implicitly depend on each other's outputs without declaring those dependencies. Agent A produces a summary. Agent B consumes it. Nobody documents the relationship. When Agent A's behavior shifts subtly, Agent B starts producing garbage. Nobody knows why for two weeks.

Good orchestration versions every input an agent consumes and monitors it. When upstream output quality changes, downstream agents get an alert. Not a silent degradation two weeks later.

**Idempotency by default.** Agentic systems fail and retry. If running the same action twice produces different results, you get data corruption and state drift. Every action touching a stateful system should be idempotent by design. This is standard distributed systems practice, but teams skip it for AI workloads because "the agent handles it." It doesn't. You have to design for it.

**Evaluation pipelines tied to business metrics.** Without this, you're relying on production incidents to tell you something went wrong. Too late. Run evaluation pipelines weekly against labeled datasets of known-good and known-bad decisions. Tie metrics to MTTR reduction, incident avoidance rate, false escalation rate.

Microsoft's [AutoGen](https://github.com/microsoft/autogen) is worth studying here for multi-agent orchestration, including built-in evaluation tooling.

Teams that get orchestration right see concrete results: fewer production incidents, faster root cause analysis, more predictable automation outcomes, and enough confidence to keep expanding what agents handle. The ones who skip it find the opposite — tasks that run longer and cost more than expected, with scope that drifts beyond what anyone authorized.

One underappreciated risk: without explicit scope boundaries, cost controls, and access to authoritative data, even well-orchestrated agents can produce fast results that nobody can actually verify. Speed without traceability is its own liability.

---

## 7. What great looks like vs. what most teams build

---
> 📸 **[IMAGE 6 — Generate with ChatGPT/Gemini]**
>
> **Prompt:** "Create a split comparison table titled 'Agentic AI: What Most Teams Build vs. What Works in Production'. Two columns. Left column header: 'What Most Teams Do' with a subtle coral underline. Right column header: 'Production-Ready Teams' with a subtle teal underline. Show 7 alternating rows (alternating between #0A0F1E and #1A2540 row fill): Row 1 — Observability: 'Monitor API success/failure' | 'Full ILTI trace per agent run'. Row 2 — Escalation: 'Manual review' | 'Threshold-based auto-escalation'. Row 3 — Failure detection: 'Customer complaint' | 'Drift detection via logic baselines'. Row 4 — Evaluation: 'It seems to be working' | 'Weekly evals tied to MTTR'. Row 5 — Dependencies: 'Implicit agent chains' | 'Explicit versioned dependency graphs'. Row 6 — Data quality: 'Deploy on existing telemetry' | 'Audit data pipeline before deployment'. Row 7 — Blast radius: 'No scope limits per agent' | 'Explicit constraints on what each agent can touch'. Left column values in muted coral. Right column values in teal. Row labels in white regular weight, left-aligned. DESIGN SYSTEM: Background #0A0F1E. Coral #FF4D4D. Teal #00D4A0. Font: clean sans-serif. No icons. No gradients."
---

| Dimension | What most teams do | What production-ready teams do |
|---|---|---|
| **Observability** | Monitor API call success/failure | Capture full ILTI trace per agent run |
| **Escalation** | Manual review of flagged outputs | Threshold-based auto-escalation with confidence signals |
| **Failure detection** | Customer complaint or alert | Drift detection via logic baselines |
| **Evaluation** | "It seems to be working" | Weekly eval runs against labeled datasets |
| **Dependencies** | Implicit agent chains | Explicit dependency graphs with versioning |
| **Data quality** | Deploy on existing telemetry | Audit and fix data pipeline before deployment |
| **Blast radius** | No scope limits per agent | Explicit constraints on what each agent can touch |

The teams in the right column aren't more cautious. They're faster. When something goes wrong, they fix it in hours, not days.

---

## The engineering choice that defines the next 3 years

Gartner named agentic AI one of its [Top Strategic Technology Trends for 2025](https://www.gartner.com/en/articles/top-technology-trends-2025), projecting it'll be embedded in 40% of enterprise applications by end of 2026, up from less than 5% today. That's the steepest enterprise adoption curve since cloud.

---
> 📸 **[IMAGE 7 — Generate with ChatGPT/Gemini]**
>
> **Prompt:** "Create a closing statement graphic with two sections. Top section: large bold white text 'Build for visibility. Everything else follows.' centered on a #0A0F1E navy background. Bottom section: a horizontal bar chart titled 'Enterprise AI Agent Adoption' with two bars. Bar 1: label '2025', value '5%', short bar in muted #1A2540. Bar 2: label '2026 (projected)', value '40%', tall bar in electric blue #00C8FF. Source credit in small white text: 'Source: Gartner Top Technology Trends 2025'. A thin electric blue horizontal rule divides the two sections. DESIGN SYSTEM: Background #0A0F1E throughout. All text white. Accent #00C8FF. Font: clean sans-serif, headline bold extra-large, chart labels regular. No gradients. No icons. No stock photos. Minimal whitespace, professional."
---

I keep coming back to this: the teams shipping agentic AI reliably in 2026 aren't the ones who moved fastest. They're the ones who built observability in from day one, before anything broke.

The difference isn't intelligence or budget. It's whether the team decided at the start to treat agentic AI like any other mission-critical system: full tracing, explicit escalation logic, evaluation pipelines tied to real outcomes. I've seen both patterns play out. The gap between them, in incident resolution time alone, is measured in days.

Agentic AI is genuinely powerful. The teams that capture it will be the ones who can see what their agents are doing, explain why they did it, and prove it worked.

**Build for visibility. Everything else follows.**

---

## Citations reference

| Claim | Source | Direct URL | Status |
|---|---|---|---|
| ~74% of orgs lack full-stack observability | New Relic research (cited by Camden Swita in original article) | https://newrelic.com/resources/report/observability-forecast/2025 | ⚠️ Confirm exact stat in report before publishing |
| $9,000/min IT outage cost | Splunk & Oxford Economics, 2024 | https://www.splunk.com/en_us/form/the-hidden-costs-of-downtime.html | ✅ Verified |
| $2M/hour high-impact outage cost | New Relic 2025 Observability Forecast | https://newrelic.com/resources/report/observability-forecast/2025 | ✅ Verified |
| 40% enterprise apps with agents by 2026 | Gartner Top Technology Trends 2025 | https://www.gartner.com/en/articles/top-technology-trends-2025 | ⚠️ URL valid but gated — verify before publishing |
| OpenTelemetry GenAI spans spec | OpenTelemetry | https://opentelemetry.io/docs/specs/semconv/gen-ai/gen-ai-spans/ | ✅ Verified |
| Microsoft AutoGen framework | Microsoft GitHub | https://github.com/microsoft/autogen | ✅ Verified |
| 30+ agent actions per task (SWE-bench) | SWE-agent, Princeton, 2024 | https://arxiv.org/abs/2405.15793 | ✅ Verified |
| 72+ hours drift detection | Internal estimate | — | ⚠️ Needs source or removal before publishing |
| Opening story (340K rows deleted) | Composite/illustrative | — | ⚠️ Add disclaimer: "Based on a composite of real incidents" |

*All statistics should be verified against current source publications before publishing. Numbers marked as internal estimates need review by New Relic's research team for accuracy and disclosure compliance.*
