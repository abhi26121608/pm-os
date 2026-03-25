# PM Working Notes: Scope, Surfaces, and Constraints (H1 2026)

**Squad**: AI Agents - SRE Agent / Investigation Canvas
**Initiative**: NR-485619 (AI SRE Agent: Proactive Triage & Change Validation)

---

## 1. Our Scope (What We Actually Own)

Our squad owns the "AI-Assisted Investigation" layer. If it involves the agent investigating, reasoning, or taking action on incidents, it's ours.

### What We Own

**The Investigation Canvas**: The new generative UX we're building at `/ai/investigations/{id}`. Full-page experience with reasoning stream (left zone), evidence panel (right zone), chat input, and action buttons. This replaces the current chat-based interface.

**The Multi-Agent Orchestration System**: The SRE Agent is the orchestrator. We own:
- LangGraph-based workflow orchestration
- Sub-agents: Entity Lookup, Analysis Agent, Deployment Agent, Critic Agent
- Delegation to specialist agents (DB Agent, K8s Agent, Infra Agent)
- Agent handoff visualization in the UI
- MCP Server for tool exposure (entity lookup, NRQL queries, log analysis, golden metrics, deployment analysis)

**The Memory System**: Everything at `/ai/memory`:
- Learned patterns from investigation feedback
- Runbook linking and knowledge extraction
- Architecture context descriptions
- Known noise patterns (nightly batch jobs, etc.)
- Per-agent memory domains

**Pre-Action Interventions**: The approval flows before remediation:
- Risk-tiered actions (low/medium/high)
- Impact assessments for rollbacks
- "Approve/reject" UX
- Intent preview ("Here's what will happen if you approve")

**Morning Brief / Proactive Mode**: The `/ai/morning-brief` experience:
- Overnight system health summary
- Auto-resolved noise (matched known patterns)
- Proactive findings that need attention
- "Here's what the AI learned yesterday"

**Agent Configuration & Onboarding**: The `/ai/settings` pages:
- Auto-investigate rules per alert policy
- Integration connections (Slack, PagerDuty, Jira, GitHub via MCP)
- Rate limits (default: 20 auto-investigations/day)
- RBAC for action approvals
- First-time setup wizard

**Reports & Effectiveness**: The `/ai/reports` dashboard:
- Investigation volume, accuracy rates, MTTR trends
- Recurring issue detection
- Agent usage by type
- ROI proof ("65% reduction in MTTR")

---

## 2. Out of Scope (What We Do NOT Own)

We cannot solve problems by modifying the core observability platform.

**The Underlying Data Platform**: We consume APM, Infrastructure, Logs, Distributed Tracing, and NerdGraph APIs. We don't own how golden signals are calculated or how data is ingested.

**Alert/Incident Definition**: We don't own how customers define monitors, alert conditions, or notification channels. We trigger investigations from alerts, but the Alerts & AI team owns alert logic. Our "Enable AI SRE" checkbox on alert policies is a configuration touchpoint, not ownership.

**Synapse Gateway**: The gateway layer that routes requests, handles security (HTML tag filtering), and manages async responses. This is a dependency, not our codebase.

**The NR Homepage/Feed**: We're building a dedicated AI Agents section in the nav. We're not taking over the platform homepage. Our presence there is limited to notifications.

**Third-Party Tool Backends**: We integrate with PagerDuty, Jira, Slack, GitHub via MCP. If Jira's API is down, we surface the error gracefully. We don't own those systems.

**AI Monitoring/Token Tracking**: We emit custom events for token consumption per sub-agent, but the AI Monitoring platform that visualizes this is owned by another team.

---

## 3. Our Surfaces (Where the Agent Lives)

### Primary: Investigation Canvas (In-Platform)

Full-page experience at `/ai/investigations/{id}`. Three-zone layout:
- Header (60px): Status, title, agents, view toggle, actions
- Left zone (55-60%): Reasoning stream with phase cards
- Right zone (40-45%): Evidence widgets (charts, logs, traces)
- Bottom bar (80px): Chat input + quick actions

**Why Primary**: This is where the richness lives. Interactive hypothesis cards, native evidence widgets, multi-agent visualization, memory management. The canvas must feel alive during investigation - content streams in real-time.

**View Modes**:
- Canvas view (default): Visual, card-based, non-technical-friendly
- Trace view: Raw chronological log of every tool call and agent thought (power user mode)

### Secondary: Slack App

Extends existing New Relic Slack integration:
- Alert notification with "Investigate" button
- Investigation progress updates in thread
- Root cause summary with action buttons
- Morning brief delivery to configured channels
- Slash commands: `/nr-investigate`, `/nr-status`, `/nr-brief`

**Why Slack**: SREs are in Slack at 3 AM. Team collaboration happens there. Action approval on mobile works. Datadog has this - it's table stakes.

**What Slack Cannot Do**: Interactive charts, hypothesis steering, memory management, post-mortem editing. Everything rich goes back to canvas via `[View Full Investigation →]` links.

### 7 Entry Points

