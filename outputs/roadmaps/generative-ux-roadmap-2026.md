# Generative UX Roadmap: New Relic Agentic Experience

## Context

Camden has asked Abhishek to own the **generative user experience** for NR's agents, working with Manny's engineering team and Madhan/Inez on design. Mariah owns SRE orchestrator execution and LP/PP coordination. This document defines what a bold, standalone generative UX looks like for New Relic, unconstrained by current chat panel or OneCore limitations.

The core question: **If New Relic's future is generative and adaptive, requiring multiple agents across NR and external platforms, what does that experience look and feel like?**

Datadog shipped Bits AI SRE with a split-pane investigation tree + chat. That's their V1. We're not copying it. We're leapfrogging it with a canvas-based generative experience that makes their tree view look like a static report.

---

## Vision: The Investigation Canvas

New Relic becomes the **war room for AI-powered incident response**. Not a chatbot. Not a dashboard. A live, collaborative canvas where AI agents and humans work side-by-side to detect, diagnose, and fix problems in real time.

The canvas is the single surface where:
- Agents stream their reasoning visually (not as walls of text)
- Humans steer, correct, and approve agent actions
- Evidence (metrics, logs, traces, deployments) renders inline as interactive widgets
- Multiple agents hand off work visibly (SRE → DB → Deploy)
- External tools (PagerDuty, Jira, Slack) participate as first-class citizens
- Everything the agent learned persists as reusable knowledge

**Our positioning: "The agent that shows its work" becomes literal.** You can see every hypothesis, every evidence query, every decision point. Datadog shows a tree after the fact. We show the reasoning happening live on a canvas you can interact with.

---

## Three Steel Thread User Journeys

### Steel Thread 1: "3 AM Page" (Reactive Investigation)

An on-call engineer gets paged. They open New Relic. Here's what happens:

**Entry → Canvas opens automatically**

```
TRIGGER: PagerDuty alert fires for "High Error Rate on Checkout Service"
  ↓
NR detects the alert (via webhook or native alert)
  ↓
Auto-opens the Investigation Canvas with context pre-loaded
```

**The Canvas Layout (full-page, not a side panel):**

```
┌─────────────────────────────────────────────────────────────────────┐
│  🔴 ACTIVE INVESTIGATION: Checkout Service Error Spike             │
│  Started 45s ago · SRE Agent investigating · 2 agents active       │
├──────────────────────────────────┬──────────────────────────────────┤
│                                  │                                  │
│  REASONING STREAM (left 60%)     │  EVIDENCE PANEL (right 40%)     │
│                                  │                                  │
│  ┌─ PHASE: Initial Triage ───┐   │  ┌─ Golden Signals ──────────┐ │
│  │ ✅ Entity resolved:       │   │  │ [LIVE ERROR RATE CHART]   │ │
│  │    checkout-service-prod   │   │  │ ▲ 340% spike at 3:02 AM  │ │
│  │                           │   │  │ [interactive, zoomable]    │ │
│  │ ✅ Time window: 2:58-3:15 │   │  └────────────────────────────┘ │
│  │                           │   │                                  │
│  │ 🔄 Checking 3 sources:    │   │  ┌─ Recent Deployments ──────┐ │
│  │    ☑ Runbook (none found)  │   │  │ v2.4.1 deployed 2:45 AM  │ │
│  │    ☑ Memory (similar last  │   │  │ by: deploy-bot           │ │
│  │       month — DB timeout)  │   │  │ 3 files changed           │ │
│  │    ☑ General scan (3 steps)│   │  │ [View Diff] [View PR]     │ │
│  └────────────────────────────┘   │  └────────────────────────────┘ │
│                                  │                                  │
│  ┌─ PHASE: Hypothesis ───────┐   │  ┌─ Error Traces ────────────┐ │
│  │                           │   │  │ [FLAME GRAPH]              │ │
│  │  H1: Deployment caused    │   │  │ checkout → payment-svc     │ │
│  │      regression           │   │  │    → db-connection-pool    │ │
│  │      🟢 VALIDATING...     │   │  │ ⚠ 4.2s timeout at pool    │ │
│  │      Evidence: error rate  │   │  │ [interactive, clickable]   │ │
│  │      spiked 14 min after   │   │  └────────────────────────────┘ │
│  │      deploy v2.4.1         │   │                                  │
│  │                           │   │  ┌─ Relevant Logs ────────────┐ │
│  │  H2: DB connection pool   │   │  │ ERROR: HikariPool-1 ...   │ │
│  │      exhaustion           │   │  │ WARN: Connection timeout   │ │
│  │      🟡 TESTING...        │   │  │ [12 more matching logs]    │ │
│  │                           │   │  │ [Open in Log Explorer →]   │ │
│  │  H3: Upstream dependency  │   │  └────────────────────────────┘ │
│  │      failure              │   │                                  │
│  │      ⚪ QUEUED             │   │                                  │
│  └────────────────────────────┘   │                                  │
│                                  │                                  │
├──────────────────────────────────┴──────────────────────────────────┤
│  💬 Ask the agent...  [Redirect: "Check the payment service too"]  │
│  [▶ Run Action] [📋 Create Incident] [📱 Page Team] [🔙 Rollback] │
└─────────────────────────────────────────────────────────────────────┘
```

