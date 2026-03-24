# SRE Agent UX Comparison: Datadog vs Dynatrace vs New Relic (Planned)

**Date:** March 2026
**Purpose:** Quick-reference competitive UX comparison for Investigation Canvas design decisions
**Detailed teardowns:** See `datadog-bits-ai-sre-ux-teardown-2026-03.md` and `dynatrace-sre-agent-ux-teardown-2026-03.md`

---

## Layout & Navigation

| Dimension | Datadog Bits AI SRE | Dynatrace SRE Agent | NR Investigation Canvas (Planned) |
|---|---|---|---|
| **Primary surface** | Dedicated page: `/bits-ai/investigations/{id}` | Distributed across existing views (Problems, Services, K8s) | Dedicated page: `/ai/investigations/{id}` |
| **Page layout** | Split-pane: chat (left 45%) + tree (right 55%) | No dedicated layout (uses existing product views + Smartscape) | Split-pane: reasoning (left 55-60%) + evidence (right 40-45%) |
| **Nav placement** | "Bits AI" top-level sidebar item | Problems app + Dynatrace Hub | "AI Agents" top-level nav with sub-pages |
| **Chat** | Primary interaction (left panel, always visible) | Dynatrace Assist (in-context, supplementary) | Bottom bar input + inline in reasoning stream |

## Investigation Model

| Dimension | Datadog | Dynatrace | NR (Planned) |
|---|---|---|---|
| **AI approach** | Hypothesis-based (LLM generates and validates) | Deterministic (causal AI identifies root cause directly) | Hybrid (evidence-based with transparent hypothesis testing) |
| **Visualization** | Vertical tree/flowchart (nodes + arrows) | Smartscape topology graph (interactive dependency map) | Live streaming canvas with hypothesis cards + evidence widgets |
| **Transparency** | Tree shows steps post-completion | Causal chain in problem card | Live reasoning stream (real-time, watchable) |
| **Process** | Runbook check -> Memory -> General Search -> Initial Finding -> Hypotheses -> Conclusion | Auto-detection -> Causal analysis -> Dependency mapping -> Recommended actions | Context -> Knowledge check -> Initial findings -> Hypothesis cards -> Evidence -> Conclusion |

## Investigation Trigger & Status

| Dimension | Datadog | Dynatrace | NR (Planned) |
|---|---|---|---|
| **Auto-trigger** | Per-monitor toggle | Always on (Davis AI detects automatically) | Per-monitor toggle + auto-investigate config |
| **Manual trigger** | From monitor page or Bits AI nav | From Problems app or Assist | 7 entry points (alert, APM, Slack, prompt, brief, list, graph selection) |
| **Status badges** | Investigating / Conclusive / Inconclusive | Problem status (Open / Resolved) | Investigating / Conclusive / Inconclusive + elapsed time |
| **Timing display** | "Completed in 2m" / "Finished 5m ago" | Problem duration | Live elapsed time + progress indicators |
| **Simultaneous** | Multiple investigations in parallel | Multiple problems tracked automatically | Background investigation with notifications |

## Evidence & Data Display

| Dimension | Datadog | Dynatrace | NR (Planned) |
|---|---|---|---|
| **Metrics** | Small chart in alert card only | Full Grail analytics views | Interactive golden signals charts (zoomable, clickable) |
| **Traces** | Links to APM trace view (separate page) | Grail stack traces in problem card | Inline flame graph widget (interactive) |
| **Logs** | Text references in chat | Log analytics in platform | Syntax-highlighted log snippets with severity coloring |
| **Deployments** | Mentioned in text | Change events correlated | Timeline widget with deploy markers + diff links |
| **Entity map** | Not in investigation | Smartscape topology (interactive) | Entity relationship map with affected nodes |
| **Evidence interactivity** | Static (text + links to other pages) | Interactive (within platform views) | Interactive widgets (click to drill, open in product) |

## Human Interaction

| Dimension | Datadog | Dynatrace | NR (Planned) |
|---|---|---|---|
| **Steering** | Free-text chat only (no structured controls) | Not available during investigation | Skip, Prioritize, Challenge, Redirect (structured buttons + chat) |
| **Feedback** | Binary: "Yes" / "Not Quite" (banner) | Not explicitly visible | Three-button: Correct / Partially Right / Wrong + text input + quality rating |
| **Follow-up** | Clickable suggested questions in chat | Dynatrace Assist natural language | Suggested prompts (contextual, change by phase) + @-mention agents |
| **Code suggestions** | Code blocks in chat (copyable) | Fix suggestions via Developer Agent | Copyable commands in remediation cards + one-click execute |

## Actions & Remediation

