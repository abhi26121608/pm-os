# Dynatrace SRE Agent: Complete UI/UX Teardown

**Date:** March 2026
**Sources:** Dynatrace Intelligence platform page, Perform 2026 announcements, blog posts (Jan 28, 2026): "Dynatrace Intelligence at the Core of Autonomous Operations" (Bernd Greifeneder, CTO), "Dynatrace Agentic Ecosystem" (Milan Steskal), Azure SRE Agent blog, AWS DevOps Agent blog, MCP Server blog, Dynatrace Assist blog
**Key difference from Datadog:** Dynatrace does NOT have a dedicated investigation page. The SRE Agent operates through existing platform views, agentic workflows, and ecosystem integrations.

---

## 1. Architecture: Distributed, Not Dedicated

Unlike Datadog's single `/bits-ai/investigations/` page, Dynatrace takes a fundamentally different approach:

- The SRE Agent is NOT a standalone investigation surface
- It operates through **Davis AI Problem Cards** (existing problem detection system)
- It surfaces results inside **existing Dynatrace views** (Problems, Services, Kubernetes, Infrastructure)
- It uses **Agentic Workflows** (configurable, extensible automation)
- It exposes a **natural language interface** (Dynatrace Assist)
- It connects to **external tools** via MCP Server and ecosystem integrations

This means there's no single "investigation canvas" to screenshot. The SRE Agent's UX is woven into the entire platform.

---

## 2. Dynatrace Intelligence: The Agentic Operations System

Announced at Perform 2026 (January 28, 2026). Rebrands and extends Davis AI.

### Marketecture (from blog diagrams)

```
┌──────────────────────────────────────────────────────────────┐
│               AGENTIC ECOSYSTEM                               │
│  Azure SRE Agent | AWS Kiro | GitHub Copilot | ServiceNow    │
│  Atlassian Rovo | Custom Agents via MCP                      │
├──────────────────────────────────────────────────────────────┤
│               DOMAIN-SPECIFIC AGENTS                          │
│  🔧 SRE Agent | 💻 Developer Agent | 🔒 Security Agent      │
│  + Assist Agents (NL interface) + Custom Agentic Workflows   │
├──────────────────────────────────────────────────────────────┤
│               FOUNDATIONAL AGENTS (Deterministic)             │
│  Root Cause Agent | Analytics Agent | Forecasting Agent       │
│  Operator Agent (orchestrates all above)                      │
├──────────────────────────────────────────────────────────────┤
│               DATA & CONTEXT FOUNDATION                       │
│  Grail (data lakehouse) | Smartscape (dependency graph)       │
│  Real-time topology | Schema-on-read | Exabyte scale          │
└──────────────────────────────────────────────────────────────┘
```

### Key Philosophy: "Answers, Not Guesses"

- **Deterministic AI** provides factual, causal root cause analysis (not LLM-generated hypotheses)
- **Agentic AI** then reasons over deterministic answers to take action
- This is fundamentally different from Datadog's hypothesis-based approach
- Minimizes hallucination risk by maximizing deterministic AI usage
- LLMs used for "common sense and learned expertise," not for core analysis

---

## 3. Davis AI Problem Cards (Primary Investigation Surface)

The existing "Problems" app in Dynatrace is where investigations surface.

### What a Problem Card Shows:
- **Auto-detected anomaly** (no manual trigger needed, deterministic detection)
- **Root cause identified automatically** via causal AI (not hypothesis-based)
- **Smartscape topology visualization**: real-time dependency graph showing affected services, infrastructure, and their connections
- **Impact radius**: which users, services, and infrastructure are affected
- **Timeline of events**: chronological view of what happened
- **Related signals**: logs, traces, metrics correlated to the problem
- **Entity relationships**: vertical and horizontal dependencies