**Key UX behaviors:**

1. **Reasoning streams in real time** (left panel). Each phase appears as it happens. Steps have live status indicators (spinner → checkmark). Users watch the agent think.

2. **Evidence renders as interactive widgets** (right panel). Not text descriptions of metrics. Actual charts, flame graphs, log snippets, deployment diffs. Each widget is clickable to drill deeper into the full NR product (APM, Logs, etc.).

3. **Hypotheses are first-class UI objects.** Color-coded (green=validated, yellow=testing, red=invalidated, grey=queued). Each hypothesis is expandable to show the evidence chain. Users can click "Skip this" or "Prioritize this" to steer the investigation.

4. **Actions are contextual buttons** at the bottom, pre-filled with investigation context. One-click rollback, one-click incident creation, one-click page.

5. **The chat input doubles as a steering mechanism.** Users can type "check the payment service too" to redirect investigation, or ask "what about the deploy 2 hours ago?" to add context.

**How it ends:**

```
┌─ CONCLUSION ──────────────────────────────────────────────────────┐
│                                                                    │
│  🎯 ROOT CAUSE                                                    │
│  Deployment v2.4.1 introduced a connection pool config change      │
│  that reduced max connections from 20 → 5, causing pool            │
│  exhaustion under normal load.                                     │
│                                                                    │
│  📊 CONFIDENCE: HIGH (3 evidence sources corroborate)              │
│                                                                    │
│  🔧 RECOMMENDED FIX                                               │
│  ┌────────────────────────────────────────────────────┐           │
│  │ Rollback deployment v2.4.1                    [⏪]  │           │
│  │ OR: Update config: maxPoolSize=20             [📝]  │           │
│  │                                                     │           │
│  │ $ kubectl rollout undo deployment/checkout  [📋]    │           │
│  └────────────────────────────────────────────────────┘           │
│                                                                    │
│  Was this helpful?  [✅ Correct] [🔄 Partially] [❌ Wrong]        │
│  If wrong, what was the actual root cause? [_____________]         │
│                                                                    │
│  [📄 Export Report] [🎫 Create Post-Mortem] [📤 Share to Slack]   │
└────────────────────────────────────────────────────────────────────┘
```

---

### Steel Thread 2: "The War Room" (Multi-Agent Collaboration)

A major incident affects multiple services. Multiple agents and humans collaborate.

**The canvas becomes a shared workspace:**

