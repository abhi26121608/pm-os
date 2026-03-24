# SRE Agent: Generative UX Product Specification

**Owner:** Abhishek Pandey | **Engineering:** Manny + Team | **Design:** Madhan + Inez
**Status:** Draft v2 | **Date:** 2026-03-23 | **Previous:** v1 (2026-03-12)
**Scope:** End-to-end UX specification for New Relic's SRE Agent GenUX (Generative User Experience). Covers the Investigation Canvas, Autonomy Dial, Smart Alert Radar, Post-Mortem system, Cross-Surface integrations (Chrome, Slack/Teams), and SLO Builder.

> **v2 Changelog (2026-03-23):** Merged the GenUX execution roadmap into this spec. Added: Autonomy Dial with 4 trust levels (Section 14), Smart Alert Radar for spatial incident grouping (Section 15), Post-Mortem timeline scrubber and auto-export (Section 16), Cross-Surface integrations for Chrome and Slack/Teams (Section 17), AI-guided SLO Builder (Section 18), GenUX success metrics and definitions of done (Section 19). Enhanced: HITL interactions with Intent Preview Cards and simulation overlays (Section 7), Memory system with Memory Matrix direct-manipulation concepts (Section 8). This document is the single source of truth for designers and engineers.

---

## Table of Contents

