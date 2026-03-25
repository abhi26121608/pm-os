# PM Working Notes: Scope, Surfaces, and Constraints (H1 2026)

**Squad**: AI Agents - SRE Agent / Investigation Canvas

---

## 1. Our Scope (What We Actually Own)

Our squad owns the "AI-Assisted Investigation" layer. If it involves the agent investigating, reasoning, or taking action on incidents, it's ours.

**The Investigation Canvas**: The full-page experience at `/ai/investigations/{id}` where users watch the agent work. This includes the reasoning stream (left zone), evidence panel (right zone), chat input, and action buttons. This is our primary surface.

**The Multi-Agent Orchestration System**: The SRE Agent is the orchestrator. We own how it delegates to specialist agents (DB Agent, K8s Agent, Infra Agent, etc.) and how those findings render back to the user. This includes agent handoff visualization and the agent roster bar.

**The Memory System**: Everything at `/ai/memory`. Learned patterns, runbook linking, architecture context, known noise patterns. Each specialized agent has its own memory domain, plus shared memory across all agents.

**Pre-Action Interventions**: The approval flows before the agent executes remediation. Risk-tiered actions (low/medium/high), impact assessments, and the "approve/reject" UX for rollbacks, restarts, and incident creation.

**Morning Brief / Proactive Mode**: The `/ai/morning-brief` experience. This is the ambient, always-on mode where the agent works overnight, auto-resolves noise, and surfaces what needs human attention. Includes health summaries and proactive anomaly detection.

**Agent Configuration & Onboarding**: The `/ai/settings` pages. Auto-investigate rules, integration connections (Slack, PagerDuty, Jira), rate limits, RBAC for who can approve actions, and the first-time setup wizard.

**Reports & Effectiveness**: The `/ai/reports` dashboard showing investigation volume, accuracy rates, MTTR trends, and recurring issues. This is how we prove agent value.

---

## 2. Out of Scope (What We Do NOT Own)

We cannot solve problems by modifying the core observability platform.

**The Underlying Data Platform**: We do not own APM, Infrastructure, Logs, Distributed Tracing, or any of the core New Relic data collection and storage. We consume their APIs. If there's a bug in how golden signals are calculated, that's not our bug.

**Alert/Incident Definition**: We do not own how customers define monitors, alert conditions, or incident workflows. We trigger investigations from alerts, but we don't modify alert logic. That's the Alerts & AI team.

**The Feed/Home Experience**: We're building a dedicated AI Agents section in the nav. We're not trying to take over the NR homepage or feed. Our presence there is limited to notifications ("Investigation complete").

**Trust & Safety / Content Moderation**: We don't police what users ask the agent to do. If they want to investigate a service that doesn't exist, the agent will fail gracefully. We're not building content filters for user prompts.

**Third-Party Tool Backends**: We integrate with PagerDuty, Jira, Slack, GitHub via MCP. But we don't own those integrations' reliability. If Jira's API is down, we surface the error. We don't fix Jira.

---

## 3. Our Surfaces (Where the Agent Lives)

### Primary: Investigation Canvas (In-Platform)

Full-page experience at `/ai/investigations/{id}`. Split-pane layout with reasoning stream and evidence panel. This is where 80% of the experience happens.

**Why Primary**: This is where the richness lives. Interactive charts, flame graphs, hypothesis manipulation, multi-agent visualization, memory management. You can't do this in Slack.

### Secondary: Slack App

Alert notifications, investigation summaries, action approval buttons, morning brief delivery. Extends the existing New Relic Slack integration.

**Why Slack**: SREs are in Slack at 3 AM when alerts fire. Team collaboration happens there. Action approval on mobile works. Datadog has this, so it's table stakes.

**What Slack Cannot Do**: Interactive charts, hypothesis steering, memory management, post-mortem editing, agent handoff visualization. Everything rich goes back to the canvas via `[View Full Investigation →]` links.

### Post-GA Exploration: Chrome Extension, Mobile App, Teams

Not for LP/PP. We focus on two surfaces only.

---

## 4. Hard Technical Constraints (The "Reality Check")

This is critical for the PRD. Features that violate these constraints will fail in production.

**Investigation Time Budget (2-4 minutes typical)**: Users expect the agent to reach a conclusion within a few minutes. We cannot design flows that require 30+ minutes of agent reasoning. If the agent is stuck after 5 minutes, we show "Agent needs your help" and ask for human input.

**LLM Compute Cost**: Running frontier LLM inference on every agent reasoning step costs money. We have to be smart about:
- When to use expensive models (synthesis, conclusions) vs. cheaper models (entity lookup, simple queries)
- Caching tool results so we don't re-query the same data
- Rate limits on auto-investigations (default: 20/day per account)

**Latency for Tool Calls**: Each MCP tool call (NR APIs, PagerDuty, Jira) has latency. We can't chain 50 sequential tool calls. The agent must parallelize where possible. Evidence widgets must show skeleton loaders while data fetches.

**Enterprise Security Requirements**:
- All agent actions are audit-logged
- RBAC controls who can approve high-risk actions (rollbacks, restarts)
- Memory content stays within the customer's account (no cross-tenant leakage)
- Customers can disable specific agents or actions entirely

**Multi-Tenant Architecture**: The agent must work correctly across New Relic's multi-tenant platform. Entity GUIDs, account IDs, and access controls must be respected. Agent A cannot see Agent B's customer data.

**Streaming UX Requirements**: The canvas must feel "alive" during investigation. Content must stream in progressively, not load all at once after 3 minutes. This requires SSE/WebSocket architecture and careful frontend state management.

---

## 5. Entry Points (7 Ways Users Arrive)

1. **Auto-triggered**: Monitor enters ALERT state → investigation starts automatically (if configured)
2. **From Alert/Issue Page**: Banner at top: "Investigate with SRE Agent" button
3. **From APM Service Page**: Click-drag anomalous region on chart → "Investigate this anomaly"
4. **From Slack**: Reply to alert notification: "@NewRelic investigate this"
5. **Free-form Prompt**: Navigate to `/ai/investigations/new` and describe the issue
6. **From Morning Brief**: Click "Investigate deeper" on a proactive finding
7. **From Investigation List**: Open any past or active investigation

---

## 6. Key Differentiators vs. Competition

| Us (Investigation Canvas) | Datadog Bits AI SRE |
|---|---|
| Live streaming canvas | Post-completion tree |
| Interactive hypothesis cards (skip/prioritize) | Static tree nodes |
| Native evidence widgets (clickable charts) | Embedded images |
| Multi-agent with visible handoffs | Single hidden agent |
| Visual memory dashboard | bits.md markdown file |
| Risk-tiered action approvals | Chat commands only |
| One-click post-mortem generation | None |
| Morning brief with proactive detection | None |

---

## 7. What This Means for PRD Scope

When writing the PRD, remember:

1. **We own the AI layer, not the data layer.** Don't spec features that require changes to core APM or Logs.

2. **Canvas is primary, Slack is secondary.** Rich features go to canvas. Slack gets summaries and approvals.

3. **Respect the time budget.** Any feature that makes investigations take 10+ minutes needs serious justification.

4. **Audit everything.** Enterprise customers will ask "who approved the rollback at 3 AM?" We must have the answer.

5. **Memory is our moat.** The more customers teach the agent, the better it gets. Design for memory creation at every interaction point.

6. **Beat Datadog on UX, not just features.** They have a working SRE agent. We need to be noticeably better at the core experience (streaming, interactivity, visualization).

---

*Source: PM Working Notes, H1 2026*