### Smartscape Topology (enriched for SRE Agent)
- Real-time dependency graph of the entire environment
- Shows: business processes, teams, digital services, processes, infrastructure, risks
- Latest generation supports **custom entities** (business data types, ownership info, metadata)
- "Teams immediately know who to notify for fast, fact-based remediation"
- Visual: interactive graph with nodes and edges, clickable entities

### How SRE Agent Enriches Problem Cards:
- Auto-triggers agentic workflows when a problem is detected
- Adds recommended actions with deterministic explanations
- Auto-enriches tickets sent to ServiceNow/Jira with full context
- Can trigger automated fixes (with human approval gates)

---

## 4. Three Domain-Specific Agents

### SRE Agent
- **Primary function**: Stabilizes cloud/Kubernetes operations
- **Capabilities**:
  - Out-of-the-box anomaly detection that engages agentic workflows for K8s and other technologies
  - Produces clear, deterministic explanations and recommended actions
  - Auto-enriches tickets to eliminate manual triage
- **Use cases**: Infrastructure optimization, Kubernetes operations, cloud resource anomaly detection

### Developer Agent
- **Primary function**: Detect, diagnose, and recommend code-level fixes
- **Capabilities**:
  - Auto-detects anomalies and pinpoints root cause, enriched with Grail stack traces
  - Triggers agentic workflows to propose code-level fixes in context
  - Surfaces suggestions in the original problem diagnostics
- **Example**: Detects rising mobile app crashes, analyzes code paths, produces immediate fix suggestion

### Security Agent
- **Primary function**: Triage, prioritize, and initiate proactive remediation
- **Capabilities**:
  - Triage findings and score threats to focus on what matters
  - Auto-create vulnerability tickets and kick off remediation workflows
  - Provide full evidence/context for quick, confident action
- **Example**: Continuously monitors emerging threats, checks environment for related vulnerabilities

---

## 5. Dynatrace Assist (Natural Language Interface)

- In-context natural language querying across the entire platform
- "Ask, analyze, and act" without having to add context to prompts
- Evolved from "Davis CoPilot" (GA earlier in 2025)
- Appears as a conversational interface within Dynatrace views
- Provides guidance on potential next steps and drives action
- Platform-wide (not limited to SRE use cases)

### Assist Agents (new category)
- Simplify adoption and everyday use of Dynatrace
- Lower barrier to entry for teams new to the platform
- Natural language queries return structured results from Grail

---

## 6. Agentic Workflows (Configurable Automation)

### Where to Find
- Dynatrace Hub (marketplace for workflows and integrations)
- Searchable by: `agentic-sre`, `agentic-coding`, `agentic-security`

### What They Do
- Configurable, extensible automation pipelines
- Can be built by customers (not just pre-built)
- "Write the future: Create your own agentic workflows" (blog)
- Execute actions based on deterministic AI findings

### Workflow Categories (from product pages)
- Kubernetes operations
- Infrastructure optimization
- Vulnerability remediation
- Mobile app crash inspection
- Log pattern analysis
- Timeseries analysis
- Dashboard creation
- Anomaly and pattern analysis

### Human Approval Gates
- Configurable per workflow
- Three maturity levels:
  1. **Automated**: Pre-defined workflows execute automatically
  2. **Supervised Autonomous**: AI generates plans, acts after human approval
  3. **Fully Autonomous** (future): Acts independently, requests human input only when necessary

---

## 7. Ecosystem Integrations (Broadest in Market)

### Azure SRE Agent Integration
- **Blog**: "Boost cloud reliability: Dynatrace and Azure SRE Agent unite for autonomous operations" (Nov 2025)
- **UX**: When issue emerges in Azure, Azure SRE Agent surfaces Dynatrace intelligence:
  - Causal root cause analysis
  - Dependency graphs
  - Impact radius
  - Service health
  - Cloud resource anomalies
- Evaluates situation, proposes remediation, triggers automated fixes when approved
- "A new benchmark for cloud operations"

