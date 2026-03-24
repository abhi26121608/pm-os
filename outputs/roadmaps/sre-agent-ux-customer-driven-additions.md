# SRE Agent UX: Customer-Driven Additions

**Source:** 7-Eleven PM feedback (March 2026)
**Applies to:** [sre-agent-ux-design-roadmap-final.md](sre-agent-ux-design-roadmap-final.md)

These are additions to the existing design roadmap driven by real customer pain points from a major enterprise account (7-Eleven). Each addition maps to an existing workstream.

---

## Addition 1: Prevention Recommendations (NEW section in Conclusion Card)

**Maps to:** Workstream 2 (Reasoning Stream) — Conclusion Card
**Customer pain:** "After RCA, teams don't know where to add logs, attributes, or spans"
**Priority:** P1 (high-value, differentiator)

### What to Add

After the Root Cause and Recommended Fix sections in the conclusion card, add a new **"Prevent Recurrence"** section:

```
┌─ CONCLUSION ───────────────────────────────────────────────────┐
│                                                                 │
│  🎯 ROOT CAUSE                                                 │
│  [existing: what went wrong]                                   │
│                                                                 │
│  🔧 RECOMMENDED FIX                                            │
│  [existing: how to fix it now]                                 │
│                                                                 │
│  ─────────────────────────── NEW SECTION ──────────────────── │
│                                                                 │
│  🛡️ PREVENT RECURRENCE                                        │
│                                                                 │
│  Based on this investigation, here's how to prevent this       │
│  from happening again:                                         │
│                                                                 │
│  1. ADD ALERT                                                  │
│  ┌──────────────────────────────────────────────────────┐     │
│  │ Create alert: "Connection Pool > 80% utilized"       │     │
│  │ Condition: HikariPool active connections > 80%       │     │
│  │ Threshold: 5 min sustained                           │     │
│  │ Severity: Warning (not critical yet, early warning)  │     │
│  │                                                      │     │
│  │ [✅ Create This Alert] [✏️ Customize] [📋 Copy NRQL]│     │
│  └──────────────────────────────────────────────────────┘     │
│                                                                 │
│  2. ADD INSTRUMENTATION                                        │
│  ┌──────────────────────────────────────────────────────┐     │
│  │ Log connection pool metrics in checkout-service:     │     │
│  │                                                      │     │
│  │ ```java                                              │     │
│  │ // Add to HealthCheckController.java                 │     │
│  │ @Scheduled(fixedRate = 30000)                        │     │
│  │ public void logPoolMetrics() {                       │     │
│  │   HikariPoolMXBean pool = dataSource.unwrap(...);    │     │
│  │   logger.info("pool.active={} pool.idle={} ...",     │     │
│  │     pool.getActiveConnections(),                      │     │
│  │     pool.getIdleConnections());                       │     │
│  │ }                                                    │     │
│  │ ```                                                  │     │
│  │                                                      │     │
│  │ [📋 Copy Code] [🔗 Open File in GitHub]             │     │
│  └──────────────────────────────────────────────────────┘     │
│                                                                 │
│  3. ADD DEPLOYMENT GUARD                                       │
│  ┌──────────────────────────────────────────────────────┐     │
│  │ Flag configuration changes to connection pool in CI: │     │
│  │ Add to pre-deploy checks:                            │     │
│  │ "Reject deploys that reduce maxPoolSize by > 50%"   │     │
│  │                                                      │     │
│  │ [📋 Copy Check Config]                               │     │
│  └──────────────────────────────────────────────────────┘     │
│                                                                 │
│  [📥 Export All Recommendations] [🎫 Create Jira for each]    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Why This Is Powerful

Datadog's Bits AI SRE finds the root cause and suggests a fix. That's where it stops.

Our SRE Agent finds the root cause, suggests a fix, AND tells you how to prevent it from ever happening again with:
- Specific alerts to create (one-click)
- Specific code to add (with snippets)
- Specific deployment guards to set up

That's the full loop: **Detect → Diagnose → Fix → Prevent**. Nobody else closes the prevention loop.

### Implementation Notes

The prevention recommendations come from:
- Agent memory (past similar incidents and what fixed them permanently)
- Analysis of what signals were missing during this investigation (e.g., "No pool utilization metric existed, agent had to infer from logs")
- Best practices per technology stack (e.g., HikariCP monitoring best practices)

---

## Addition 2: Business Impact Widget (NEW evidence widget)

**Maps to:** Workstream 3 (Evidence Widget System)
**Customer pain:** "Product teams want to know: did this incident reduce redemptions?"
**Priority:** P2 (requires business metric integration, not all customers have this)

### Widget Design

```
┌─ Business Impact ──────────────────────────────────────────────┐
│                                                                 │
│  ⚠️ Business metrics affected during this incident             │
│                                                                 │
│  Checkout Conversions        Revenue per Hour                  │
│  ┌──────────────┐           ┌──────────────┐                  │
│  │      ╲       │           │      ╲       │                  │
│  │       ╲──────│           │       ╲──────│                  │
│  │              │           │              │                  │
│  │  78% → 54%  │           │ $12K → $6.8K │                  │
│  └──────────────┘           └──────────────┘                  │
│  ▼ 31% during incident      ▼ 43% during incident            │
│                                                                 │
│  Estimated total impact: ~$15,600 in lost revenue             │
│  Duration of impact: 43 minutes                                │
│                                                                 │
│  How this was calculated:                                      │
│  Baseline: $12,000/hr avg (last 7 days, same time window)    │
│  During incident: $6,800/hr                                    │
│  Delta: $5,200/hr × 0.72 hrs = ~$3,744 (conservative)       │
│                                                                 │
│  [Open in Pathpoint →] [Configure Business Metrics →]         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Where It Appears