| Dimension | Datadog | Dynatrace | NR (Planned) |
|---|---|---|---|
| **Execution** | Suggests only (code in chat) | Agentic Workflows can execute (with approval) | Risk-tiered: auto (low) / confirm (medium) / full assessment (high) |
| **Create incident** | "Run Action" button (sometimes fails) | Auto-enriches tickets in ServiceNow/Jira | One-click with pre-filled details |
| **Rollback** | Not available | Via agentic workflows | One-click with impact assessment + live recovery chart |
| **Page team** | Via chat action | Via ecosystem (PagerDuty/ServiceNow) | Direct button in action bar |
| **Post-mortem** | Not available | Not available | One-click auto-generated post-mortem |
| **Prevention** | Not available | Not available | Prevention recommendations (alerts, instrumentation, deploy guards) |

## Memory & Knowledge

| Dimension | Datadog | Dynatrace | NR (Planned) |
|---|---|---|---|
| **Memory system** | Recalls past investigations (visible in tree) | No explicit memory system | Visual memory dashboard + per-agent memory |
| **Runbook integration** | Alert body + embedded links | Not explicitly featured | Upload, link (Confluence/Notion/GitHub/PagerDuty), extracted knowledge preview |
| **Onboarding** | bits.md markdown file | OneAgent auto-maps dependencies | Visual wizard (4 steps: architecture, runbooks, patterns, preferences) |
| **Known patterns** | Implicit (memory) | Davis AI baseline learning | Explicit known noise patterns with toggle and match count |

## Proactive & Ambient

| Dimension | Datadog | Dynatrace | NR (Planned) |
|---|---|---|---|
| **Morning brief** | None | None | Full daily digest (needs attention / auto-resolved / health summary) |
| **Proactive detection** | Auto-investigate on alert | Davis AI anomaly detection (always on) | Memory leak detection, capacity trends, anomaly flagging |
| **Alert coverage gaps** | None | None | Coverage report with one-click alert creation |
| **Auto-resolve** | Investigation runs, but no "auto-resolved" summary | Problem auto-closes when resolved | Auto-resolve with pattern matching + morning brief summary |

## Multi-Agent & Ecosystem

| Dimension | Datadog | Dynatrace | NR (Planned) |
|---|---|---|---|
| **Internal agents** | Single Bits AI SRE only | Three: SRE + Developer + Security | SRE Agent + DB Agent + K8s Agent + Deploy Agent (visible handoffs) |
| **Agent visibility** | Single agent (no roster) | Not visible as "agents" in UI | Agent roster bar with status, handoff cards, swim lane timeline |
| **External integrations** | Slack, Jira, GitHub, ServiceNow (within Bits AI) | Azure SRE, AWS Kiro, GitHub Copilot, ServiceNow Assist, Atlassian Rovo (bidirectional) | Via MCP: PagerDuty, Jira, Slack as first-class canvas participants |
| **MCP Server** | Not public (internal "MCP Tools") | Published in GitHub MCP Registry (Oct 2025) | Planned |
| **Collaboration** | Single-user only | Not applicable | Multi-user with presence indicators + comments |

## Reporting & Analytics

| Dimension | Datadog | Dynatrace | NR (Planned) |
|---|---|---|---|
| **Investigation history** | Investigation list page | Problems list (existing) | Investigation list with filters, search, tags, comparison mode |
| **Effectiveness metrics** | Investigation count only | Not visible | Full dashboard: accuracy, MTTR trends, auto-resolution rate, agent usage |
| **Recurring patterns** | Not available | Not available | Recurring pattern card with prevention tracking |
| **Business impact** | Not available | Not available | Revenue impact widget (Pathpoint integration) |

## Pricing Model

| Dimension | Datadog | Dynatrace | NR (Planned) |
|---|---|---|---|
| **AI pricing** | Separate SKU: $500/mo for 20 investigations (~$25 each) | Complex seat/host + agentic add-ons | Consumption-based (no separate AI SKU) |
| **Billing unit** | Per conclusive investigation | Per-host/seat | Per platform usage |
| **Scalability cost** | 100 alerts/mo = ~$30K/year | Enterprise pricing (contact sales) | Included in consumption |

---

## The Gaps Only NR Can Fill

These are features neither Datadog nor Dynatrace offers. They represent clear differentiation for the Investigation Canvas:

1. **Live streaming reasoning** (watch the agent think in real-time, not post-hoc)
2. **Human steering** (skip, prioritize, challenge, redirect hypotheses)
3. **Prevention recommendations** (Detect -> Diagnose -> Fix -> **Prevent**)
4. **Morning brief** (proactive daily digest)
5. **Post-mortem auto-generation** (one-click from investigation)
6. **Business impact widget** (revenue correlation via Pathpoint)
7. **Alert coverage gaps** (proactive gap detection + one-click fix)
8. **Recurring pattern detection** (with prevention action tracking)
9. **Multi-agent visible collaboration** (agent roster, handoff cards, swim lanes)
10. **Granular feedback** (three-level + text input, not just binary)
11. **Visual memory management dashboard** (transparent, editable)
12. **Investigation comparison mode** (side-by-side for pattern recognition)
13. **Consumption pricing for AI** (no separate SKU)
14. **Interactive evidence widgets** (charts, flame graphs, not text descriptions)