```
┌─────────────────────────────────────────────────────────────────────┐
│  🔴 INCIDENT: Payment Processing Down (SEV-1)                      │
│  3 agents active · 2 team members · Started 12 min ago             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  AGENT ROSTER (top bar):                                            │
│  [🤖 SRE Agent: Investigating] [🗄 DB Agent: Checking pools]       │
│  [📊 PagerDuty: 3 responders online] [🎫 Jira: INC-4521 open]    │
│  [👤 Sarah Chen: viewing] [👤 Mike Torres: viewing]                │
│                                                                     │
│  INVESTIGATION TIMELINE (main area, horizontal swim lanes):         │
│                                                                     │
│  SRE Agent ━━━━[Entity lookup]━━[Metrics]━━[Logs]━━━▶ FINDING:     │
│             ┃                                         Payment svc   │
│             ┃                                         connection    │
│             ┃                                         refused       │
│  DB Agent   ┃━━━[Pool check]━━[Query analysis]━━━━━▶ FINDING:      │
│             ┃                                         Pool at 100%  │
│             ┃                                         0 available   │
│  PagerDuty  ┃━━━[Alert context]━━━━━━━━━━━━━━━━━━━▶ 3 responders  │
│                                                       notified      │
│                                                                     │
│  ┌─ SYNTHESIZED FINDING ──────────────────────────────────────┐    │
│  │ SRE Agent + DB Agent agree: Connection pool exhaustion is  │    │
│  │ the root cause. DB Agent found a long-running query from   │    │
│  │ reporting-service holding 18 of 20 connections.            │    │
│  │                                                             │    │
│  │ Suggested actions:                                          │    │
│  │ 1. [Kill reporting query] ← needs approval                 │    │
│  │ 2. [Increase pool to 50] ← needs approval                  │    │
│  │ 3. [Page reporting-service owner] ← auto-approved          │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  CHAT (bottom):                                                     │
│  Sarah: "@SRE-Agent can you check if this happened last Tuesday?"  │
│  SRE Agent: "Checking... Yes, similar pattern on Mar 5 at 2 AM.    │
│  Resolution was killing the reporting query. Took 8 min."          │
│  Mike: "Let's do option 1. @DB-Agent kill the query."              │
│  DB Agent: "Executing... ✅ Query terminated. Pool recovering."    │
│                                                                     │
│  [💬 Message...] [@SRE-Agent] [@DB-Agent] [📱 Page] [📤 Share]    │
└─────────────────────────────────────────────────────────────────────┘
```

**Key UX innovations:**

1. **Agent roster bar** shows which agents are active, what they're doing, and their status. External integrations (PagerDuty, Jira) appear as agents too.

2. **Swim lane timeline** shows parallel agent work streams. You can see that SRE Agent and DB Agent investigated simultaneously, and their findings converged.

3. **Synthesized findings** merge insights from multiple agents into a unified conclusion. This is the multi-agent version of DD's single-agent conclusion.

4. **@-mention agents** in chat to direct specific agents. "@DB-Agent kill the query" is a human-approved action executed by the agent.

5. **Human presence** (Sarah and Mike viewing) makes it collaborative. Think Google Docs but for incident response.

6. **Cross-platform agents** (PagerDuty, Jira) are visible participants, not hidden integrations. You see what they're contributing.

---

### Steel Thread 3: "The Morning Brief" (Proactive/Ambient Agent)

No incident. Engineer starts their day. The agent has been working overnight.

```
┌─────────────────────────────────────────────────────────────────────┐
│  ☀️ Good morning. Here's what happened while you were away.        │
│  3 investigations completed · 1 needs attention · 2 auto-resolved  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ⚡ NEEDS YOUR ATTENTION                                            │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │ 🟡 Memory leak detected in user-auth-service                │  │
│  │ Detected at 4:12 AM · Heap growing 2% per hour              │  │
│  │ Current: 78% heap utilization (danger zone at 90%)          │  │
│  │ [MEMORY TREND CHART: 24hr showing steady climb]             │  │
│  │                                                              │  │
│  │ Agent recommends: Restart pods before 11 AM                 │  │
│  │ [✅ Approve restart] [🔍 Investigate deeper] [⏰ Snooze]    │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ✅ AUTO-RESOLVED (no action needed)                                │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │ Alert: High latency on search-service (1:30 AM)             │  │
│  │ Root cause: Nightly batch job. Resolved when job completed. │  │
│  │ Agent matched to known pattern: "nightly batch noise"       │  │
│  │ [View investigation →]                                       │  │
│  ├──────────────────────────────────────────────────────────────┤  │
│  │ Alert: CPU spike on worker-pods (3:45 AM)                   │  │
│  │ Root cause: Auto-scaling event. Pods scaled 3→8, normalized.│  │
│  │ Agent matched to known pattern: "autoscale spike"           │  │
│  │ [View investigation →]                                       │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  📊 OVERNIGHT HEALTH SUMMARY                                       │
│  [Sparkline charts for your top 5 services]                        │
│  checkout: 99.97% · payment: 99.99% · search: 98.2% (batch job)   │
│  user-auth: ⚠️ trending · inventory: 99.99%                       │
│                                                                     │
│  [Open full canvas →] [Configure what I monitor →]                 │
└─────────────────────────────────────────────────────────────────────┘
```