### Part I: Core Experience (Sections 1-10)
1. [Information Architecture](#1-information-architecture)
2. [Entry Points](#2-entry-points)
3. [Investigation Canvas (Core Experience)](#3-investigation-canvas)
4. [Specialized Agent System](#4-specialized-agent-system)
5. [Response Rendering System](#5-response-rendering-system)
6. [Real-Time Streaming UX](#6-real-time-streaming-ux)
7. [Human-in-the-Loop Interactions](#7-human-in-the-loop)
8. [Memory System UX](#8-memory-system)
9. [Agent Configuration & Onboarding](#9-configuration-and-onboarding)
10. [Reports & Effectiveness](#10-reports-and-effectiveness)

### Part II: GenUX Extensions (Sections 14-19)
14. [Autonomy Dial System](#14-autonomy-dial-system)
15. [Smart Alert Radar](#15-smart-alert-radar)
16. [Post-Incident Recovery & Post-Mortem](#16-post-incident-recovery-and-post-mortem)
17. [Cross-Surface Integrations](#17-cross-surface-integrations)
18. [SLO Builder](#18-slo-builder)
19. [GenUX Success Metrics & Definitions of Done](#19-genux-success-metrics)

### Part III: Engineering Reference (Sections 11-13)
11. [Component Specifications](#11-component-specifications)
12. [State Machine & Transitions](#12-state-machine)
13. [Data Model (for prototyping)](#13-data-model)

---

## 1. Information Architecture

### Top-Level Navigation

The SRE Agent lives as a first-class section in New Relic's nav:

```
New Relic Platform
├── APM
├── Infrastructure
├── Logs
├── ...
├── 🤖 AI Agents          ← NEW top-level nav item
│   ├── Investigations     ← List of all investigations (active + completed)
│   ├── Morning Brief      ← Daily digest / proactive findings
│   ├── Agent Memory       ← Knowledge base, learned patterns, runbooks
│   ├── Agent Settings     ← Configure agents, auto-investigate, integrations
│   └── Reports            ← Effectiveness metrics, MTTR trends
```

### URL Structure

```
/ai/investigations                    → Investigation list
/ai/investigations/new                → Start new investigation (free-form)
/ai/investigations/{id}               → Active/completed investigation canvas
/ai/investigations/{id}?view=trace    → Agent trace view (raw reasoning)
/ai/morning-brief                     → Daily digest
/ai/memory                            → Memory management
/ai/memory/patterns                   → Learned patterns
/ai/memory/runbooks                   → Linked runbooks
/ai/memory/architecture               → Architecture context
/ai/settings                          → Agent configuration
/ai/settings/agents                   → Active agents and their configs
/ai/settings/auto-investigate         → Auto-investigation rules
/ai/settings/integrations             → External tool connections
/ai/reports                           → Effectiveness dashboard
```

---

## 2. Entry Points

There are 7 ways a user arrives at an investigation:

### 2.1 Auto-triggered (no human action needed)
```
Monitor enters ALERT state
  ↓
Auto-investigate is ON for this monitor
  ↓
Investigation starts automatically
  ↓
User sees notification: "🤖 SRE Agent is investigating: High Error Rate on checkout-service"
  ↓
Click notification → opens /ai/investigations/{id}
```

### 2.2 From Alert/Issue Page
```
User is on Issue Page viewing an active alert
  ↓
Banner at top: "🤖 Investigate with SRE Agent" [Start Investigation]
  ↓
Click → opens /ai/investigations/{id} with issue context pre-loaded
Context passed: issue_id, entity_guids, alert_condition, time_window, severity
```

### 2.3 From APM Service Page
```
User sees a latency spike on the APM service page
  ↓
Click-drag to select anomalous region on latency graph
  ↓
Popover: "🤖 Investigate this anomaly" [Start Investigation]
  ↓
Context passed: entity_guid, time_window (from selection), metric_type: latency
```

### 2.4 From Slack
```
Monitor notification posts to #ops-alerts Slack channel
  ↓
User replies: "@NewRelic investigate this alert"
  ↓
SRE Agent starts investigation
  ↓
Posts back to thread: "Investigation started. View: [link to /ai/investigations/{id}]"
  ↓
Posts findings summary to thread when complete
```

### 2.5 Free-form Prompt
```
User navigates to /ai/investigations/new
  ↓
Sees a prompt box:
┌──────────────────────────────────────────────────────────────┐
│  What would you like to investigate?                         │
│                                                              │
│  [Describe the issue. Include service names, symptoms,       │
│   time range, and any context you have.]                     │
│                                                              │
│  Examples:                                                   │
│  • "Checkout service has been slow since 2 PM"              │
│  • "We got paged for high error rate on payment-service"    │
│  • "Is there anything wrong with our database right now?"   │
│                                                              │
│  [Start Investigation →]                                     │
└──────────────────────────────────────────────────────────────┘
```

### 2.6 From Morning Brief
```
Morning brief shows: "⚠️ Memory leak detected in user-auth-service"
  ↓
User clicks [🔍 Investigate deeper]
  ↓
Opens canvas with proactive finding context pre-loaded
```

### 2.7 From Investigation List
```
/ai/investigations page shows all past and active investigations
  ↓
User clicks on any row → opens that investigation's canvas
  ↓
Or clicks [+ New Investigation] → free-form prompt
```

---

## 3. Investigation Canvas (Core Experience)

### 3.1 Layout Architecture

The canvas is a full-page experience (not a side panel). Three-zone layout:

```
┌──────────────────────────────────────────────────────────────────────┐
│  HEADER BAR (fixed, 60px)                                            │
│  Status badge | Title | Time | Active agents | View toggle | Actions │
├───────────────────────────────────┬──────────────────────────────────┤
│                                   │                                  │
│  LEFT ZONE (55-60%)               │  RIGHT ZONE (40-45%)            │
│  Reasoning & Conclusions          │  Evidence & Data                 │
│                                   │                                  │
│  Scrollable vertically            │  Scrollable independently       │
│  Content streams in real-time     │  Widgets update as agent finds  │
│                                   │  new data                        │
│                                   │                                  │
│                                   │                                  │
│                                   │                                  │
│                                   │                                  │
│                                   │                                  │
│                                   │                                  │
│                                   │                                  │
├───────────────────────────────────┴──────────────────────────────────┤
│  BOTTOM BAR (fixed, 80px)                                            │
│  Chat input | Quick actions (Create Incident, Page, Rollback, Share) │
└──────────────────────────────────────────────────────────────────────┘
```

### 3.2 Header Bar (60px, fixed top)

```
┌──────────────────────────────────────────────────────────────────────┐
│ ← Back                                                               │
│                                                                      │
│ 🟢 Investigating    Checkout Service Error Spike                     │
│ Source: Monitor · Alert ID: 18257505 · Started 2m ago                │
│                                                                      │
│ AGENTS: [🤖 SRE ●] [🗄 DB ○] [☸ K8s ○]    VIEW: [Canvas] [Trace]  │
│                                                                      │
│ [📤 Share] [📋 Export] [⋯ More]                                     │
└──────────────────────────────────────────────────────────────────────┘
```

**Header elements:**
- **Back arrow**: Returns to investigation list
- **Status badge**: `Investigating` (green pulse) | `Conclusive` (green solid) | `Inconclusive` (yellow) | `Error` (red)
- **Title**: Auto-generated from alert or user prompt. Updates when conclusion is reached (e.g., changes to "Connection pool exhaustion caused checkout errors")
- **Source**: Monitor / Manual / Slack / APM (how it was triggered)
- **Agents indicator**: Shows which specialized agents are active. Filled circle = currently working. Empty circle = available but idle. Click to see agent details.
- **View toggle**: Canvas (default, visual) | Trace (raw agent reasoning, every tool call, for debugging)
- **Actions**: Share (link/Slack), Export (PDF/Markdown), More (duplicate, delete, convert to post-mortem)

### 3.3 Left Zone: Reasoning Stream

The left zone shows the investigation progress as a vertical flow of cards. Each card represents a **phase** of the investigation.

**Phase 1: Context Gathering**
```
┌─ CONTEXT ──────────────────────────────────────────────────────┐
│                                                                 │
│  ✅ Entity Resolved                                            │
│  checkout-service (APM Application)                            │
│  Account: 779820 · GUID: Nzc5ODIwfEFQT...                    │
│  Environment: production · Region: us-east-1                   │
│                                                                 │
│  ✅ Time Window Established                                    │
│  Feb 28, 2026 · 3:02 AM → 3:45 AM UTC (43 min)              │
│  Alert triggered at 3:02 AM · Currently ongoing               │
│                                                                 │
│  🔍 Knowledge Check                                           │
│  ┌───────────────┬───────────────┬───────────────┐            │
│  │ 📖 Runbook    │ 🧠 Memory     │ 🔎 General    │            │
│  │ Found: link   │ Similar: Mar 5│ Scanned: 6    │            │
│  │ to Confluence  │ DB timeout    │ data sources  │            │
│  │ (3 steps)     │ (1 match)     │ (4 steps)     │            │
│  └───────────────┴───────────────┴───────────────┘            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Phase 2: Initial Findings**
```
┌─ INITIAL FINDINGS ─────────────────────────────────────────────┐
│                                                                 │
│  Backend connection failures cause Connection refused errors    │
│  on GET /api/locations/ in api-gateway, causing HTTP 500       │
│  responses.                                                     │
│                                                                 │
│  Upstream service connection refusals shown by repeated         │
│  Connection refused errors in api-gateway logs.                │
│                                                                 │
│  Based on past investigation (Mar 5): Similar pattern was      │
│  caused by database connection pool exhaustion.                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Phase 3: Hypotheses (the core differentiator)**

Each hypothesis is a collapsible card with rich state:

```
┌─ HYPOTHESES ───────────────────────────────────────────────────┐
│                                                                 │
│  ┌─ H1: Deployment Regression ─────────────────── 🟢 VALIDATED │
│  │                                                              │
│  │  Deploy v2.4.1 at 2:45 AM changed connection pool config.  │
│  │  Error rate spiked 14 min after deploy.                     │
│  │                                                              │
│  │  Evidence:                                                   │
│  │  • Error rate 0.2% → 4.8% correlates with deploy [📊]     │
│  │  • Config change: maxPoolSize 20 → 5 [📝 View Diff]       │
│  │  • 3 similar traces show pool exhaustion [🔗 View Traces]  │
│  │                                                              │
│  │  [⏭ Skip] [📌 Pin as key finding]                          │
│  └──────────────────────────────────────────────────────────────┘
│                                                                 │
│  ┌─ H2: DB Connection Pool Exhaustion ─────────── 🟢 VALIDATED │
│  │                                                              │
│  │  HikariPool connections at max. Timeout errors in logs.     │
│  │  → Handed to 🗄 DB Agent for deeper analysis               │
│  │                                                              │
│  │  DB Agent found:                                             │
│  │  • Active connections: 5/5 (100% utilized)                  │
│  │  • Wait queue: 23 threads waiting                            │
│  │  • Longest wait: 4.2 seconds                                │
│  │  • Root query: SELECT * FROM inventory... (running 12 min)  │
│  │                                                              │
│  │  [⏭ Skip] [📌 Pin]                                         │
│  └──────────────────────────────────────────────────────────────┘
│                                                                 │
│  ┌─ H3: Upstream Dependency Failure ───────────── 🔴 INVALIDATED
│  │                                                              │
│  │  Checked payment-service and inventory-service.             │
│  │  Both healthy. No correlation with error spike.             │
│  │  Confidence: LOW — insufficient evidence.                   │
│  │                                                              │
│  │  ▸ Show evidence (collapsed)                                │
│  └──────────────────────────────────────────────────────────────┘
│                                                                 │
│  Legend: 🟢 Validated  🟡 Testing  🔴 Invalidated  ⚪ Queued   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Phase 4: Conclusion**
```
┌─ CONCLUSION ───────────────────────────────────────────────────┐
│                                                                 │
│  🎯 ROOT CAUSE                                                 │
│  ───────────────────────────────────────────────────────────── │
│  Deployment v2.4.1 reduced the connection pool from 20 to 5    │
│  connections. Under normal load (1.2K req/s), the pool was     │
│  immediately exhausted, causing 4.2s wait times and HTTP 500   │
│  errors on the checkout endpoint.                               │
│                                                                 │
│  📊 Confidence: HIGH                                            │
│  Based on: 3 corroborating evidence sources                    │
│  Time to conclusion: 3 min 12 sec                              │
│                                                                 │
│  ───────────────────────────────────────────────────────────── │
│                                                                 │
│  🔧 RECOMMENDED ACTIONS                                        │
│                                                                 │
│  ┌─ Option A: Rollback (Recommended) ──────── Risk: LOW ────┐ │
│  │                                                            │ │
│  │  Revert to v2.4.0 (stable for 14 days)                   │ │
│  │  Estimated recovery: 2-3 minutes                          │ │
│  │                                                            │ │
│  │  $ kubectl rollout undo deployment/checkout-service  [📋] │ │
│  │                                                            │ │
│  │  [✅ Approve & Execute]  [🔍 Show Impact Assessment]      │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌─ Option B: Hotfix Config ──────────────── Risk: LOW ─────┐ │
│  │                                                            │ │
│  │  Update maxPoolSize back to 20                            │ │
│  │                                                            │ │
│  │  $ kubectl set env deployment/checkout-service             │ │
│  │    HIKARI_MAX_POOL_SIZE=20                           [📋] │ │
│  │                                                            │ │
│  │  [✅ Approve & Execute]                                    │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ───────────────────────────────────────────────────────────── │
│                                                                 │
│  📝 FEEDBACK                                                   │
│                                                                 │
│  Was this root cause correct?                                  │
│  [✅ Yes, exactly] [🔄 Partially right] [❌ Wrong]            │
│                                                                 │
│  If wrong, what was the actual cause?                          │
│  [________________________________________________]            │
│                                                                 │
│  Rate the investigation quality (1-5): [⭐⭐⭐⭐⭐]           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 3.4 Right Zone: Evidence Panel

The right zone shows data widgets that the agent references. Widgets appear as the agent discovers data. They are independently scrollable and each links back to the full NR product.

**Widget Types (in order they typically appear):**

```
WIDGET 1: Alert Context Card
┌─ Alert: API Gateway Error Increase ───────────────────────────┐
│ Status: 🔴 ALERT · Triggered: 3:02 AM UTC                    │
│ Condition: error_rate > 1% for 5 min                         │
│ Current value: 4.8%                                           │
│ [Open Monitor →]                                              │
└───────────────────────────────────────────────────────────────┘

WIDGET 2: Golden Signals (3 mini-charts side by side)
┌─ Golden Signals: checkout-service ────────────────────────────┐
│  Error Rate         Throughput          Response Time          │
│  [CHART: spike]     [CHART: stable]     [CHART: climbing]    │
│  0.2% → 4.8%       1.2K req/s          89ms → 340ms         │
│  ▲ +2300%           → stable            ▲ +282%              │
│  Time range: [2:50 AM ————— 3:20 AM]  [🔍 Zoom] [📊 APM →] │
└───────────────────────────────────────────────────────────────┘

WIDGET 3: Recent Deployments Timeline
┌─ Deployments (last 24h) ──────────────────────────────────────┐
│                                                                │
│  ●━━━━━━━━━━━━━━━━●━━━━━━━━━━━━●━━━━━━━━━━━▶ time            │
│  v2.4.0          v2.4.1      NOW                              │
│  (2 days ago)    (2:45 AM)                                    │
│                   ↑                                            │
│                   ERROR SPIKE                                  │
│                                                                │
│  v2.4.1 · deploy-bot · 3 files changed                       │
│  commit: a1b2c3d "Update connection pool settings"            │
│  [View Diff] [View PR #427] [View in Change Tracking →]      │
└───────────────────────────────────────────────────────────────┘

WIDGET 4: Error Traces (Flame Graph)
┌─ Trace: GET /api/checkout ────────────────────────────────────┐
│  Total: 4.8s                                                   │
│                                                                │
│  ██████████████████████████████████████████████ checkout-svc   │
│  ├── ████████████████████████████████████████ payment-svc     │
│  │   └── ████████████████████ db-pool-wait (4.2s) ⚠️         │
│  │       └── █ query (145ms)                                  │
│  └── ████ inventory-svc (200ms)                               │
│                                                                │
│  ⚠️ db-pool-wait: 4.2s (87% of total trace time)            │
│  Error: HikariPool-1 - Connection not available               │
│                                                                │
│  [Open in Distributed Tracing →] [View span details]         │
└───────────────────────────────────────────────────────────────┘

WIDGET 5: Relevant Logs
┌─ Logs: checkout-service (3:02-3:15 AM) ───────────────────────┐
│                                                                │
│  3:02:14 ERROR HikariPool-1 - Connection is not available,    │
│                request timed out after 30000ms.                │
│  3:02:14 ERROR c.z.h.pool.HikariPool - checkout-pool -        │
│                Connection not available, request timed out     │
│  3:02:15 WARN  o.h.e.j.s.SqlExceptionHelper - SQL Error: 0   │
│  3:02:15 ERROR o.h.e.j.s.SqlExceptionHelper - Cannot acquire  │
│                JDBC connection                                 │
│  ... 47 more matching entries                                  │
│                                                                │
│  Severity: [ERROR: 34] [WARN: 13] [INFO: 0]                  │
│  [Open in Log Explorer →] [Show full context]                 │
└───────────────────────────────────────────────────────────────┘

WIDGET 6: Connection Pool Metrics (from DB Agent)
┌─ DB Agent: Connection Pool Analysis ──────────────────────────┐
│                                                                │
│  Pool: HikariPool-1 (checkout-service → MySQL)                │
│                                                                │
│  Active Connections     Pool Utilization                       │
│  [CHART: maxed out]     [CHART: 100% flat]                   │
│  5/5 (max reached)      100% since 3:01 AM                   │
│                                                                │
│  Wait Queue: 23 threads · Avg wait: 4.2s · Max wait: 30s    │
│  Timeout rate: 78% of requests timing out                     │
│                                                                │
│  Config comparison:                                            │
│  ┌──────────────┬───────────┬───────────┐                    │
│  │ Setting      │ v2.4.0    │ v2.4.1    │                    │
│  │ maxPoolSize  │ 20        │ 5 ⚠️      │                    │
│  │ minIdle      │ 5         │ 2         │                    │
│  │ timeout      │ 30000ms   │ 30000ms   │                    │
│  └──────────────┴───────────┴───────────┘                    │
│                                                                │
│  [Open in Database Monitoring →]                              │
└───────────────────────────────────────────────────────────────┘

WIDGET 7: Entity Relationship Map (when relevant)
┌─ Service Dependencies ────────────────────────────────────────┐
│                                                                │
│        [api-gateway] ──→ [checkout-service] ⚠️                │
│                           ├──→ [payment-service] ✅           │
│                           ├──→ [inventory-service] ✅         │
│                           └──→ [MySQL DB] ⚠️                 │
│                                                                │
│  ⚠️ = affected by this incident                              │
│  Click any node to see its golden signals                     │
│  [Open in Service Map →]                                      │
└───────────────────────────────────────────────────────────────┘
```

### 3.5 Bottom Bar: Input & Actions

```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│  💬 [Ask the agent or steer the investigation...              ] [↑]  │
│                                                                      │
│  Quick: [📋 Create Incident] [📱 Page Team] [🔙 Rollback]          │
│         [💬 Share to Slack] [📝 Create Jira] [📄 Export Report]     │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

**Chat input behaviors:**
- Type a question: "What about the payment service?" → agent investigates and adds findings
- Type a redirect: "I think it's the Kafka consumer, not the DB" → agent adjusts hypotheses
- Type a command: "Create a P1 incident for this" → triggers action flow
- @-mention an agent: "@DB-Agent check the slow query log" → sends task to specific agent

**Quick action buttons:**
- Appear based on investigation state
- During investigation: Create Incident, Page Team, Share
- After conclusion: Rollback, Create Jira, Export Report, Create Post-Mortem
- Each action pre-fills with investigation context

---

## 4. Specialized Agent System

### 4.1 Agent Registry

The SRE Agent is the **primary orchestrator**. It delegates to specialized agents when needed:

```
SRE Agent (Orchestrator)
├── DB Agent            → Database-specific analysis (pools, queries, locks, replication)
├── K8s Agent           → Kubernetes analysis (pods, deployments, nodes, resource limits)
├── Infra Agent         → Infrastructure analysis (hosts, CPU, memory, disk, network)
├── APM Agent           → Application performance (transactions, errors, code-level)
├── Log Analyzer Agent  → Log pattern analysis (anomalies, error clustering)
├── Change Agent        → Deployment impact analysis (pre/post comparison)
└── Remediation Agent   → Executes approved actions (rollback, restart, scale)
```

**External agents (via MCP):**
```
├── PagerDuty Agent     → Incident creation, escalation, responder status
├── Jira Agent          → Ticket creation, status updates
├── Slack Agent         → Message posting, thread management
├── GitHub Agent        → PR lookup, diff analysis, code search
└── Custom MCP Agents   → Customer-defined integrations
```

### 4.2 How Delegation Looks in the UI

When SRE Agent hands off to a specialized agent, the user sees:

```
┌─ AGENT HANDOFF ────────────────────────────────────────────────┐
│                                                                 │
│  🤖 SRE Agent → 🗄 DB Agent                                   │
│                                                                 │
│  "The connection pool metrics suggest a database issue.         │
│  Delegating to DB Agent for deeper analysis."                  │
│                                                                 │
│  Passing context:                                               │
│  • Entity: checkout-service                                    │
│  • Finding: HikariPool connection exhaustion                   │
│  • Time window: 3:02 AM - 3:15 AM                            │
│  • Related traces: 3 traces with pool timeout                  │
│                                                                 │
│  DB Agent status: 🟢 Analyzing...                              │
│  ├── ☑ Checking pool configuration                             │
│  ├── 🔄 Analyzing query performance                            │
│  └── ⏳ Checking replication status                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

When the DB Agent finishes, its findings appear inline:

```
┌─ DB AGENT FINDINGS ─────────────────────────────────── 🗄 ────┐
│                                                                 │
│  Connection Pool Analysis                                       │
│                                                                 │
│  The HikariPool for checkout-service is configured with         │
│  maxPoolSize=5 (changed from 20 in v2.4.1). Under current     │
│  load (1.2K req/s), this is insufficient.                      │
│                                                                 │
│  Additionally found:                                            │
│  • 1 long-running query from reporting-service (12 min)        │
│  • This query holds 3 of the 5 available connections           │
│  • Remaining 2 connections serving all checkout traffic        │
│                                                                 │
│  Recommended:                                                   │
│  1. Kill the reporting query (immediate relief)                │
│  2. Restore maxPoolSize to 20 (config fix)                    │
│  3. Add connection pool alerting (prevention)                  │
│                                                                 │
│  [View full DB analysis →]                                     │
└─────────────────────────────────────────────────────────────────┘
```

### 4.3 Agent Roster Bar (Header)

Shows all agents and their real-time status:

```
AGENTS:
[🤖 SRE Agent: Synthesizing] [🗄 DB Agent: Complete ✅] [☸ K8s Agent: Idle]
[📊 PagerDuty: 3 online] [🎫 Jira: INC-4521]
```

**States per agent:**
- `● Active: {what it's doing}` (green dot, animated)
- `✅ Complete` (green check, static)
- `○ Available` (grey dot, can be invoked)
- `⚠️ Error` (orange, click for details)
- `🔌 Connected` (for external agents, shows live status)

**Click on any agent** → shows a popover:

```
┌─ 🗄 DB Agent ──────────────────────────────────┐
│                                                  │
│ Status: Complete ✅                              │
│ Ran for: 45 seconds                             │
│ Tools used: 4                                    │
│ • analyze_connection_pool                        │
│ • list_active_queries                            │
│ • check_replication_status                       │
│ • get_pool_config                                │
│                                                  │
│ Findings: Connection pool exhaustion             │
│ Confidence: HIGH                                 │
│                                                  │
│ Memory: 3 learned patterns for this DB           │
│ [View DB Agent Memory →]                         │
│                                                  │
│ [🔄 Re-run analysis] [📋 View raw output]       │
└──────────────────────────────────────────────────┘
```

### 4.4 Cross-Agent Memory Architecture

Each specialized agent has its own memory domain, plus shared memory:

```
MEMORY ARCHITECTURE:

Shared Memory (all agents can read/write)
├── Investigation history (all past investigations)
├── Entity metadata (service names, GUIDs, teams, owners)
├── Known patterns (nightly batch = noise, etc.)
└── Customer-provided context (architecture, runbooks)

Per-Agent Memory
├── SRE Agent Memory
│   ├── Alert-to-root-cause patterns
│   ├── Effective investigation strategies per service
│   └── False positive patterns
├── DB Agent Memory
│   ├── Normal query performance baselines per database
│   ├── Known slow queries (expected vs unexpected)
│   ├── Pool config history per service
│   └── Replication lag thresholds
├── K8s Agent Memory
│   ├── Normal pod scaling patterns
│   ├── Resource limit sweet spots per deployment
│   ├── Known CrashLoopBackOff causes per service
│   └── Node capacity thresholds
├── Infra Agent Memory
│   ├── Normal CPU/memory baselines per host
│   ├── Disk growth rates and capacity planning
│   └── Network latency baselines between services
└── Change Agent Memory
    ├── Deploy-to-incident correlation history
    ├── High-risk change patterns
    └── Safe rollback history per service
```

---

## 5. Response Rendering System

### 5.1 Response Block Types

Every agent response is decomposed into **typed blocks**. The frontend renders each block using the appropriate component.

```typescript
// Response block type definition (for prototyping)
type ResponseBlock =
  | { type: 'text'; content: string; emphasis?: 'normal' | 'finding' | 'warning' }
  | { type: 'metric_chart'; entity_guid: string; metric: string; time_range: TimeRange; values: DataPoint[] }
  | { type: 'log_snippet'; logs: LogEntry[]; total_count: number; query: string }
  | { type: 'trace_flamegraph'; trace_id: string; spans: Span[]; highlight_span?: string }
  | { type: 'entity_card'; entity: Entity; golden_signals: GoldenSignals }
  | { type: 'deployment_card'; deployment: Deployment; correlation?: string }
  | { type: 'error_group'; errors: ErrorGroup[]; total_impact: number }
  | { type: 'nrql_result'; query: string; result: NRQLResult; chart_type: 'table' | 'line' | 'bar' }
  | { type: 'code_block'; language: string; code: string; copyable: boolean }
  | { type: 'action_card'; action: Action; risk: 'low' | 'medium' | 'high'; needs_approval: boolean }
  | { type: 'hypothesis'; id: string; title: string; status: HypothesisStatus; evidence: Evidence[] }
  | { type: 'comparison'; before: DataSnapshot; after: DataSnapshot; diff: Diff[] }
  | { type: 'service_map'; entities: Entity[]; relationships: Relationship[]; affected: string[] }
  | { type: 'config_diff'; file: string; before: string; after: string; highlighted_lines: number[] }
  | { type: 'agent_handoff'; from_agent: string; to_agent: string; context: any }
  | { type: 'conclusion'; root_cause: string; confidence: string; evidence_count: number; actions: Action[] }
  | { type: 'feedback_prompt'; investigation_id: string }
```

### 5.2 Rendering Rules

1. **Never render raw JSON.** Always use a typed component.
2. **Metric data always renders as a chart.** Even if the agent says "error rate increased from 0.2% to 4.8%," render the chart and add the text as annotation.
3. **Traces always render as flame graphs.** Clickable spans.
4. **Logs always render with syntax highlighting.** Color by severity. Collapsible.
5. **Entity references always render as clickable cards.** Golden signal sparklines inline.
6. **Code/commands always have copy buttons.** Monospace font.
7. **Actions always show risk level and approval flow.** Low risk = auto-execute. High risk = explicit approval.
8. **Links to NR products always open in context.** "Open in APM →" should open APM filtered to the entity and time range.

---

## 6. Real-Time Streaming UX

### 6.1 What the User Sees During Investigation

The experience is designed around **progressive disclosure**. Content streams in as the agent works.

**Second 0-5: Investigation starts**
```
[Header: 🟢 Investigating · Checkout Service Error Spike]
[Left: "Starting investigation..." with pulsing animation]
[Right: Empty, but with skeleton loaders for upcoming widgets]
```

**Second 5-15: Context phase**
```
[Left: Context card appears with entity info, time window]
[Left: Knowledge check shows 3 parallel sources being checked]
[Right: Alert context card appears]
[Right: Golden signals chart starts loading, shows skeleton, then renders]
```

**Second 15-45: Initial findings**
```
[Left: Initial findings card appears with summary text]
[Right: Deployment timeline widget appears]
[Right: Error traces widget starts rendering]
```

**Second 45-120: Hypothesis phase**
```
[Left: First hypothesis card appears with status: 🟡 Testing]
[Left: Second hypothesis appears below]
[Right: More widgets appear as agent queries data]
[Right: Widgets update when new data arrives (smooth animation)]

User can interact at any point:
- Scroll to see all content
- Click evidence links
- Type questions in chat
- Skip/prioritize hypotheses
```

**Second 120-180: Conclusion**
```
[Left: Hypothesis statuses update: H1 → 🟢 Validated, H3 → 🔴 Invalidated]
[Left: Conclusion card appears with root cause, actions, feedback]
[Header: Status changes from "🟢 Investigating" to "🟢 Conclusive"]
[Header: Title updates to the actual root cause text]
```

### 6.2 Loading States

Every component has 3 states:
1. **Skeleton**: Grey placeholder matching the shape of the final component
2. **Loading**: Component frame visible, data streaming in (for charts: axes appear, data points animate in)
3. **Complete**: Full interactive component

### 6.3 Agent Trace View (Toggle)

For power users who want to see raw agent reasoning:

```
┌─ AGENT TRACE ──────────────────────────────────────────────────┐
│                                                                 │
│  [10:02:01] SRE Agent → Planning                               │
│  Plan: alert_triage (pre-approved, 7 steps)                    │
│                                                                 │
│  [10:02:02] SRE Agent → Entity Lookup Agent                    │
│  Tool: fetch_entity(name="checkout-service", domain="APM")     │
│  Result: GUID=Nzc5ODIwfEFQT... account=779820                 │
│  Duration: 340ms                                                │
│                                                                 │
│  [10:02:03] SRE Agent → Analysis Agent                         │
│  Tool: analyze_entity_golden_metrics(entity_guid=..., ...)     │
│  Result: error_rate spike 0.2% → 4.8% at 03:02:14 UTC        │
│  Duration: 1.2s                                                 │
│                                                                 │
│  [10:02:04] SRE Agent → Analysis Agent                         │
│  Tool: analyze_entity_application_logs(entity_guid=..., ...)   │
│  Result: 47 ERROR logs, pattern: HikariPool connection timeout │
│  Duration: 2.1s                                                 │
│                                                                 │
│  [10:02:05] SRE Agent → Deployment Agent                       │
│  Tool: list_change_events(entity_guid=..., ...)                │
│  Result: Deploy v2.4.1 at 02:45 AM, 3 files changed           │
│  Duration: 890ms                                                │
│                                                                 │
│  [10:02:07] SRE Agent → Thinking                               │
│  "Error spike correlates with deploy v2.4.1. HikariPool        │
│  connection timeouts suggest pool exhaustion. Forming           │
│  hypothesis: deployment changed pool configuration."            │
│                                                                 │
│  [10:02:07] SRE Agent → DB Agent (HANDOFF)                     │
│  Context: entity_guid, finding=pool_exhaustion, time_window    │
│  ...                                                            │
│                                                                 │
│  [Filter: All | SRE Agent | DB Agent | Tools Only | Errors]    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 7. Human-in-the-Loop Interactions

### 7.1 Steering During Investigation

**Redirect via chat:**
```
User: "Also check the Kafka consumer lag"
  ↓
Agent response in chat: "Adding Kafka consumer analysis to the investigation plan."
  ↓
New hypothesis appears: "H4: Kafka Consumer Lag → ⚪ Queued"
  ↓
Agent begins investigating when current hypothesis completes
```

**Skip a hypothesis (click):**
```
User clicks [⏭ Skip] on H3
  ↓
H3 status changes to: "⏭ Skipped by user"
  ↓
Agent moves to next hypothesis immediately
```

**Prioritize a hypothesis (click):**
```
User clicks [⬆ Prioritize] on H4
  ↓
H4 moves above other queued hypotheses
  ↓
Agent investigates H4 next
```

**Add context (chat):**
```
User: "We ran a database migration at 2:55 AM that isn't in change tracking"
  ↓
Agent: "Thanks. I'll incorporate this into the investigation. This could explain
the timing of the pool exhaustion — checking if the migration altered pool settings."
  ↓
Context badge appears on investigation header: "1 user-provided context"
```

### 7.2 Action Approval Flows

**Low Risk (auto-approved):**
```
Agent action: Query additional metrics
→ Executes immediately, shows result
No user interaction needed
```

**Medium Risk (confirmation dialog):**
```
Agent recommends: Create Jira ticket OPS-1234
  ↓
┌─ Confirm Action ──────────────────────────────────┐
│                                                    │
│ 📝 Create Jira Ticket                             │
│                                                    │
│ Project: OPS                                       │
│ Type: Incident                                     │
│ Priority: P1                                       │
│ Title: Checkout service connection pool exhaustion │
│ Description: [auto-filled from investigation]      │
│ Assignee: On-call (Sarah Chen)                    │
│                                                    │
│ [Edit before creating] [✅ Create] [❌ Cancel]    │
└────────────────────────────────────────────────────┘
```

**High Risk (full approval with impact assessment):**
```
Agent recommends: Rollback deployment v2.4.1
  ↓
┌─ ⚠️ High-Risk Action: Requires Approval ─────────────────────┐
│                                                                │
│ 🔙 ROLLBACK: checkout-service v2.4.1 → v2.4.0               │
│                                                                │
│ IMPACT ASSESSMENT:                                             │
│ • Will revert 3 files (config change only, no schema changes) │
│ • v2.4.0 was stable for 14 days in production                │
│ • 0 database migrations to reverse                            │
│ • Estimated downtime: 0 (rolling deployment)                  │
│ • Estimated recovery: 2-3 minutes                             │
│                                                                │
│ WHAT WILL HAPPEN:                                              │
│ $ kubectl rollout undo deployment/checkout-service             │
│ in namespace: production                                       │
│                                                                │
│ RISK LEVEL: 🟢 LOW                                            │
│ Reason: Clean rollback, no data dependencies                  │
│                                                                │
│ [✅ Approve Rollback] [🔍 Show Diff] [❌ Reject]             │
│                                                                │
│ Note: This action will be logged in the investigation audit    │
│ trail and can be reversed.                                     │
└────────────────────────────────────────────────────────────────┘
```

---

## 8. Memory System UX

### 8.1 Memory Dashboard (/ai/memory)

```
┌─ Agent Memory ─────────────────────────────────────────────────────┐
│                                                                     │
│  [Learned Patterns] [Runbooks] [Architecture] [Known Noise]        │
│                                                                     │
│  ═══════════════════════════════════════════════════════════════    │
│                                                                     │
│  LEARNED PATTERNS                                    14 total       │
│  These are patterns the agent learned from investigation feedback.  │
│                                                                     │
│  ┌─ Service: checkout-service ─────────────────────── 5 patterns ┐ │
│  │                                                                │ │
│  │  "Pool exhaustion after deploys → check config changes"       │ │
│  │  Learned: Mar 5 (Investigation #47)                           │ │
│  │  Used in: 3 investigations · Accuracy: 100%                   │ │
│  │  [✏️ Edit] [🗑️ Delete] [👁 View source investigation]        │ │
│  │                                                                │ │
│  │  "High latency + normal throughput → downstream dependency"   │ │
│  │  Learned: Feb 28 (Investigation #39)                          │ │
│  │  Used in: 1 investigation · Accuracy: 100%                    │ │
│  │  [✏️ Edit] [🗑️ Delete] [👁 View source]                      │ │
│  │                                                                │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                     │
│  ┌─ Service: payment-service ─────────────────────── 3 patterns ┐  │
│  │  ...                                                          │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌─ Global (all services) ────────────────────────── 6 patterns ┐  │
│  │  ...                                                          │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  [+ Manually add a pattern]                                        │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 8.2 Per-Agent Memory View

Click into a specific agent's memory:

```
┌─ 🗄 DB Agent Memory ──────────────────────────────────────────────┐
│                                                                     │
│  QUERY BASELINES                                                    │
│  ┌──────────────────────────────────────────────────────────┐     │
│  │ checkout-db (MySQL 8.0 on RDS)                           │     │
│  │ Normal query time: P50=12ms P95=45ms P99=120ms          │     │
│  │ Normal pool usage: 30-60% (maxPool=20)                  │     │
│  │ Last updated: Mar 10 (auto-refreshed weekly)            │     │
│  │                                                          │     │
│  │ inventory-db (PostgreSQL 15)                             │     │
│  │ Normal query time: P50=8ms P95=30ms P99=85ms            │     │
│  │ Normal pool usage: 20-40% (maxPool=30)                  │     │
│  │ Last updated: Mar 10                                     │     │
│  └──────────────────────────────────────────────────────────┘     │
│                                                                     │
│  KNOWN SLOW QUERIES (expected, don't alert)                        │
│  ┌──────────────────────────────────────────────────────────┐     │
│  │ • reporting-service nightly aggregate (2-3 AM, ~10 min) │     │
│  │ • analytics ETL batch (Sunday 4 AM, ~30 min)            │     │
│  │ [+ Add known slow query]                                 │     │
│  └──────────────────────────────────────────────────────────┘     │
│                                                                     │
│  INVESTIGATION PATTERNS                                             │
│  ┌──────────────────────────────────────────────────────────┐     │
│  │ • "Pool at 100% + long query → find and kill blocker"   │     │
│  │ • "Replication lag > 5s → check write volume"           │     │
│  │ • "Connection refused → check max_connections limit"     │     │
│  └──────────────────────────────────────────────────────────┘     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 8.3 How Memory is Created

Memory is created through 3 paths:

**Path 1: Investigation feedback (automatic)**
```
User rates conclusion as "Correct"
  ↓
System extracts: {alert_type, service, root_cause_pattern, effective_tools}
  ↓
Creates memory: "For [service], when [alert_type], check [root_cause_pattern]"
  ↓
Memory appears in dashboard with source: "Investigation #47"
```

**Path 2: Manual addition (user-initiated)**
```
User clicks [+ Add pattern] on memory dashboard
  ↓
Form:
  Service: [checkout-service ▾]
  Pattern: [_________________________________]
  Example: "Nightly batch job at 2 AM causes CPU spike. This is expected."
  Agent: [All agents ▾] or [Specific agent ▾]
  [Save]
```

**Path 3: Runbook/doc integration (linked)**
```
User links a Confluence page or uploads a doc
  ↓
Agent parses the doc for:
  • Service names and relationships
  • Troubleshooting steps
  • Known issues and resolutions
  ↓
Extracted knowledge appears in memory with source: "Runbook: checkout-service-playbook"
```

---

## 9. Configuration & Onboarding

### 9.1 First-Time Setup (/ai/settings)

```
┌─ Set Up Your AI Agents ───────────────────────────────────────────┐
│                                                                     │
│  Step 1 of 4: Auto-Investigation Rules                             │
│  ───────────────────────────────────────────────────────────────── │
│                                                                     │
│  Which alerts should the agent investigate automatically?          │
│                                                                     │
│  ○ All P1 (Critical) alerts                                       │
│  ○ All P1 and P2 alerts                                           │
│  ○ All alerts on specific services:                                │
│    [checkout-service ×] [payment-service ×] [+ Add service]       │
│  ○ Don't auto-investigate (I'll trigger manually)                  │
│                                                                     │
│  Rate limit: Max [20 ▾] auto-investigations per day               │
│                                                                     │
│  [Next: Connect Your Tools →]                                      │
│                                                                     │
│  Step 2 of 4: Connect External Tools                               │
│  ───────────────────────────────────────────────────────────────── │
│                                                                     │
│  Where should findings be sent?                                    │
│                                                                     │
│  Slack:      [#ops-incidents ▾]  [Connect Slack]                  │
│  PagerDuty:  [Connected ✅]      [Configure]                      │
│  Jira:       [Not connected]     [Connect Jira]                   │
│  GitHub:     [Connected ✅]      [Configure]                      │
│                                                                     │
│  [Next: Teach Your Agent →]                                        │
│                                                                     │
│  Step 3 of 4: Teach Your Agent                                     │
│  ───────────────────────────────────────────────────────────────── │
│                                                                     │
│  Help the agent understand your environment:                       │
│                                                                     │
│  Architecture description (optional):                              │
│  [Our system has a React frontend, Java backend with              │
│   Spring Boot microservices, MySQL databases on RDS,              │
│   and Kafka for async messaging. The checkout flow               │
│   goes through api-gateway → checkout-service →                  │
│   payment-service → inventory-service.]                           │
│                                                                     │
│  Runbooks (optional):                                              │
│  [📎 Upload] [🔗 Link Confluence page]                            │
│  Linked: checkout-runbook.md ✅                                    │
│                                                                     │
│  Known noise (optional):                                           │
│  [+ Add] Nightly batch job 2-3 AM causes CPU spike               │
│  [+ Add] Monthly report gen causes DB load first Sunday          │
│                                                                     │
│  [Next: Review & Activate →]                                       │
│                                                                     │
│  Step 4 of 4: Review                                               │
│  ───────────────────────────────────────────────────────────────── │
│                                                                     │
│  Auto-investigate: P1 alerts on all services                       │
│  Rate limit: 20/day                                                │
│  Slack: #ops-incidents                                             │
│  PagerDuty: Connected                                              │
│  Architecture: Provided                                            │
│  Runbooks: 1 linked                                                │
│  Known noise: 2 patterns                                           │
│                                                                     │
│  [← Back] [🚀 Activate AI Agents]                                 │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 10. Reports & Effectiveness

### /ai/reports

```
┌─ AI Agent Effectiveness ───────────────────────────────────────────┐
│                                                                     │
│  Period: [Last 30 days ▾]   Services: [All ▾]   Team: [All ▾]    │
│                                                                     │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐  │
│  │ 47         │  │ 84%        │  │ 3.2 min    │  │ 32%        │  │
│  │ Total      │  │ Accuracy   │  │ Avg time   │  │ Auto-      │  │
│  │ investig.  │  │ rate       │  │ to concl.  │  │ resolved   │  │
│  └────────────┘  └────────────┘  └────────────┘  └────────────┘  │
│                                                                     │
│  MTTR IMPACT                                                        │
│  [LINE CHART: MTTR before agent vs after agent, by week]           │
│  Before: 23 min avg → After: 8 min avg (65% reduction)            │
│                                                                     │
│  INVESTIGATIONS BY SERVICE                                          │
│  [BAR CHART: checkout(12), payment(8), search(7), ...]             │
│                                                                     │
│  TOP ROOT CAUSES                                                    │
│  1. Connection pool exhaustion (8 times)                           │
│  2. Deployment regression (6 times)                                │
│  3. Resource limits exceeded (5 times)                             │
│  4. Upstream dependency failure (4 times)                          │
│                                                                     │
│  AGENT USAGE BY TYPE                                                │
│  SRE Agent: 47 | DB Agent: 12 | K8s Agent: 8 | Infra: 5          │
│                                                                     │
│  FEEDBACK BREAKDOWN                                                 │
│  ✅ Correct: 36 | 🔄 Partial: 5 | ❌ Wrong: 4 | No feedback: 2   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 11. Component Specifications (for vibe coding)

### Key React Components to Build

```
/components
├── /investigation
│   ├── InvestigationCanvas.tsx          ← Main page component
│   ├── InvestigationHeader.tsx          ← Status, title, agents, actions
│   ├── ReasoningStream.tsx             ← Left zone container
│   ├── EvidencePanel.tsx               ← Right zone container
│   ├── BottomBar.tsx                   ← Chat input + quick actions
│   ├── ConclusionCard.tsx             ← Root cause + actions + feedback
│   └── HypothesisCard.tsx             ← Individual hypothesis with states
├── /agents
│   ├── AgentRoster.tsx                 ← Header bar showing active agents
│   ├── AgentHandoff.tsx               ← Handoff visualization
│   ├── AgentPopover.tsx               ← Click-on-agent detail view
│   └── AgentFinding.tsx               ← Specialized agent result card
├── /evidence-widgets
│   ├── GoldenSignalsWidget.tsx         ← 3 sparklines side-by-side
│   ├── DeploymentTimeline.tsx          ← Timeline with correlation markers
│   ├── TraceFlamegraph.tsx            ← Interactive trace visualization
│   ├── LogSnippet.tsx                  ← Syntax-highlighted logs
│   ├── ErrorGroupCard.tsx             ← Error group summary
│   ├── ServiceMapWidget.tsx           ← Entity relationship graph
│   ├── ConfigDiffWidget.tsx           ← Side-by-side config comparison
│   ├── ConnectionPoolWidget.tsx        ← DB-specific pool metrics
│   ├── NRQLResultWidget.tsx           ← Query + rendered result
│   └── AlertContextCard.tsx           ← Alert details summary
├── /actions
│   ├── ActionBar.tsx                   ← Quick action buttons
│   ├── ApprovalDialog.tsx             ← HITL approval for risky actions
│   ├── IncidentCreator.tsx            ← Pre-filled incident form
│   └── SlackShare.tsx                 ← Share to Slack with context
├── /memory
│   ├── MemoryDashboard.tsx            ← /ai/memory page
│   ├── PatternCard.tsx                ← Individual learned pattern
│   ├── RunbookLinker.tsx              ← Upload/link runbooks
│   ├── ArchitectureEditor.tsx         ← Edit architecture description
│   └── AgentMemoryView.tsx            ← Per-agent memory details
├── /streaming
│   ├── useSSEStream.ts                ← SSE connection hook
│   ├── StreamingIndicator.tsx         ← "Agent is thinking..." animation
│   ├── SkeletonBlock.tsx              ← Loading placeholder per block type
│   └── ProgressiveReveal.tsx          ← Animate content appearing
├── /morning-brief
│   ├── MorningBrief.tsx               ← /ai/morning-brief page
│   ├── NeedsAttentionCard.tsx         ← Proactive finding card
│   ├── AutoResolvedCard.tsx           ← Auto-resolved summary
│   └── HealthSummary.tsx              ← Service sparkline grid
└── /settings
    ├── AgentSettings.tsx               ← /ai/settings page
    ├── AutoInvestigateConfig.tsx       ← Per-monitor toggle
    ├── IntegrationConnector.tsx        ← External tool setup
    └── OnboardingWizard.tsx           ← First-time setup flow
```

---

## 12. State Machine: Investigation Lifecycle

```
                    ┌─────────┐
                    │  IDLE   │
                    └────┬────┘
                         │ trigger (auto/manual/slack/prompt)
                         ▼
                    ┌─────────┐
              ┌─────│ PLANNING│
              │     └────┬────┘
              │          │ plan selected/generated
              │          ▼
              │     ┌──────────┐
              │     │GATHERING │ (context, runbook, memory, general scan)
              │     └────┬─────┘
              │          │ initial findings ready
              │          ▼
              │     ┌───────────────┐
              │     │ HYPOTHESIZING │ ◄──── user adds hypothesis
              │     └────┬──────────┘       user skips/prioritizes
              │          │ hypotheses formed
              │          ▼
              │     ┌───────────────┐
    user      │     │  VALIDATING   │ ◄──── agent tests each hypothesis
    cancels   │     │               │       may HANDOFF to specialist agent
    ──────────┤     │  (loop per    │       user can redirect
              │     │   hypothesis) │
              │     └────┬──────────┘
              │          │ all hypotheses tested
              │          ▼
              │     ┌───────────────┐
              │     │ SYNTHESIZING  │ (merge findings, form conclusion)
              │     └────┬──────────┘
              │          │
              │          ▼
              │     ┌───────────────┐
              └────►│  COMPLETE     │
                    │               │
                    │ Conclusive    │──── user provides feedback ──► MEMORY UPDATED
                    │ Inconclusive  │
                    │ Error         │
                    └───────────────┘
```

**Investigation states (for the status badge):**
- `PLANNING` → "Planning..." (grey, spinner)
- `GATHERING` → "Gathering context..." (blue, spinner)
- `HYPOTHESIZING` → "Forming hypotheses..." (blue, spinner)
- `VALIDATING` → "Investigating..." (green, pulse)
- `SYNTHESIZING` → "Synthesizing findings..." (green, spinner)
- `CONCLUSIVE` → "Conclusive" (green, solid)
- `INCONCLUSIVE` → "Inconclusive" (yellow, solid)
- `ERROR` → "Error" (red, solid)
- `CANCELLED` → "Cancelled" (grey, solid)

---

## 13. Data Model (for prototyping)

```typescript
// Core types for building the prototype

interface Investigation {
  id: string;
  status: 'planning' | 'gathering' | 'hypothesizing' | 'validating' | 'synthesizing' | 'conclusive' | 'inconclusive' | 'error' | 'cancelled';
  title: string;                    // auto-generated, updates at conclusion
  source: 'monitor' | 'manual' | 'slack' | 'apm' | 'proactive';
  trigger: {
    alert_id?: string;
    monitor_id?: string;
    entity_guid?: string;
    user_prompt?: string;
    slack_thread?: string;
  };
  started_at: Date;
  completed_at?: Date;
  initiated_by: string;             // user ID or "auto"
  active_agents: AgentStatus[];
  phases: Phase[];
  conclusion?: Conclusion;
  feedback?: Feedback;
  memory_created?: Memory[];
}

interface Phase {
  id: string;
  type: 'context' | 'initial_findings' | 'hypotheses' | 'conclusion';
  status: 'active' | 'complete';
  blocks: ResponseBlock[];          // the actual content
  started_at: Date;
  completed_at?: Date;
}

interface Hypothesis {
  id: string;
  title: string;
  status: 'queued' | 'testing' | 'validated' | 'invalidated' | 'inconclusive' | 'skipped';
  description: string;
  evidence: Evidence[];
  delegated_to?: string;            // agent name if handed off
  agent_findings?: ResponseBlock[]; // results from specialist agent
  user_actions: UserAction[];       // skip, prioritize, pin
}

interface Evidence {
  type: 'metric' | 'log' | 'trace' | 'deployment' | 'config' | 'query_result';
  summary: string;
  widget: ResponseBlock;            // the visual component to render
  confidence: 'high' | 'medium' | 'low';
  link?: string;                    // deep link to NR product
}

interface Conclusion {
  root_cause: string;
  confidence: 'high' | 'medium' | 'low';
  evidence_count: number;
  recommended_actions: Action[];
  time_to_conclusion: number;       // seconds
}

interface Action {
  id: string;
  type: 'rollback' | 'restart' | 'scale' | 'kill_query' | 'create_incident' | 'page_team' | 'create_ticket' | 'share_slack' | 'export_report';
  title: string;
  description: string;
  risk: 'low' | 'medium' | 'high';
  needs_approval: boolean;
  command?: string;                 // shell command if applicable
  status: 'suggested' | 'approved' | 'executing' | 'completed' | 'rejected' | 'failed';
  impact_assessment?: string;
}

interface AgentStatus {
  agent_id: string;
  name: string;                     // "SRE Agent", "DB Agent", etc.
  icon: string;                     // emoji or icon reference
  status: 'active' | 'complete' | 'idle' | 'error';
  current_action?: string;          // "Analyzing connection pool"
  tools_used: string[];
  findings_count: number;
  duration_ms?: number;
}

interface Memory {
  id: string;
  agent: string;                    // which agent owns this memory
  scope: 'global' | 'service' | 'team';
  service?: string;                 // if scope = service
  pattern: string;                  // human-readable pattern
  source: 'investigation_feedback' | 'manual' | 'runbook';
  source_id?: string;               // investigation ID or doc ID
  created_at: Date;
  used_count: number;
  accuracy_rate: number;            // % of times it was correct
  active: boolean;
}

interface Feedback {
  correctness: 'correct' | 'partial' | 'wrong';
  actual_root_cause?: string;       // if wrong/partial
  quality_rating?: number;          // 1-5
  improvement_suggestion?: string;
  submitted_at: Date;
  submitted_by: string;
}
```

---

## Summary: What Makes This the Best SRE Agent UX

1. **Live canvas, not a chatbot.** Full-page experience with reasoning + evidence side by side.
2. **Hypotheses are interactive objects.** Skip, prioritize, pin, expand. Not just text.
3. **Evidence is rendered as native widgets.** Charts, flame graphs, logs, diffs. Not descriptions.
4. **Specialized agents are visible.** You see DB Agent, K8s Agent working. Not hidden.
5. **Multi-agent memory is explicit.** Each agent learns. You can see what it learned and manage it.
6. **Actions are risk-tiered.** Low risk auto-executes. High risk shows impact assessment.
7. **Feedback creates memory.** Every "correct/wrong" rating makes future investigations better.
8. **7 entry points.** Meet users where they are. Auto-trigger, alerts, APM, Slack, prompt.
9. **Morning brief changes the game.** Agent works 24/7, resolves noise, flags real issues.
10. **Cross-platform collaboration.** PagerDuty, Jira, Slack are participants, not integrations.