1. **Auto-triggered**: Monitor enters ALERT → investigation starts automatically (if "Enable AI SRE" is configured)
2. **From Alert/Issue Page**: Banner: "Investigate with SRE Agent" button
3. **From APM Service Page**: Click-drag anomalous region → "Investigate this anomaly"
4. **From Slack**: Reply "@NewRelic investigate this"
5. **Free-form Prompt**: Navigate to `/ai/investigations/new` and describe
6. **From Morning Brief**: Click "Investigate deeper" on a proactive finding
7. **From Investigation List**: Open any past or active investigation

### Post-GA Exploration (Not in Scope Now)

Chrome extension, dedicated mobile app, Microsoft Teams. We focus on two surfaces only.

---

## 4. Hard Technical Constraints (The "Reality Check")

Features that violate these constraints will fail in production.

### Response Time Budget

| Metric | Current | Target | Constraint |
|--------|---------|--------|------------|
| Average response | ~1.5 minutes | <30 sec to first insight | Streaming + pre-fetch |
| Full investigation | 2-4 minutes | Maintained | Users expect conclusions |

**Implication**: We need progressive disclosure. Show initial context and findings while hypotheses are still being tested. Users can't stare at a spinner for 3 minutes.

### Token Consumption & Compute Cost

| Metric | Current | Notes |
|--------|---------|-------|
| Tokens per request | ~650K | Across all sub-agents |
| Entity Lookup | Tracked separately | Via AI Monitoring |
| Analysis Agent | Tracked separately | Highest consumer |