**Key UX innovations:**

1. **Ambient mode**: Agent works 24/7, triages alerts autonomously, resolves known patterns without waking anyone.

2. **Morning brief**: Digest format. Three categories: Needs attention, auto-resolved, health summary. Not a wall of alerts.

3. **Known pattern matching**: Agent recognizes "nightly batch noise" and auto-classifies. This is the memory system in action.

4. **One-click approve**: For recommended actions, user can approve without opening a full investigation.

5. **Proactive detection**: Memory leak isn't an alert yet. Agent noticed the trend and flagged it before it became an incident.

---

## Response Design System

### How Agent Responses Render (Component Mapping)

Every agent response is decomposed into typed blocks. Each block type maps to a rich component:

| Response Type | Component | Interactive? |
|---|---|---|
| **Metric data** | Live chart (line, bar, sparkline) with zoom, time range picker | Yes: zoom, hover, click to open in Metrics Explorer |
| **Log snippets** | Syntax-highlighted code block with severity coloring | Yes: click to expand, link to Log Explorer |
| **Trace data** | Flame graph or waterfall with span details on hover | Yes: click spans, filter by service |
| **Entity info** | Service card with health badge, golden signals mini-charts | Yes: click to open entity page |
| **Deployment info** | Timeline card with commit hash, author, diff link, status badge | Yes: click to view diff, PR, rollback button |
| **Error groups** | Grouped error cards with count, impact score, stack trace preview | Yes: click to expand, link to Errors Inbox |
| **NRQL query** | Query block with syntax highlighting + rendered results table/chart | Yes: click to open in Query Builder |
| **Root cause** | Highlighted conclusion card with confidence score and evidence links | Yes: rate correctness, expand evidence |
| **Remediation** | Action cards with copyable commands, approve/reject buttons | Yes: one-click execute with HITL approval |
| **Hypothesis** | Collapsible card with status badge, evidence chain, reasoning steps | Yes: expand/collapse, skip/prioritize |
| **Text narrative** | Markdown with bold key terms, inline entity links | Yes: click entity names to navigate |
| **Comparison** | Side-by-side diff view (before/after deploy, healthy vs. unhealthy) | Yes: toggle time ranges |

### Example: A Golden Metrics Response Block

Instead of: "The error rate for checkout-service increased from 0.2% to 4.8% between 3:02 AM and 3:15 AM..."

Render as:
```
┌─ Golden Signals: checkout-service ─────────────────────────┐
│                                                             │
│  Error Rate          Throughput         Response Time       │
│  ┌──────────┐       ┌──────────┐       ┌──────────┐       │
│  │    ╱╲    │       │ ────── ──│       │      ╱── │       │
│  │   ╱  ╲   │       │          │       │     ╱    │       │
│  │──╱    ╲──│       │          │       │────╱     │       │
│  │ 0.2→4.8% │       │ 1.2K rps │       │ 89→340ms │       │
│  └──────────┘       └──────────┘       └──────────┘       │
│  ▲ +2,300% since 3:02 AM                                   │
│  [Open in APM →]                                            │
└─────────────────────────────────────────────────────────────┘
```

---

## Human-in-the-Loop UX

### 1. Steering the Investigation

Users can interact with the reasoning at every step:

- **Redirect**: Type "also check the payment service" → agent adds to its plan
- **Skip**: Click "Skip" on a hypothesis → agent deprioritizes it
- **Prioritize**: Click "Look at this first" on a hypothesis → agent reorders
- **Add context**: "We deployed a config change at 2:50 AM that isn't in change tracking" → agent incorporates
- **Challenge**: "I don't think it's the deployment, latency started before it" → agent re-evaluates

### 2. Rating and Feedback (on conclusion)

```
Was this root cause correct?

[✅ Yes, exactly right]
[🔄 Partially — got the area right, missed specifics]
[❌ No — here's what actually happened: _______________]

What should the agent do differently next time?
[_______________________________________________]
```

Every piece of feedback creates a **memory** that improves future investigations for this service/alert type.

### 3. Approving Actions (HITL for remediation)

```
Agent recommends: Rollback deployment v2.4.1

Impact assessment:
• Will revert 3 files in checkout-service
• Previous version (v2.4.0) was stable for 14 days
• Estimated recovery time: 2-3 minutes
• Risk: LOW (clean rollback, no data migrations)

[✅ Approve rollback] [🔍 Show me the diff first] [❌ Reject — try something else]
```

Actions are categorized by risk:
- **Low risk** (collect logs, query metrics): Auto-approved, just execute
- **Medium risk** (restart non-prod pods, create Jira ticket): Show confirmation dialog
- **High risk** (rollback production, kill queries, scale infrastructure): Require explicit approval with impact assessment

---

## Agent Memory & Knowledge UX

### Teaching the Agent (Onboarding Experience)

When a team first enables the SRE Agent, they see:

```
┌─ Teach Your Agent ─────────────────────────────────────────────────┐
│                                                                     │
│  Help your SRE Agent understand your environment.                  │
│  The more context you provide, the better investigations get.      │
│                                                                     │
│  1. ARCHITECTURE (optional)                                        │
│  ┌──────────────────────────────────────────────────────────┐     │
│  │ Describe your services and how they connect.             │     │
│  │ Example: "checkout-service calls payment-service and     │     │
│  │ inventory-service. payment-service uses Stripe API.      │     │
│  │ Database is MySQL 8.0 on RDS."                           │     │
│  │ [___________________________________________________]    │     │
│  │ Or: [📎 Upload architecture doc] [🔗 Link Confluence]    │     │
│  └──────────────────────────────────────────────────────────┘     │
│                                                                     │
│  2. RUNBOOKS (recommended)                                         │
│  ┌──────────────────────────────────────────────────────────┐     │
│  │ Link your team's runbooks so the agent follows your      │     │
│  │ troubleshooting procedures.                               │     │
│  │ [📎 Upload runbook] [🔗 Link Confluence page]            │     │
│  │ [🔗 Link PagerDuty runbook] [🔗 Link GitHub wiki]       │     │
│  └──────────────────────────────────────────────────────────┘     │
│                                                                     │
│  3. KNOWN PATTERNS (optional)                                      │
│  ┌──────────────────────────────────────────────────────────┐     │
│  │ Tell the agent about expected noise so it doesn't        │     │
│  │ wake you up for known things.                             │     │
│  │ • Nightly batch job (2-3 AM) causes CPU spikes      [✏️] │     │
│  │ • Monthly report gen causes DB load                 [✏️] │     │
│  │ [+ Add known pattern]                                    │     │
│  └──────────────────────────────────────────────────────────┘     │
│                                                                     │
│  4. TEAM PREFERENCES                                               │
│  ┌──────────────────────────────────────────────────────────┐     │
│  │ Escalation: Page after [5] min if SEV-1                  │     │
│  │ Preferred channels: [#ops-incidents] in Slack            │     │
│  │ Auto-investigate: [✅ All P1 alerts] [☐ P2+]            │     │
│  └──────────────────────────────────────────────────────────┘     │
│                                                                     │
│  [Skip for now — I'll teach it as I go →] [Save & Start →]        │
└─────────────────────────────────────────────────────────────────────┘
```

### Memory Management Dashboard