- In the Evidence Panel (right zone) during investigations that affect services with configured business metrics
- In the Conclusion Card: "This incident caused an estimated $15,600 in lost revenue over 43 minutes"
- In the Morning Brief: "Last night's auto-resolved incident on search-service had minimal business impact ($0 estimated)"
- In Reports: "Total business impact of all incidents this month: $47K"

### Pre-requisites

- Customer must have business metrics flowing into NR (via custom events, Pathpoint, or NRQL queries)
- Agent needs a mapping: service → business KPI
- This mapping can be part of the "Teach Your Agent" onboarding (architecture context)

### Why Include It

SRE teams often can't justify investment in reliability without business impact data. If the SRE Agent automatically shows "$15K lost in 43 minutes," the engineering team can immediately justify the fix to leadership. That's a massive value-add for enterprise customers like 7-Eleven.

---

## Addition 3: Alert Coverage Gaps (in Morning Brief)

**Maps to:** Workstream 10 (Morning Brief / Proactive Mode)
**Customer pain:** "We don't know which components lack alerts until something breaks"
**Priority:** P2

### Addition to Morning Brief

Add a new section below the health summary:

```
┌─ Morning Brief ────────────────────────────────────────────────┐
│                                                                 │
│  [existing: Needs Attention, Auto-Resolved, Health Summary]    │
│                                                                 │
│  ─────────────────────── NEW SECTION ─────────────────────── │
│                                                                 │
│  🔍 COVERAGE GAPS                                              │
│                                                                 │
│  3 services have activity but no alerts configured:            │
│                                                                 │
│  ┌──────────────────────────────────────────────────────┐     │
│  │ 📡 payment-gateway (APM)                             │     │
│  │ Receives 2.4K req/s but has 0 alert conditions       │     │
│  │ Recommendation: Add error rate + P95 latency alerts  │     │
│  │ [✅ Create Recommended Alerts] [⏭ Skip]              │     │
│  ├──────────────────────────────────────────────────────┤     │
│  │ 📡 inventory-sync-worker (APM)                       │     │
│  │ Shows periodic errors (12/day) but no alerts         │     │
│  │ Recommendation: Add error count threshold alert      │     │
│  │ [✅ Create] [⏭ Skip]                                │     │
│  ├──────────────────────────────────────────────────────┤     │
│  │ 🖥️ db-replica-east (Infrastructure)                  │     │
│  │ Replication lag has exceeded 5s twice this week       │     │
│  │ but no replication lag alert exists                   │     │
│  │ [✅ Create] [⏭ Skip]                                │     │
│  └──────────────────────────────────────────────────────┘     │
│                                                                 │
│  Coverage score: 78% of active services have alerts            │
│  (up from 72% last month)                                      │
│  [View Full Coverage Report →]                                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Full Coverage Report Page (/ai/coverage)

```
┌─ Alert Coverage Report ────────────────────────────────────────┐
│                                                                 │
│  Overall: 47 of 60 services have alerts (78%)                  │
│                                                                 │
│  [■■■■■■■■■■■■■■■■■■■■■■■■■■░░░░░░] 78%                      │
│                                                                 │
│  BY CATEGORY:                                                   │
│  APM Services:      32/38 (84%) ██████████████████░░░          │
│  Infrastructure:    10/14 (71%) ███████████████░░░░░           │
│  Databases:          3/5  (60%) ██████████████░░░░░░           │
│  Kubernetes:         2/3  (67%) █████████████░░░░░░░           │
│                                                                 │
│  MISSING ALERTS (13 services):                                  │
│  [Sortable table: Service, Type, Traffic, Anomalies, Recommended Action]
│                                                                 │
│  [🤖 Auto-create all recommended alerts]                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Addition 4: Journey Flow View (Enhanced Entity Map Widget)

