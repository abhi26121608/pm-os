# SRE Agent: Delivery Surface Strategy (Final)

**Owner:** Abhishek Pandey | **Date:** 2026-03-12

## Decision: Two Surfaces Only

| Surface | Role | Ship When |
|---|---|---|
| **In-Platform Investigation Canvas** | Primary (full experience) | LP/PP |
| **Slack App** | Secondary (trigger + summary + actions) | PP |

Everything else is post-GA exploration. We focus.

## Why Slack Wins Over Chrome Extension

| Factor | Slack | Chrome Extension |
|---|---|---|
| Where SREs are at 3 AM | ✅ Alert lands here | ❌ Nobody opens Chrome |
| Team collaboration | ✅ Whole team sees findings | ❌ Single-user browser |
| Action approval on mobile | ✅ Mobile Slack works | ❌ No mobile extensions |
| Datadog parity | ✅ Table stakes | ❌ Cool but unnecessary |
| Install friction | ✅ Admin installs once | ❌ Every user installs |
| Engineering effort | ✅ Extend existing NR Slack | ❌ New codebase |

## Surface 1: Canvas (Primary)

See main design roadmap. Full-page at `/ai/investigations/{id}` with split-pane reasoning + evidence layout.

## Surface 2: Slack App — Detailed Design

### Principle: Slack = Awareness + Decisions. Canvas = Everything Else.

### 6 Message Types

**1. Alert + Investigate Button**
```
🔴 ALERT: High Error Rate on checkout-service
Condition: error_rate > 1% for 5 min | Current: 4.8%
[🤖 Investigate]  [👁 Ack]  [🔇 Mute]
```

**2. Investigation Started** (thread reply)
```
🤖 Investigation started for checkout-service.
Checking golden signals, deployments, logs, dependencies.
⏱ Usually 2-4 min. [🔗 Watch Live →]
```

**3. Initial Findings** (thread reply, ~30s)
```
📋 Connection refused errors on api-gateway → HTTP 500.
Deploy v2.4.1 (2:45 AM) correlates with spike.
Investigating 3 hypotheses... [🔗 View Live →]
```

**4. Root Cause + Actions** (thread reply, ~3 min)
```
🎯 Root Cause — HIGH confidence
━━━━━━━━━━━━━━━━━━━━━━━━━━
Deploy v2.4.1 changed maxPoolSize 20→5.
Pool exhausted under 1.2K req/s → timeouts → 500s.
━━━━━━━━━━━━━━━━━━━━━━━━━━
Evidence: error spike correlates, pool 5/5, 47 timeout logs
🔧 Rollback to v2.4.0 (Risk: LOW, Recovery: 2-3 min)
[✅ Approve Rollback]  [❌ Reject]  [🔗 Full Investigation →]
🛡️ Prevent: Add pool alert >80%, lock config in pipeline
```

**5. Action Executed** (thread reply)
```
✅ Rollback complete. v2.4.1 → v2.4.0
Approved by @sarah.chen | Errors: 4.8%→0.4% | Pool: 100%→35%
Total time: 6 min. [📄 Report] [📝 Post-Mortem] [🎫 Jira]
```

**6. Morning Brief** (daily to configured channel)
```
☀️ Morning Brief (Mar 12)
3 investigations · 2 auto-resolved · 1 needs attention
⚠️ Memory leak in user-auth (78% heap, growing 2%/hr)
[✅ Restart] [🔍 Investigate] [⏰ Snooze]
✅ Search latency → batch job (known) | CPU spike → autoscale (known)
[📊 Full Brief →]
```

### Slash Commands
- `/nr-investigate [description]` → Start investigation
- `/nr-status` → Active investigations
- `/nr-brief` → Morning brief
- `/nr-memory add [pattern]` → Quick memory add

### @-Mentions
- `@NewRelic investigate this alert` → Starts investigation from thread
- `@NewRelic approve` / `@NewRelic reject` → Action response

### What Slack Cannot Do (Must Go to Canvas)
Interactive charts, flame graphs, hypothesis steering, memory management, post-mortem editing, agent handoff visualization, evidence deep-dive, configuration.

Every Slack message has `[🔗 Full Investigation →]` back to the canvas.

### Slack Config (in /ai/settings)
Channel selection, notification preferences, morning brief schedule, who can approve actions (on-call only vs anyone), thread vs new message behavior.

## Sprint Plan
| Sprint | Canvas | Slack |
|---|---|---|
| 1-2 | Prototype + core | — |
| 3-4 | V1 full flow | Trigger + root cause + action buttons |
| 5-6 | Memory, agents, proactive | Morning brief, commands, @-mentions |
| 7-8 | Polish, collab, reports | Settings, advanced config |