```
┌─ Agent Memory ─────────────────────────────────────────────────────┐
│                                                                     │
│  LEARNED PATTERNS (from feedback)                    12 memories    │
│  ┌──────────────────────────────────────────────────────────┐     │
│  │ "Checkout errors after deploy → check connection pool"   │     │
│  │  Source: Investigation #47, Mar 5 (you rated: correct)   │     │
│  │  Used in: 3 subsequent investigations                    │     │
│  │  [✏️ Edit] [🗑️ Delete]                                  │     │
│  ├──────────────────────────────────────────────────────────┤     │
│  │ "Search-service latency at 2 AM = batch job (ignore)"   │     │
│  │  Source: Manual pattern, added Feb 20                    │     │
│  │  Triggered: 14 times (all correctly classified)          │     │
│  │  [✏️ Edit] [🗑️ Delete]                                  │     │
│  └──────────────────────────────────────────────────────────┘     │
│                                                                     │
│  ENVIRONMENT CONTEXT                                                │
│  ┌──────────────────────────────────────────────────────────┐     │
│  │ Architecture doc: Last updated Mar 1 [✏️ Update]         │     │
│  │ Runbooks linked: 4 [+ Add more]                          │     │
│  │ Known patterns: 6 [+ Add more]                           │     │
│  │ Team preferences: Configured [✏️ Edit]                   │     │
│  └──────────────────────────────────────────────────────────┘     │
│                                                                     │
│  INVESTIGATION HISTORY                                              │
│  [Table: Date, Alert, Conclusion, Correct?, Time to resolve]       │
│  Mar 10: Checkout errors → Pool exhaustion ✅ 3m                   │
│  Mar 8: Search latency → Auto-resolved (batch job) ✅ 0m          │
│  Mar 5: Payment timeout → Similar pattern detected ✅ 4m          │
│  [View all → ]                                                      │
│                                                                     │
│  EFFECTIVENESS METRICS                                              │
│  Accuracy: 84% (21/25 correct)                                     │
│  Avg time to conclusion: 3.2 min                                   │
│  Auto-resolved (no human needed): 8 of 25 (32%)                   │
│  [📊 View detailed report →]                                       │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Multi-Agent Orchestration UX

When the SRE Agent needs specialized help, the handoff is visible:

```
SRE Agent: "I've identified the issue is database-related.
Handing off to DB Agent for deeper analysis."

  ┌─ AGENT HANDOFF ──────────────────────────────────┐
  │ SRE Agent → DB Agent                              │
  │ Passing context: entity_guid, time_window,        │
  │ initial finding (connection pool exhaustion)       │
  │                                                    │
  │ DB Agent is now investigating...                   │
  │ [🗄️ Checking query performance]                   │
  │ [🗄️ Analyzing connection pool metrics]            │
  │ [🗄️ Reviewing slow query log]                     │
  └──────────────────────────────────────────────────┘
```

External agents show as integration cards:

```
  ┌─ PagerDuty ────────────────────────────────────────┐
  │ Incident INC-4521 created                           │
  │ 3 responders notified: Sarah, Mike, Alex           │
  │ Escalation policy: checkout-team-oncall             │
  │ [Open in PagerDuty →]                               │
  └─────────────────────────────────────────────────────┘

  ┌─ Jira ─────────────────────────────────────────────┐
  │ OPS-1234: Checkout service connection pool fix      │
  │ Status: To Do · Priority: P1 · Assignee: Sarah     │
  │ Description auto-filled from investigation findings │
  │ [Open in Jira →]                                    │
  └─────────────────────────────────────────────────────┘