### AWS DevOps Agent Integration
- Similar to Azure. Dynatrace and AWS DevOps Agent work together to analyze and mitigate problems.
- Video demo available showing the collaboration flow
- Real-time observability data powers AI-accelerated development

### GitHub Copilot (via MCP Server)
- **Blog**: "Sky high developer productivity with Dynatrace MCP and GitHub Copilot"
- **UX**: Brings real-time production insight (logs, traces, root cause, security context) directly into VS Code
- Copilot retrieves Dynatrace intelligence through natural language prompts
- Developers diagnose issues, validate vulnerabilities, verify builds without leaving IDE
- Dynatrace assesses query patterns and suggests fixes inline

### AWS Kiro
- **Blog**: "Real-time insights: Leverage Dynatrace observability capabilities within Amazon Kiro"
- **UX**: Developers access Dynatrace insights from within Kiro terminal
- Natural language prompts retrieve live metrics, logs, traces, problem context, topology
- Eliminates context switching

### ServiceNow Assist
- Bidirectional collaboration for ITSM workflows
- Dynatrace auto-detects problems, ties to causal root, maps dependencies
- Context surfaced directly in Service Manager
- Engineers see what's happening, who's affected, actions needed
- No tool switching required

### Atlassian Rovo Ops
- **Blog**: "Dynatrace and Atlassian delivering agentic AI that transforms your end-to-end incident management"
- Real-time production insights directly into Jira Service Management
- Can perform contextual analytics with follow-up questions within Jira

### MCP Server (Foundation)
- **Blog**: "Dynatrace MCP Server: Empower your AI assistants to interact with Dynatrace and access live production insights" (Jan 28, 2026, updated from Oct 2025)
- Listed in GitHub MCP Registry
- Provides connectivity + tools for interacting with Dynatrace Intelligence
- Automate tasks, triage problems, perform risk assessments, update business workflows
- Any MCP-compatible client can connect

---

## 8. Investigation UX Comparison: Dynatrace vs Datadog

| Dimension | Datadog Bits AI SRE | Dynatrace SRE Agent |
|---|---|---|
| **Primary surface** | Dedicated investigation page `/bits-ai/investigations/` | Distributed across existing views (Problems, Services, K8s) |
| **Investigation model** | Hypothesis-based (LLM generates + validates hypotheses) | Deterministic (causal AI identifies root cause directly) |
| **Visualization** | Vertical tree/flowchart (unique, central to UX) | Smartscape topology graph (interactive dependency graph) |
| **Chat interface** | Primary interaction (left panel, always visible) | Dynatrace Assist (in-context, supplementary) |
| **Actions** | "Run Action" / "Run Workflow" buttons in chat | Agentic Workflows (configurable automation pipelines) |
| **Auto-remediation** | Suggests only (code snippets in chat) | Can execute (agentic workflows with approval gates) |
| **Feedback mechanism** | Binary "Yes/Not Quite" banner | Not explicitly visible |
| **Memory system** | Recalls past investigations, visible in tree | No explicit memory dashboard |
| **Transparency** | Shows hypothesis validation tree after completion | Shows deterministic causal chain and dependency graph |
| **Error handling** | Honest about limitations in chat | Deterministic = fewer errors to handle |
| **Multi-agent** | Single agent only | Three agents (SRE + Developer + Security) |
| **Ecosystem** | Self-contained (Datadog data only, Slack/Jira/GitHub/ServiceNow) | Broadest (Azure, AWS, GitHub, ServiceNow, Atlassian, custom MCP) |
| **Trigger** | From monitor, manual, auto-investigate | Auto-detection via Davis AI (always on) |
| **Onboarding** | Monitor body + runbook + tagging | OneAgent + Smartscape auto-maps |
| **Pricing** | Separate SKU ($25-30/investigation) | Complex seat/host-based |
| **Analyst recognition** | Forrester AIOps Leader Q2 2025 | Gartner MQ Leader (highest on execution) |