**Maps to:** Workstream 3 (Evidence Widget System) — Entity Relationship Map
**Customer pain:** "Can observe each system individually but not as a single flow"
**Priority:** P2

### Current vs. Enhanced

**Current entity map** (in our spec): Shows service dependencies as a graph (A → B → C).

**Enhanced "Journey Flow" view**: Shows the business journey as a horizontal flow with stages, not just service dependencies.

```
┌─ Journey Flow: Checkout ───────────────────────────────────────┐
│                                                                 │
│  CUSTOMER JOURNEY STAGES:                                      │
│                                                                 │
│  [Browse] → [Add to Cart] → [Checkout] → [Payment] → [Confirm]│
│    ✅          ✅             ⚠️ HERE      ✅          ✅      │
│   12ms        45ms          4,200ms ⚠️    89ms        23ms    │
│                                                                 │
│  TECHNICAL SERVICES (mapped to stages):                        │
│                                                                 │
│  Browse:     frontend-web, search-service                      │
│  Cart:       cart-service, inventory-service                   │
│  Checkout:   checkout-service ⚠️, payment-gateway             │
│  Payment:    payment-service, stripe-api (external)            │
│  Confirm:    notification-service, email-service               │
│                                                                 │
│  IMPACT: Checkout stage failure is blocking 78% of orders      │
│          34 orders/min affected (est. $2,400/min revenue loss) │
│                                                                 │
│  [Open in Pathpoint →] [Configure Journey Stages →]           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Why It Matters

The entity relationship map shows technical dependencies. The journey flow shows business impact. An SRE sees "checkout-service is down." A product manager sees "the checkout stage is blocked, affecting $2,400/min in orders." Same incident, different lens.

This maps to NR's existing Pathpoint product. The SRE Agent should pull Pathpoint data into the investigation canvas when available.

---

## Addition 5: "Related Incidents" Card (in Investigation Canvas)

**Maps to:** Workstream 2 (Reasoning Stream) and Workstream 14 (Reports)
**Customer pain:** "Recurring incidents due to incomplete signal correlation"
**Priority:** P1

### Addition to Investigation Canvas

When the agent detects a pattern similar to a past investigation, show a card:

```
┌─ 🔁 RECURRING PATTERN DETECTED ───────────────────────────────┐
│                                                                 │
│  This looks similar to 2 past investigations:                  │
│                                                                 │
│  📋 Mar 5: "Checkout pool exhaustion after deploy v2.3.8"     │
│     Root cause: Same — pool config reduced in deploy           │
│     Resolution: Rollback (took 8 min)                          │
│     Prevention actions: ⚠️ None were implemented               │
│     [View investigation →]                                     │
│                                                                 │
│  📋 Feb 18: "Checkout timeout during peak traffic"             │
│     Root cause: Related — pool at capacity under load          │
│     Resolution: Scaled pool to 30                              │
│     Prevention actions: ✅ Alert added, but config not locked  │
│     [View investigation →]                                     │
│                                                                 │
│  ⚠️ This pattern has recurred 3 times. Recommended:           │
│  Lock connection pool config in deployment pipeline.           │
│  [🎫 Create Jira for permanent fix]                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Why This Is Critical

The 7-Eleven PM said: "Errors inbox helps, but multi-service issues still require manual investigation." Our recurring pattern card directly addresses this by:
1. Automatically connecting this incident to past similar ones
2. Showing whether prevention actions from past incidents were actually implemented
3. Recommending permanent fixes when a pattern recurs more than twice

This is the "help us prevent repeats" ask directly translated into UI.

---

## Summary: How These Map to the Roadmap

| Addition | Workstream | Priority | Effort | Unique vs. DD? |
|---|---|---|---|---|
| **Prevention recommendations** | 2 (Conclusion Card) | P1 | Medium | ✅ DD doesn't do this |
| **Business impact widget** | 3 (Evidence Widgets) | P2 | Medium (needs Pathpoint) | ✅ DD doesn't do this |
| **Alert coverage gaps** | 10 (Morning Brief) | P2 | Low-Medium | ✅ DD doesn't do this |
| **Journey flow view** | 3 (Evidence Widgets) | P2 | High (needs Pathpoint) | ✅ DD doesn't do this |
| **Recurring pattern card** | 2 (Reasoning Stream) | P1 | Medium (needs memory) | Partial (DD has memories) |

All five additions are things Datadog doesn't have. They come from real enterprise customer pain. And they all reinforce our "the agent that shows its work AND prevents future incidents" positioning.

The biggest win: **Prevention recommendations in the conclusion card.** That closes the loop from "we found the problem" to "here's how to make sure it never happens again." No other SRE agent does this.