```

---

## Phased Roadmap

### V0: Visual Responses (4-6 weeks)
**Goal: Stop shipping walls of text**

- Map every SRE Agent response type to a rich component
- Render metrics as charts, traces as flame graphs, logs as highlighted blocks
- Add entity cards with golden signal sparklines
- Add copyable code blocks for remediation commands
- Conclusion card with confidence score and feedback buttons (correct/wrong)
- Ship within current chat panel constraints as a bridge
- **Measures success**: User engagement with visual components vs. text

### V1: Investigation Canvas (8-12 weeks)
**Goal: Full-page generative experience**

- New full-page route: `/investigation/{id}`
- Split-pane layout: reasoning stream (left) + evidence panel (right)
- Real-time streaming of investigation phases via AG-UI SSE
- Hypothesis visualization with status badges and expandability
- Interactive evidence widgets (click chart → drill into APM)
- Action bar: Create incident, page team, rollback, share to Slack
- Human steering: redirect investigation, skip/prioritize hypotheses
- Conclusion screen with feedback loop
- Auto-open from alert notifications
- **Measures success**: Time to resolve, investigation completion rate, feedback scores

### V2: Multi-Agent War Room (12-20 weeks)
**Goal: Collaborative, multi-agent, multi-platform**

- Agent roster bar showing active agents and their status
- Swim lane timeline for parallel agent work
- Agent handoff visualization (SRE → DB → Deploy)
- @-mention agents in chat
- External agent cards (PagerDuty, Jira, Slack as participants)
- Multiple humans viewing/collaborating simultaneously
- Synthesized multi-agent findings
- **Measures success**: Multi-agent investigation accuracy, collaboration metrics

### V3: Ambient Intelligence (20+ weeks)
**Goal: Proactive, always-on, learning agent**

- Auto-investigate per monitor (toggle, bulk-edit)
- Morning brief digest
- Known pattern matching and auto-resolution
- Agent memory management dashboard
- "Teach your agent" onboarding wizard
- Effectiveness reporting (accuracy, MTTR impact, auto-resolution rate)
- Proactive detection (memory leaks, capacity trends, anomalies)
- **Measures success**: % of alerts auto-resolved, proactive detections, MTTR reduction

---

## How This Maps to "The Agent That Shows Its Work"

| Datadog (Bits AI SRE) | New Relic (Investigation Canvas) | Why Ours Is Better |
|---|---|---|
| Tree view shown after investigation | **Live canvas** streamed during investigation | Transparency is real-time, not post-hoc |
| Single investigation pane | **Canvas + war room** for multi-agent collab | Handles complex incidents, not just single alerts |
| Text-heavy findings with embedded images | **Native interactive widgets** (charts, flame graphs, tables) | Evidence is interactive, not screenshots |
| Binary feedback (helpful/unhelpful) | **Granular feedback** on conclusion + individual hypotheses + steering | Better learning loop |
| bits.md (markdown file) | **Visual onboarding wizard** + **memory management dashboard** | Lower friction, more discoverable |
| Chat-only interface | **Full-page canvas** with chat as secondary input | More room for visual evidence |
| SRE Agent only | **Multi-agent roster** with visible handoffs | Handles specialized domains |
| Datadog data only | **Cross-platform agents** (PagerDuty, Jira, Slack as participants) | Acknowledges multi-tool reality |

---

## Key Decisions Needed

1. **Build as Nerdpack or standalone app?** Camden suggested "forget about NR1 platform" — do we literally build outside NR1 for speed, then integrate later?
2. **V0 scope**: Ship visual responses in current chat panel while canvas is being built, or skip straight to canvas?
3. **Which 2 use cases for LP?** Recommendation: alert triage + deployment validation (per Camden)
4. **Agent memory storage**: Use existing KRS (Knowledge Retrieval Service), or build new lightweight storage?
5. **External agent integrations**: Start with which partners? Recommendation: PagerDuty + Slack first (most common in SRE workflows)

---

## Files Referenced

- NR SRE Agent docs: `context-library/Internal Docs- New Relic/New Relic SRE Agent_v1/completed-sre-agent-docs/step1/`
- Product brief: `context-library/prds/sre-agent-product-brief.md`
- DD competitive intel: `outputs/research-synthesis/competitor-analysis-datadog-2026-02-19.md`
- DD demo screenshots: `context-library/research/Datadog BITS AI SRE DEMO Screenshots/`
- Meeting transcripts: `context-library/meetings/Agentic & SRE Roadmap Transcript/`
- Competitive landscape: `context-library/research/competitive-intel-ai-agentic-2026-02.md`