---

## 9. Dynatrace's Maturity Journey (for Autonomous Operations)

| Stage | Description | Status |
|---|---|---|
| **Automated** | Pre-defined workflows execute automatically based on AI answers. Reactive + predictive operations. | Many orgs are here or striving for it |
| **Supervised Autonomous** | AI generates execution-ready action plans with reasoning. Acts after human oversight and approval. "Crawl-walk-run" approach. | Current Dynatrace focus |
| **Fully Autonomous** (future) | Dynatrace Intelligence acts independently to fulfill business goals. Requests human input only when necessary. Self-optimizes, ensures compliance. | Future vision |

**Key principles for supervised autonomous:**
1. **Reliability**: Rely on deterministic AI + analytics. Use generative AI for common sense.
2. **Transparency**: People set goals and guardrails. Validate reasoning. Review knowledge graphs.
3. **Feedback loop**: Accurate factual inputs create actionable plans. Real-time feedback refines execution.

---

## 10. What Dynatrace Does NOT Have (as of Mar 2026)

- No dedicated investigation canvas/page (distributed across views)
- No hypothesis visualization (deterministic, not hypothesis-based)
- No visible investigation tree/flowchart (uses Smartscape topology instead)
- No explicit memory management dashboard
- No morning brief / proactive daily digest
- No prevention recommendations (alert creation, instrumentation guidance)
- No business impact widget (revenue correlation)
- No post-mortem auto-generation
- No investigation comparison mode
- No "show your work" live streaming of reasoning
- No human steering during investigation (skip/prioritize hypotheses)
- No chat-first interface for investigations (Assist is supplementary)
- No per-investigation pricing transparency

---

## 11. Key Quotes

**Autodesk (customer)**:
> "It's observability that doesn't just detect problems, it understands them and acts on them reliably."

**TheCUBE Research / Smuget Consulting (analyst)**:
> "The real ROI in Dynatrace Intelligent Agents comes from precision, not prompts. Deterministic AI, unlike LLMs, reduces costs, increases trust, and enables supervised autonomy that enterprises can actually scale."

**Bernd Greifeneder (CTO)**:
> "Hallucinations aren't minor errors. They can trigger wrong actions leading to outages, security risks, and financial exposure. To make it worse, in agentic processing inaccuracies can accumulate and amplify."

**BCG (cited)**:
> "Organizations embedding AI agents into workflows achieve 30-50% faster processes, 40% reduction in low-value work."

---

## 12. Implications for New Relic's Investigation Canvas

### What to learn from Dynatrace:
- Deterministic AI as a foundation reduces hallucination risk (important for enterprise trust)
- Ecosystem breadth is a competitive moat (Azure, AWS, GitHub, ServiceNow, Atlassian)
- MCP Server listing in GitHub Registry is table stakes
- Three domain agents (SRE + Dev + Security) covers more use cases
- Agentic Workflows with human approval gates = production-ready automation

### Where NR Investigation Canvas can beat Dynatrace:
- **Dedicated investigation surface**: Dynatrace has no single "investigation canvas." NR's full-page canvas is more focused.
- **Live streaming reasoning**: Dynatrace shows results after the fact. NR can show reasoning happening live.
- **Human steering**: Dynatrace doesn't let users skip/prioritize/challenge. NR's HITL design is richer.
- **Prevention loop**: Neither competitor closes the Detect->Diagnose->Fix->Prevent loop. NR can be first.
- **Morning brief**: Neither has a proactive daily digest. NR can own this.
- **Post-mortem generation**: Neither auto-generates post-mortems. NR can own this.
- **Business impact**: Neither shows revenue impact. NR can differentiate via Pathpoint.
- **Consumption pricing**: Both competitors charge extra for AI. NR can include in consumption.
- **Memory management**: Neither has a visible memory dashboard. NR's design is more transparent.