**Implication**:
- Use expensive models (GPT-4) for synthesis/conclusions
- Use cheaper models for entity lookup, simple queries
- Cache tool results (don't re-query same NRQL twice)
- Rate limit auto-investigations (default: 20/day per account)

### Latency for Tool Calls

Each MCP tool call (NR APIs, PagerDuty, Jira) has latency. We can't chain 50 sequential tool calls.

**Implication**:
- Agent must parallelize where possible
- Evidence widgets show skeleton loaders while data fetches
- Show "Checking golden signals..." with tool name during execution

### Plan Validation

| Metric | Previous | Current |
|--------|----------|---------|
| First-try approval | ~50% | 99% |
| Approach | LLM-based (too pedantic) | Deterministic rules |

**Implication**: We removed LLM-based validation because it was rejecting valid plans for grammar issues. Don't reintroduce fuzziness here.

### Reliability Targets

| Metric | Current | Target |
|--------|---------|--------|
| Change failure rate | ~66% | <30% |
| Plan first-try approval | 99% | Maintained |

**Implication**: The 66% change failure rate is under investigation. This is a backend reliability issue, not a UX problem to solve.

### Enterprise Security Requirements

- All agent actions audit-logged (who approved what, when)
- RBAC controls who can approve high-risk actions
- Memory content isolated to customer's account (no cross-tenant leakage)
- Customers can disable specific agents or actions entirely
- Synapse rejects HTML tags for security (escaped tags cleaned in Python)

### Notification Timeout Workaround

Alert notifications have a 15-second timeout. Investigation takes minutes. Current workaround: `respond_async: true` in webhook config. User sees "failed" status in notification destination despite investigation succeeding.

**Implication**: UI must clearly show investigation is running even when notification shows "failed."

---

## 5. Current State Problems (Why We're Redesigning)

From leadership (Camden) and design discussions:

### The Chat Problem

> "I would almost prefer if we just took a completely blank slate... forget about OneCore components, forget about UI platform. What does this look like if we're thinking about it from scratch?"

**Current Issues**:
1. **Responses are "extremely text-heavy"** - not using platform visual components
2. **No visual hierarchy** - everything presented as chat messages
3. **Limited interactivity** - users can't drill down or explore
4. **Requires natural language formulation** - steep learning curve
5. **No progress indicators** - users stare at spinner for 1.5 minutes

### The Strategic Direction

> "We don't have to use the chat panel. It could be a completely new page."
> "Generative user experience that blurs the boundaries between New Relic and other platforms."

**Two Steel Thread Journeys** we're designing for:
1. **Alert Triage**: Alert → AI pre-fetches context → User sees summary → Mitigation options → Resolution → Capture learnings
2. **Deployment Validation**: Deploy event → AI monitors golden signals → Anomaly detected? → Confidence score → All-clear or rollback recommendation

---

## 6. Evolution Path (V0 → V1 → V2)

| Version | Focus | UX Approach |
|---------|-------|-------------|
| **V0** | Make current output visual | Use platform components (charts, tables, entity cards) within responses |
| **V1** | Grid-based generative UX | Dynamic canvas where AI places relevant widgets |
| **V2+** | Full generative interface | Human and AI co-author the investigation space together |

**V0 is LP/PP target.** V1 is GA. V2+ is post-GA.

---

## 7. Key Differentiators vs. Competition

### The Autonomy Dial (Critical Pattern)

No competitor has solved this well. Users need control:

```
[Notify Only] → [Recommend] → [Act with Approval] → [Act within Guardrails] → [Fully Autonomous]
```

We're designing explicit autonomy controls in settings.

### Competitive Positioning

| Us (Investigation Canvas) | Datadog Bits AI | Dynatrace Davis |
|---|---|---|
| Live streaming canvas | Post-completion tree | Distributed (embedded throughout) |
| Interactive hypothesis cards | Static tree nodes | Deterministic causal chains |
| Skip/prioritize/challenge | Read-only | Read-only |
| Native evidence widgets | Embedded images/links | Platform charts |
| Multi-agent with visible handoffs | Single hidden agent | Three domain agents |
| Visual memory dashboard | bits.md markdown file | Hidden learning |
| Risk-tiered action approvals | Chat commands | Workflow automation |
| One-click post-mortem | None | Basic |
| Morning brief | None | None |

### What Datadog Does NOT Have (Our Opportunities)

- ❌ Interactive evidence widgets (static links only)
- ❌ Human steering during investigation (can't redirect mid-stream)
- ❌ Morning brief / daily digest
- ❌ Prevention recommendations
- ❌ Auto-generated post-mortems
- ❌ Memory of previous investigations
- ❌ Intent preview before execution

### Trust-Building Patterns (Industry Best Practices)

| Pattern | Description | Our Implementation |
|---------|-------------|-------------------|
| Source Citation | Every claim links to data | Evidence widgets with "Open in APM →" |
| Query Transparency | Show actual queries | NRQL displayed in evidence panel |
| Live Investigation | Real-time progress | Streaming canvas with phase cards |
| Audit Logs | Full action history | All actions logged with user attribution |
| Intent Preview | Show before execute | Impact assessment for high-risk actions |

---

## 8. Information Gaps (What We Don't Know Yet)

### Critical Gaps (Must Fill Before Major UX Decisions)

| Gap | Status | Action Needed |
|-----|--------|---------------|
| **User Research** | 🔴 None | Conduct 5-10 user interviews |
| **Usage Analytics** | 🔴 None | Get dashboard access (DAU, retention, query patterns) |
| **Support Tickets** | 🔴 Unknown | Analyze SRE Agent complaints |

### Questions We Can't Answer Yet

1. Who is actually using this and how? (personas, journey maps)
2. What do users love/hate about current experience?
3. How do users handle the ~1.5 minute wait time?
4. What's the ratio of alert-triggered vs. manual investigations?
5. Do users engage with the reasoning panel?

### What We Have (Strong)

- ✅ Technical Architecture (Synapse, Orchestration, MCP, Sub-agents)
- ✅ Competitive Analysis (Datadog, Dynatrace, PagerDuty teardowns)
- ✅ Strategic Direction (Camden meetings, "generative UX" vision)
- ✅ Design Constraints (OneCore, V0/V1/V2 path)

---

## 9. Feature Flags

| Flag | Purpose | Status |
|------|---------|--------|
| `agui_mode` | AGUI interface mode | Active |
| `bot_reasoning_card` | Show reasoning panel | Active |
| `editable_context_card` | Allow context editing | Active |
| `sre_agent_segment_response` | Segment long responses | Active |

---

## 10. GA Blockers

| Category | Status | Notes |
|----------|--------|-------|
| Entitlements & Capabilities | Open | NR-508725 - GA Blocker |
| E2E Testing | Open | Gap identified |
| SLOs | Open | Not defined |
| MCP Server PRC | Backlog | Architecture, E2E, Security review pending |

---

## 11. What This Means for PRD Scope

When writing the PRD, remember:

1. **We own the AI layer, not the data layer.** Don't spec features requiring changes to core APM or Logs.

2. **Canvas is primary, Slack is secondary.** Rich features go to canvas. Slack gets summaries and approvals.

3. **Respect the time budget.** Investigations should feel fast. Stream results progressively. Show first insight in <30 seconds.

4. **Audit everything.** Enterprise customers will ask "who approved the rollback at 3 AM?" We must have the answer.

5. **Memory is our moat.** The more customers teach the agent, the better it gets. Design for memory creation at every interaction point.

6. **Beat Datadog on UX, not just features.** They have a working SRE agent. We need to be noticeably better at streaming, interactivity, and visualization.

7. **Mitigation before diagnosis.** SREs want to stop the bleeding first. Surface quick mitigation options (rollback, scale, disable feature flag) before diving into root cause.

8. **Fill user research gaps.** Before finalizing major UX decisions, we need actual user feedback. The competitive analysis is strong, but we're guessing about our own users.

---

## 12. Key Contacts & Dependencies

| Team | Dependency | Notes |
|------|------------|-------|
| AEON | Primary development | SRE Agent orchestration |
| MIND | Agentic Platform | Infrastructure dependency |
| Design (Madhan + Inez) | UX implementation | V0/V1 design execution |
| Camden | Design leadership | Strategic direction |
| Engineering (Manny + Team) | Backend | LangGraph, MCP Server |

---

*Source: PM Working Notes, H1 2026*
*Consolidated from: SRE_Agent_Current_State_Documentation.md, SRE_Agent_Information_Gaps_Analysis.md, internal design discussions*
