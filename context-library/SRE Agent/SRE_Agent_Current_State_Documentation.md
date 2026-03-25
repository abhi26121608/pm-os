# SRE Agent Current State Documentation
## Comprehensive Analysis for UX Reimagining Initiative

**Document Purpose**: This document consolidates all available information about the SRE Agent to inform the product roadmap for moving the SRE Agent OUT of the current chat-based interface.

**Last Updated**: March 25, 2026

---

## Table of Contents
1. [Executive Summary](#executive-summary)
2. [Strategic Vision](#strategic-vision)
3. [Product Overview](#product-overview)
4. [Architecture & Components](#architecture--components)
5. [Current User Experience](#current-user-experience)
6. [V2 Technical Improvements](#v2-technical-improvements)
7. [Performance Metrics](#performance-metrics)
8. [Known Issues & Fixes](#known-issues--fixes)
9. [Production Readiness Status](#production-readiness-status)
10. [Feature Flags](#feature-flags)
11. [GA Blockers & Post-GA Items](#ga-blockers--post-ga-items)
12. [Competitive Landscape](#competitive-landscape)
13. [SRE Workflow Analysis](#sre-workflow-analysis)
14. [UX Design Principles](#ux-design-principles)
15. [Differentiation Opportunities](#differentiation-opportunities)
16. [UX Implications for Redesign](#ux-implications-for-redesign)

---

## Executive Summary

The SRE Agent is New Relic's AI-powered assistant designed to help Site Reliability Engineers with proactive triage and change validation. Currently deployed as a chat-based interface within the New Relic platform, the product is undergoing significant V2 improvements focused on reliability, performance, and user experience.

**Key Metrics (as of January 2026)**:
- Average response time: ~1.5 minutes
- Token consumption: ~650K tokens per request
- Plan validation first-try approval: Improved from ~50% to 99%
- Change failure rate: ~66% (target: <30%)

**Strategic Context**: The initiative aims to reimagine the UX to move away from the chat-based paradigm, leveraging task-based workflows, guided inputs, and structured outputs.

---

## Strategic Vision

### Leadership Direction (from Camden/Engineering Leadership)

Based on internal discussions, the strategic direction for SRE Agent UX is clear:

> "I would almost prefer if we just took a completely blank slate... forget about OneCore components, forget about UI platform. What does this look like if we're thinking about it from scratch?"

#### Core Principles from Leadership

1. **Move Away from Chat**: "We don't have to use the chat panel. It could be a completely new page that you design from scratch."

2. **Generative User Experience**: Create a "generative user experience that blurs the boundaries between New Relic and other platforms" - this means the interface itself adapts and generates based on the investigation context.

3. **Two Steel Thread User Journeys**: Focus on designing complete end-to-end experiences for:
   - **Alert Triage**: From alert notification to resolution
   - **Deployment Validation**: From deploy event to confidence signal

4. **Multi-Agent Collaboration Vision**: Future state includes multiple specialized agents that can work together, with the user orchestrating rather than just conversing.

5. **"Teach the Agent" Experience**: Users should be able to:
   - Feed runbooks and post-mortems to the agent
   - Describe their architecture and dependencies
   - Train the agent on their specific environment

### Current UX Problems Identified

From design discussions:

1. **Responses are "extremely text-heavy"** - current output doesn't use platform visual components
2. **No visual hierarchy** - everything presented as chat messages
3. **Limited interactivity** - users can't drill down or explore

### Proposed Evolution Path

| Version | Focus | UX Approach |
|---------|-------|-------------|
| **V0** | Make current output more visual | Use existing platform components (charts, tables, entity cards) within responses |
| **V1** | Grid-based generative UX | Dynamic canvas where components are placed contextually based on investigation |
| **V2+** | Full generative interface | Human and AI co-author the investigation space together |

---

## Product Overview

### Vision
AI SRE Agent: Proactive Triage & Change Validation (MVP)
- **Initiative**: NR-485619
- **Goal**: Provide automated incident analysis, root cause identification, and change impact validation

### Core Capabilities
1. **Alert Triage**: Automatic analysis when alerts trigger
2. **Change Validation**: Deployment impact analysis
3. **Root Cause Analysis**: Correlating signals across telemetry
4. **Guided Remediation**: Suggested actions based on analysis

### Target Users
- Site Reliability Engineers (SREs)
- DevOps Engineers
- On-call responders

---

## Architecture & Components

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Alert Notification                          │
│              (Webhook to NRAI Synapse Endpoint)                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Synapse (Gateway)                            │
│         - Request routing                                       │
│         - Security (HTML tag filtering)                         │
│         - respond_async: true (15-sec timeout workaround)       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              SRE Agent Orchestration Service                    │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Pre-         │  │ Planning     │  │ Plan         │         │
│  │ Validation   │──▶ Agent        │──▶ Validation   │         │
│  │ Node         │  │              │  │ (Critic)     │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│         │                                    │                  │
│         │         Context Reducers           │                  │
│         └────────────────────────────────────┘                  │
│                                                                 │
│  Sub-Agents:                                                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Entity       │  │ Analysis     │  │ Deployment   │         │
│  │ Lookup       │  │ Agent        │  │ Agent        │         │
│  │ Agent        │  │              │  │              │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    MCP Server                                   │
│         (Model Context Protocol - Tool Exposure)                │
│                                                                 │
│  Available Tools:                                               │
│  - Entity lookup, NRQL queries, Log analysis                   │
│  - Golden metrics, Deployment analysis                          │
│  - Alert conditions, Kafka metrics                              │
│  - Transaction analysis, Thread analysis                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                 New Relic Platform APIs                         │
│         (NerdGraph, NRQL, Entity API, etc.)                    │
└─────────────────────────────────────────────────────────────────┘
```

### Component Details

#### 1. Synapse (Gateway Layer)
- Routes requests to appropriate services
- Security filtering (HTML tags rejection)
- Handles async responses for notification timeout workaround

#### 2. SRE Agent Orchestration Service
- **GitHub**: sre-orchestration-service
- **Technology**: LangGraph-based workflow orchestration
- **Key Features**:
  - Semantic routing for pre-approved plans
  - Context reducers for state management
  - Structured outputs (JSON/Markdown)

#### 3. MCP Server
- Exposes tools via Model Context Protocol
- Deterministic tool parameter validation
- Entity GUID validation utilities

#### 4. Sub-Agents
| Agent | Purpose | Token Tracking |
|-------|---------|----------------|
| Entity Lookup Agent | Find and validate entities | ✓ |
| Analysis Agent | Perform telemetry analysis | ✓ |
| Deployment Agent | Change impact analysis | ✓ |
| Critic Agent | Validate generated plans | ✓ |

### LangGraph Workflow

```
User Query
    │
    ▼
┌─────────────────┐
│ Pre-Validation  │ ── Vague query? ──▶ Request clarification
│ Node            │
└─────────────────┘
    │
    ▼
┌─────────────────┐
│ Planning Agent  │ ── Uses context reducers
└─────────────────┘
    │
    ▼
┌─────────────────┐
│ Plan Validation │ ── Deterministic validation
│ (Critic)        │    (99% first-try approval)
└─────────────────┘
    │
    ▼
┌─────────────────┐
│ Execution       │ ── Sub-agents execute steps
└─────────────────┘
    │
    ▼
┌─────────────────┐
│ Response        │ ── Structured output
│ Generation      │    (JSON + Markdown)
└─────────────────┘
```

---

## Current User Experience

### Entry Points

1. **Manual Chat Interface**
   - User navigates to SRE Agent
   - Types natural language query
   - Receives analysis results

2. **Alert-Triggered Analysis** (V2)
   - Alert policy configured with "Enable AI SRE" checkbox
   - Notification destination: Webhook to NRAI Synapse endpoint
   - Automatic analysis triggered on alert

### UI Components

1. **Chat Interface**
   - Natural language input
   - Streaming responses
   - Conversation history

2. **Reasoning Panel** (Collapsible)
   - Shows planning steps
   - Displays tool calls
   - Transparency into AI decision-making

3. **Context Card** (Editable)
   - User can modify analysis context
   - Feature flag: `editable_context_card`

4. **Segmented Responses**
   - Breaking long responses into segments
   - Feature flag: `sre_agent_segment_response`

### Current Limitations

1. **Chat-Based Paradigm**
   - Requires natural language formulation
   - No guided workflows
   - Steep learning curve for new users

2. **Response Time**
   - ~1.5 minutes average
   - No progress indicators during analysis

3. **Token Consumption**
   - ~650K tokens per request
   - Cost implications at scale

---

## V2 Technical Improvements

### From January 14, 2026 Demo (Dinesh Papineni)

#### 1. Automatic Alert Analysis
- Alert notifications trigger SRE Agent automatically
- No manual intervention required
- Immediate triage on alert fire

#### 2. Reasoning Panel
- Collapsible panel showing AI reasoning
- Planning steps visibility
- Tool call transparency

#### 3. Structured Outputs
- Using GPT models for deterministic formatting
- JSON output for programmatic consumption
- Markdown for human readability

#### 4. Pre-Validation Node
- Detects vague or ambiguous queries
- Requests clarification before proceeding
- Prevents wasted analysis cycles

#### 5. Tool Parameter Validation
- Entity GUID validation utilities
- Time period validation
- Prevents hallucinated parameters

#### 6. AI Monitoring Integration
- Token consumption tracking per sub-agent
- Custom events for monitoring
- Sub-agent level granularity

#### 7. Client Connection Closing
- Detects when user closes browser
- Stops ongoing analysis
- Prevents token waste

### From January 22, 2026 Demo (Younghwan Jang, Dinesh Papineni)

#### 1. Alert Notification Setup V2
- Policy configuration with "Enable AI SRE" checkbox
- Webhook destination to NRAI Synapse
- Workaround for 15-second notification timeout

#### 2. Context Improvements
- Reducers for state management
- Context shared between planning steps
- Step outcome storage

#### 3. Plan Validation Improvements
- First-try approval: 50% → 99%
- Removed LLM-based validation (too pedantic)
- Deterministic validation rules

#### 4. Error Handling Framework
- ExpectedException vs UnexpectedException pattern
- Centralized exception handling
- 2000+ error groups being addressed

#### 5. HTML Tag Issue Fix
- Synapse rejects HTML tags for security
- Escaped tags not rendering properly
- Fixed with prompt updates + Python cleanup

---

## Performance Metrics

### Response Time
| Metric | Value | Notes |
|--------|-------|-------|
| Average Response | ~1.5 minutes | End-to-end analysis |
| Target | TBD | Needs benchmarking |

### Token Consumption
| Metric | Value | Notes |
|--------|-------|-------|
| Average per Request | ~650K tokens | Across all sub-agents |
| Entity Lookup | Tracked separately | Via AI Monitoring |
| Analysis Agent | Tracked separately | Via AI Monitoring |
| Deployment Agent | Tracked separately | Via AI Monitoring |

### Reliability
| Metric | Current | Target |
|--------|---------|--------|
| Change Failure Rate | ~66% | <30% |
| Plan First-Try Approval | 99% | Maintained |

---

## Known Issues & Fixes

### Resolved Issues

| Issue | Root Cause | Fix Applied |
|-------|------------|-------------|
| Plan rejection on first try (~50%) | LLM-based validator too pedantic (checking grammar) | Made validator deterministic with pre-validation |
| Context loss between steps | Steps not sharing state | Implemented reducers and step outcome storage |
| HTML tag rendering | Synapse rejects HTML, escaped tags not rendered | Prompt updates + Python cleanup layer |
| Entity GUID hallucination | LLM generating invalid GUIDs | Tool parameter validation utilities |
| Timestamp inconsistency | start_time_ms vs startMS naming | Standardized parameter naming |
| Redundant tool calls | Lack of context awareness | Context reducers sharing state |

### Outstanding Issues

| Issue | Status | Impact |
|-------|--------|--------|
| 15-second notification timeout | Workaround in place (respond_async: true) | "Failed" status shown despite success |
| 2000+ error groups in staging | Being addressed with centralized handling | Monitoring noise |
| Change failure rate ~66% | Under investigation | Below target (<30%) |
| Token limit errors | Ongoing | Bad request errors |

---

## Production Readiness Status

### SRE Agent Orchestrator (NR-508703)
**Status**: In Progress

| Category | Status | Notes |
|----------|--------|-------|
| Architecture Diagrams | ✓ Closed | Documented |
| Runbooks | ✓ Closed | Available |
| Test Plans | ✓ Closed | Manual test plan exists |
| E2E Testing | Open | Gap identified |
| SLOs | Open | Not defined |
| Entitlements & Capabilities | Open | NR-508725 - GA Blocker |
| Error Handling | In Progress | Framework implemented |

### MCP Server (NR-508808)
**Status**: Backlog

| Category | Status | Notes |
|----------|--------|-------|
| Architecture Diagrams | Open | Gap |
| E2E Testing | Open | Gap |
| Risk Matrix | Open | Gap |
| SLOs | Open | Gap |
| Security SLC Review | Open | Gap |

### Environment Details
- **Environment**: us-production
- **Account ID**: 6751398
- **Dependencies**: MIND - Agentic Platform, Workitem, Workflow Automation

---

## Feature Flags

| Flag | Purpose | Status |
|------|---------|--------|
| `agui_mode` | AGUI interface mode | Active |
| `bot_reasoning_card` | Show reasoning panel | Active |
| `editable_context_card` | Allow context editing | Active |
| `sre_agent_segment_response` | Segment long responses | Active |

---

## GA Blockers & Post-GA Items

### GA Blockers (sre_ga label)

| Ticket | Summary | Status | Assignee |
|--------|---------|--------|----------|
| NR-508725 | Entitlements & Capabilities | Open | TBD |
| NR-508750 | [Various items from JQL] | Open | TBD |

### Post-GA Items (non-sre_ga)

| Ticket | Summary | Status | Notes |
|--------|---------|--------|-------|
| NR-508839 | [Various items from JQL] | Open | Post-GA backlog |

### Untested/Unimplemented Behaviors (from Test Plan)

| Behavior | Status | Notes |
|----------|--------|-------|
| Load handling | Un-Architected | Needs architecture work |
| Billing integration | Untested | Revenue implications |
| Proactive alert evaluation | Unimplemented | Future capability |

---

## Competitive Landscape

### UX Archetypes in the Market

The AI SRE space has evolved four distinct UX patterns:

| Archetype | Description | Examples | Pros | Cons |
|-----------|-------------|----------|------|------|
| **Chat-Native** | Dedicated chat interface as primary surface | Datadog Bits AI, Current NR SRE Agent | Flexible queries, familiar UX | Requires prompt engineering, context switching |
| **Sidebar Copilot** | AI assistance embedded alongside existing views | GitHub Copilot, VS Code AI | Contextual, low friction | Limited screen real estate, can feel secondary |
| **Dashboard-Embedded** | AI insights woven into existing dashboards | Dynatrace Davis, Splunk AI | No context switch, immediate relevance | Less exploratory, harder to iterate |
| **Autonomous Background** | Runs independently, surfaces findings proactively | PagerDuty AIOps, BigPanda | Proactive, reduces noise | "Black box" trust issues, alert fatigue risk |

### The Autonomy Spectrum

**This is the most critical UX pattern.** Users need control over how much the AI does automatically:

```
[Notify Only] → [Recommend] → [Act with Approval] → [Act within Guardrails] → [Fully Autonomous]
     │              │                  │                      │                      │
   Alerts       Suggests           User clicks            Pre-approved           AI resolves
   shown        next steps         "Execute"              playbooks              automatically
```

**Key Insight**: No competitor has solved the user preference UI for this spectrum well. Most hardcode one level.

### Detailed Competitor Analysis

#### Datadog Bits AI (Primary Competitor)

**Approach**: Hypothesis-based investigation with LLM-generated hypotheses validated against telemetry.

**UX Signature Elements**:
- **Investigation Tree**: Vertical flowchart showing hypothesis → validation → outcome
- **Chat Interface**: Side panel with natural language queries
- **Case-Based Reasoning**: 75% success rate at matching past patterns
- **Execution Time**: ~2-4 minutes for complete investigation

**Screenshot Analysis** (from 77-screenshot teardown):

| Component | Description |
|-----------|-------------|
| Investigation Canvas | Full-page view with vertical flowchart |
| Hypothesis Cards | Each hypothesis shows status (exploring, validated, rejected) |
| Evidence Links | Click-through to actual APM/metrics views |
| Action Buttons | "Explain further", "Related issues", "Share" |
| Feedback Widget | Thumbs up/down on each hypothesis |

**What Datadog Does NOT Have**:
- ❌ Interactive evidence widgets (static links only)
- ❌ Human steering during investigation (can't redirect mid-stream)
- ❌ Morning brief / daily digest
- ❌ Prevention recommendations
- ❌ Auto-generated post-mortems
- ❌ Memory of previous investigations

**From Datadog Demo (48-minute walkthrough)**:
- "Treat it as a new team member, start training it, provide runbook"
- Limitations acknowledged: Can't SSH, can't check process status
- Presenter verdict: "It's doing a decent job... it's in the right direction"

#### Dynatrace Davis AI (Differentiated Competitor)

**Approach**: Deterministic AI using causal models, NOT hypothesis-based. Minimizes hallucination risk.

**Key Differentiators**:
- **Distributed UX**: No dedicated investigation page - AI insights embedded throughout platform
- **Three Domain Agents**: SRE + Developer + Security agents with different focus areas
- **Topology Awareness**: Uses real-time dependency graph for impact analysis
- **Broadest Ecosystem**: 50+ integrations (Azure, AWS, GitHub, ServiceNow, Atlassian, Slack, Teams)

**Trust-Building Pattern**:
- Shows causal chain, not probability
- "Davis determined root cause" vs "AI suggests root cause"
- Users report higher confidence in deterministic findings

#### PagerDuty AIOps

**Approach**: Alert noise reduction and intelligent routing, less focused on investigation UX.

**UX Elements**:
- Alert grouping and correlation
- ML-based urgency scoring
- Suggested responders
- Incident timeline view

**Gap**: Limited actual investigation capability - more about routing than solving.

#### Grafana Incident / IRM

**Approach**: Open-source incident management with AI augmentation.

**UX Elements**:
- Incident timeline with automatic correlation
- Runbook integration
- Post-incident reports
- Slack-native workflows

**Gap**: Less sophisticated AI - relies more on rules than LLM-based analysis.

#### incident.io

**Approach**: Modern incident management with narrative focus.

**UX Elements**:
- Slack-first workflow
- Automatic status page updates
- Post-incident review automation
- "Announce" button for stakeholder comms

**Gap**: Limited observability depth - assumes you're bringing data from elsewhere.

### Trust-Building Patterns (Industry Best Practices)

Research across competitors reveals five critical trust patterns:

| Pattern | Description | Who Does It Best |
|---------|-------------|------------------|
| **Source Citation** | Every claim links to underlying data | Datadog (every hypothesis shows evidence) |
| **Query Transparency** | Show the actual queries executed | Dynatrace (shows Davis query logic) |
| **Live Investigation View** | Real-time display of what AI is checking | Datadog (investigation tree updates live) |
| **Audit Logs** | Full history of AI actions | All enterprise vendors |
| **Intent Preview** | Show what AI will do before doing it | No one does this well yet |

### UX Maturity Model

| Level | Capability | Current State |
|-------|------------|---------------|
| **L1: Alert Relay** | Surfaces alerts with basic context | ✓ All vendors |
| **L2: Smart Triage** | Prioritizes and groups alerts | ✓ Most vendors |
| **L3: Co-Investigation** | AI assists human investigation | → Current NR target |
| **L4: Autonomous Resolution** | AI executes approved playbooks | Few vendors |
| **L5: Predictive Prevention** | AI prevents incidents before they occur | No one yet |

---

## SRE Workflow Analysis

### The 8-Phase Incident Lifecycle

Understanding where AI can help requires mapping the SRE workflow:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           INCIDENT LIFECYCLE                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. DETECT    2. TRIAGE    3. INVESTIGATE    4. DIAGNOSE                   │
│  ────────     ────────     ───────────────   ──────────                    │
│  Alert fires  Priority?    Gather signals    Root cause                    │
│               Scope?       Correlate data    hypothesis                    │
│               Who?         Timeline          Confirm                        │
│                                                                             │
│  5. MITIGATE    6. RESOLVE    7. COMMUNICATE    8. LEARN                   │
│  ──────────     ──────────    ───────────────   ─────────                  │
│  Stop bleeding  Fix root      Status updates    Post-mortem               │
│  (rollback?)    cause         Stakeholders      Prevent                    │
│                               Customer comms    recurrence                  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### SRE Pain Points (from industry research)

| Pain Point | Data | AI Opportunity |
|------------|------|----------------|
| Time spent on toil | 57% of SREs spend >50% on toil | Automate L1/L2 investigation |
| Alert fatigue | 33% report alert fatigue as top challenge | Smart grouping and prioritization |
| False positives | 73% cite false positive challenge | Contextual alert validation |
| Context gathering | Average 15-30 min to gather context | Pre-fetch and present relevant data |
| Correlation | "Hardest part of investigation" | Multi-signal analysis |
| Communication | Stakeholder updates during incident | Auto-generate status updates |
| Knowledge transfer | Tribal knowledge locked in heads | Capture and apply learnings |

### Mitigation-First Philosophy

**Key Insight from Research**: SREs prioritize stopping the bleeding over understanding root cause.

```
Traditional AI Focus:          SRE Reality:
─────────────────────         ─────────────
Detect → Diagnose → Fix       Detect → MITIGATE → Diagnose → Fix
                                        ↑
                              "Just make it stop hurting first"
```

**UX Implication**: AI should surface quick mitigation options (rollback, scale, disable feature flag) BEFORE diving deep into root cause analysis.

---

## UX Design Principles

### Emerging Best Practices from Research

1. **Progressive Disclosure of Complexity**
   - Start with summary, allow drill-down
   - Don't overwhelm with all data upfront
   - Let users choose their depth

2. **Bidirectional Feedback**
   - Users can rate AI outputs (not just thumbs up/down)
   - Ability to correct and train in-context
   - "This was actually caused by X" correction flow

3. **Context Persistence**
   - Remember previous investigations
   - Build knowledge graph over time
   - "Last time this happened, we..."

4. **Collaboration Affordances**
   - Easy handoff between AI and human
   - Multi-user investigation support
   - Share investigation state

5. **Graceful Degradation**
   - Clear communication when AI is uncertain
   - Fallback to manual tools when needed
   - Never block the user

### Visual Design Patterns

| Pattern | Use Case | Implementation |
|---------|----------|----------------|
| **Investigation Tree** | Show hypothesis progression | Vertical flowchart with collapsible nodes |
| **Evidence Cards** | Display supporting data | Interactive widgets with source links |
| **Timeline View** | Show temporal correlation | Horizontal timeline with event markers |
| **Topology Map** | Show service dependencies | Interactive graph with impact highlighting |
| **Status Banner** | Communicate AI state | Persistent header showing current phase |

---

## Differentiation Opportunities

### Market Gaps New Relic Can Own

Based on competitive research, NO ONE is doing these well:

#### 1. Dynamic Canvas ("GenUX")

**The Opportunity**: Create a co-authoring space where human and AI build understanding together.

**What This Means**:
- Not just AI responding to queries
- Not just pre-built dashboards
- A generative interface that adapts to the investigation
- User can drag, rearrange, add widgets
- AI suggests but human curates

**Why No One Has This**: Requires tight integration between generative AI and component system. New Relic's OneCore + AI investment makes this possible.

#### 2. Visible Memory & Learning

**The Opportunity**: Show users what the AI "remembers" and how it's learning.

**What This Means**:
- "I've seen this pattern 3 times before in your environment"
- Explicit memory management (delete, edit, confirm)
- Training status transparency

**Why No One Has This**: Most vendors hide the learning process. Users don't trust what they can't see.

#### 3. Prevention Loop

**The Opportunity**: Close the loop from incident to prevention.

**What This Means**:
- Auto-suggest alert conditions based on incident
- Propose architectural changes
- Track whether preventions were implemented

**Why No One Has This**: Requires deep platform integration. Point solutions can't do this.

#### 4. Morning Brief

**The Opportunity**: Proactive daily digest of system health.

**What This Means**:
- "Here's what happened overnight"
- "Here are emerging patterns to watch"
- "Here's what the AI learned yesterday"

**Why No One Has This**: Requires continuous background analysis. Most vendors are reactive.

#### 5. Post-Mortem Generation

**The Opportunity**: Auto-generate post-mortem documents from investigation data.

**What This Means**:
- Timeline auto-populated
- Root cause pre-filled
- Action items suggested
- Connect to ticket systems

**Why No One Has This Well**: Datadog has basic version but limited. This could be a complete feature.

### Positioning Against Competitors

| Competitor | Their Strength | Our Counter |
|------------|----------------|-------------|
| Datadog | Investigation tree visualization | Dynamic canvas that adapts (not static tree) |
| Dynatrace | Deterministic causal AI | Transparency + human steering when uncertain |
| PagerDuty | Alert management | Full-stack investigation (not just routing) |
| Grafana | Open ecosystem | Enterprise-grade AI with memory |

---

## UX Implications for Redesign

### Strategic Recommendations

Based on competitive analysis, leadership direction, and SRE workflow research:

#### 1. Move Beyond Chat to Dynamic Canvas

**Current**: Chat-based interface requiring natural language formulation
**Recommendation**: Create a generative investigation canvas

**Implementation Path**:
- V0: Enrich current responses with visual platform components
- V1: Grid-based layout where AI places relevant widgets
- V2: Full dynamic canvas where user and AI co-author

**Key Principle**: "The interface should adapt to the investigation, not force the investigation into a fixed interface."

#### 2. Design for Two Steel-Thread Journeys

**Alert Triage Journey**:
```
Alert fires → AI pre-fetches context → User sees summary →
One-click drill-down → Mitigation options → Resolution confirmation →
Auto-capture learnings
```

**Deployment Validation Journey**:
```
Deploy event detected → AI monitors golden signals →
Anomaly detected? → Compare to baseline →
Confidence score → Rollback recommendation if needed →
All-clear signal
```

#### 3. Implement the Autonomy Dial

Give users explicit control over AI autonomy level:
- **Settings-based**: User configures their preference
- **Context-based**: Different levels for different alert severities
- **Override-able**: Always allow human to take over

#### 4. Prioritize Visual Output Over Text

**Current**: "Extremely text-heavy" responses
**Recommendation**: Use OneCore components for rich output

| Information Type | Current | Recommended |
|------------------|---------|-------------|
| Entity health | Text description | Entity card with status |
| Metrics trend | Text description | Inline chart |
| Timeline | Text list | Visual timeline component |
| Topology impact | Text list | Service map with highlighting |
| Actions | Text list | Action buttons with intent preview |

#### 5. Build Trust Through Transparency

Implement the five trust patterns:
- ✓ Source citation (link every claim to data)
- ✓ Query transparency (show NRQL used)
- ✓ Live investigation view (real-time progress)
- ✓ Audit logs (full history)
- ✓ Intent preview (show before execute)

#### 6. Enable "Teach the Agent"

**The Opportunity**: Let users feed context to improve AI over time.

| Input Type | Mechanism | Value |
|------------|-----------|-------|
| Runbooks | Upload or link | AI knows remediation steps |
| Architecture docs | Describe dependencies | AI understands impact |
| Post-mortems | Feed past incidents | AI recognizes patterns |
| Corrections | "Actually it was X" | AI learns from mistakes |

### Key Questions for UX Research

#### User Behavior (Quantitative)
1. What percentage of users engage with the reasoning panel?
2. How do users currently discover the SRE Agent?
3. What are the most common query patterns?
4. How do users handle the ~1.5 minute wait time?
5. What's the ratio of alert-triggered vs. manual investigations?

#### User Needs (Qualitative)
6. What information do users most value in analysis results?
7. Where do users go AFTER SRE Agent? (Next action in workflow)
8. What's missing that makes users leave to other tools?
9. How do users currently share findings with teammates?
10. What would make users trust the AI more?

#### Competitive Intelligence
11. Are users comparing to Datadog/Dynatrace AI experiences?
12. What do users like about competitor approaches?

### Success Metrics for New UX

| Metric | Current Baseline | Target | Rationale |
|--------|------------------|--------|-----------|
| Time to first insight | ~1.5 min | <30 sec | Streaming + pre-fetch |
| Investigation completion rate | Unknown | >80% | Track if users complete journeys |
| Mitigation success rate | Unknown | >70% | Did AI recommendation help? |
| Repeat usage | Unknown | >3x/week per user | Stickiness indicator |
| Trust score | Unknown | >4/5 | Survey: "I trust this AI" |
| NPS for AI features | Unknown | >40 | Overall satisfaction |

### Design Constraints

| Constraint | Source | Implication |
|------------|--------|-------------|
| OneCore design system | Platform team | Must use existing components or request new |
| Bot card restrictions | Current implementation | Limited visual flexibility in V0 |
| Response time | Architecture | Need streaming + progressive display |
| Token costs | Business | Must optimize for efficiency |
| GA timeline | Business | V0 must be achievable in current cycle |

---

## Appendix

### A. Source Documents

#### Internal Documents
| Document | Type | Key Content |
|----------|------|-------------|
| NR-485619 | Jira Initiative | Top-level initiative |
| NR-508703 | Jira Feature | Orchestrator PRC |
| NR-508808 | Jira Feature | MCP Server PRC |
| PR #312 | GitHub PR | Orchestration service changes |
| Test Plan (4888690771) | Confluence | Manual test plan |
| MCP Server Tools | Confluence | Tool documentation |
| Runbooks | Confluence | Operational runbooks |
| Jan 14 Demo Transcript | VTT | V2 technical demo |
| Jan 22 Demo Transcript | VTT | Alert notification setup demo |

#### Strategic & Design Discussions
| Document | Type | Key Content |
|----------|------|-------------|
| Camden/Abhi Meeting Transcript | Meeting Notes | Strategic vision: "generative UX that blurs boundaries" |
| Camden/Madhan Meeting Transcript | Meeting Notes | V0/V1 approach, design constraints |
| SRE Agent Walkthrough | Documentation | Current capabilities and flow |

#### Competitive Research
| Document | Type | Key Content |
|----------|------|-------------|
| sre_agent_ux_research.md | Research | Comprehensive UX patterns across competitors |
| datadog-bits-ai-sre-ux-teardown-2026-03.md | Teardown | 77-screenshot analysis of Datadog Bits AI |
| dynatrace-sre-agent-ux-teardown-2026-03.md | Teardown | Dynatrace Davis AI UX analysis |
| observability_sre_agents_research.md | Research | Market landscape overview |
| sre_workflow_critical_questions.md | Research | SRE workflow and pain point analysis |
| BITS AI SRE Datadog Demo Transcripts.pdf | Demo | 48-minute Datadog demo analysis |

### B. Team Contacts

- **AEON Team**: Primary development team
- **MIND Team**: Agentic Platform dependency
- **Camden**: Design leadership and strategic direction
- **Madhan**: Design implementation

### C. Related Initiatives

- Workflow Automation integration
- AI Monitoring for token tracking
- Notification platform enhancements (dedicated agent destination)
- OneCore design system extensions for AI components

### D. Key Quotes for Reference

**From Camden (Strategic Direction)**:
> "I would almost prefer if we just took a completely blank slate... forget about OneCore components, forget about UI platform. What does this look like if we're thinking about it from scratch?"

> "We don't have to use the chat panel. It could be a completely new page."

> "Generative user experience that blurs the boundaries between New Relic and other platforms."

**From Competitive Research**:
> "The 'Autonomy Dial' is the most critical UX pattern - no competitor has solved the user preference UI for this spectrum well."

**From SRE Workflow Research**:
> "57% of SREs spend more than 50% of their time on toil"
> "Correlation is the hardest part of investigation"

**From Datadog Demo Presenter**:
> "Treat it as a new team member, start training it, provide runbook"
> "It's doing a decent job... it's in the right direction"

### E. Glossary

| Term | Definition |
|------|------------|
| Dynamic Canvas / GenUX | Generative interface that adapts based on investigation context |
| Investigation Tree | Vertical flowchart showing hypothesis progression (Datadog pattern) |
| Autonomy Spectrum | Range from "Notify Only" to "Fully Autonomous" AI actions |
| Steel Thread | Complete end-to-end user journey for a specific use case |
| OneCore | New Relic's design system and component library |
| MCP | Model Context Protocol - standard for exposing tools to AI |
| Deterministic AI | AI that uses causal models rather than probabilistic inference (Dynatrace approach) |
| Hypothesis-Based AI | AI that generates and validates hypotheses (Datadog approach) |

---

*This document was comprehensively updated on March 25, 2026 with competitive intelligence, strategic direction from leadership, and UX design recommendations.*
