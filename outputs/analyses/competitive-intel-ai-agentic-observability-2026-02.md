# Competitive Intelligence Brief: AI/Agentic Observability
**Date:** February 19, 2026
**Audience:** New Relic PM team (SRE Agent + Agentic Integrations)
**Scope:** Datadog, Dynatrace, Splunk/Cisco, Elastic, Grafana
**Data quality note:** Datadog and Dynatrace sections are based on direct product page and blog content (high confidence). Elastic is based on their observability product page (medium-high). Splunk and Grafana sections are based on partial product page data and navigation structure (medium confidence). Recommend supplementing Splunk section with .conf26 announcements when available.

---

## Executive Summary

The observability market has entered an "agentic AI" arms race. Datadog and Dynatrace are the two competitors furthest ahead, and both have shipped production-ready autonomous SRE agents that directly compete with New Relic's planned SRE Agent. The competitive window is narrowing fast.

**Key takeaway:** Datadog's "Bits AI SRE" is already GA with customer testimonials claiming 70% MTTR reduction. Dynatrace has rebranded its entire platform around "Dynatrace Intelligence" with SRE, Developer, and Security agents, plus the broadest agentic ecosystem integrations (Azure SRE Agent, GitHub Copilot, ServiceNow, Atlassian Rovo, AWS Kiro). New Relic's differentiation opportunity lies in the consumption-based pricing model, open approach (NRDB/NRQL as an AI foundation), and the potential to be the most transparent/controllable agent for enterprises that don't trust black-box AI.

---

## 1. DATADOG

### What They've Shipped

**Bits AI SRE (GA, production)**
- Positioned as "your AI on-call teammate." Always-on autonomous SRE agent.
- Automatically investigates every alert the moment it fires.
- Delivers root causes within minutes, not hours.
- Suggests code fixes to speed up recovery.
- Learns from every investigation to improve accuracy over time.
- Explores multiple root cause hypotheses in parallel.
- Handles multiple alerts simultaneously, expanding on-call capacity.
- Analyzes millions of signals across the full stack in seconds.
- Customer quote (iFood): "From day one, Bits AI SRE started cutting our MTTR by 70%."
- Customer quote (Uber Freight): "Bits AI helps us cut through the noise by instantly surfacing the right context and correlations."
- Customer quote (Energisa): "Accurate root causes in under four minutes."
- Customer quote (Kyndryl): "Bits AI SRE has a potential to elevate the overall skill level of our entire engineering organization."
- Customer quote (Cordada): "Before Bits AI SRE, newer engineers lacked the mental model to navigate cross-service logs and identify the right traces and metrics. Now they begin with a head start."
- Enterprise controls: RBAC, zero-data retention with third-party AI providers, HIPAA compliance, flexible rate limits and cost controls.

**Bits AI Agents (broader platform)**
- "Bits AI Agents" is the umbrella brand for their agentic capabilities.
- Natural language interface across the Datadog platform.
- Tight integration with Incident Response, Workflow Automation, Case Management.

**Watchdog**
- Long-standing anomaly detection engine. Continuously analyzes billions of data points.
- Separates signal from noise, proactively surfaces latencies and errors.
- Now positioned as the foundation that powers Bits AI SRE's detection layer.

**LLM Observability (GA)**
- End-to-end tracing across AI agents: inputs, outputs, latency, token usage, errors at each step.
- Structured experiments: generate datasets from production traces, test prompt changes, swap models.
- Hallucination detection with out-of-the-box evaluation frameworks.
- Prompt-response cluster visualizations to identify quality drifts.
- Security: built-in scanners for data leaks, prompt injection detection.
- Correlated with APM and RUM for full-stack visibility.
- SDK for quick setup.

**AI Integrations**
- Dedicated "AI Integrations" category in their navigation (under "Agentic & Embedded").
- Monitoring for OpenAI, AWS Bedrock, and other AI service providers.
- OpenAI and SAP listed as named integration partners.

### Datadog Positioning/Messaging
- "Resolve issues faster with autonomous alert investigations built for complex environments."
- Heavy emphasis on "always-on," "at machine scale," "enterprise-grade control."
- DASH conference (June 9-10 2026, NYC) will likely be a major AI feature launch moment.
- They're framing this as "AI on-call" rather than "AI assistant," which implies full autonomy, not copilot.

### Datadog Strengths vs. New Relic
- **First-mover with real customers.** Multiple named enterprise customers (iFood, Uber Freight, Kyndryl, CAINZ, Energisa, Cellulant, Customaite, DelightRoom, Purchasing Power, Cordada) already using Bits AI SRE in production. Hard proof points.
- **Deep platform integration.** Bits AI SRE is woven into Incident Response, Workflow Automation, Event Management, and their entire data platform. Not a bolt-on.
- **LLM Observability is the most mature.** Structured experiments, hallucination detection, drift analysis. They're ahead on monitoring AI apps, not just using AI for observability.
- **Watchdog foundation.** Years of anomaly detection IP gives Bits AI SRE better signal quality from day one.
- **Enterprise trust signals.** HIPAA, zero-data retention, RBAC. They're already addressing the "can I trust this AI?" objection.

### Datadog Weaknesses / New Relic Opportunities
- **Pricing opacity.** Datadog's pricing is notoriously complex and expensive. Bits AI SRE adds another SKU on top. New Relic's consumption model could undercut significantly.
- **Vendor lock-in.** Bits AI SRE works best within the Datadog ecosystem. Customers with multi-vendor stacks may resist.
- **No clear agentic ecosystem play.** Unlike Dynatrace, Datadog hasn't announced deep partnerships with Azure SRE Agent, GitHub Copilot, ServiceNow, etc. Their agent is self-contained, not collaborative with external AI agents.
- **Black-box AI concerns.** "Learns from every investigation" sounds great, but enterprise SREs want to understand WHY the agent reached a conclusion. Transparency/explainability could be a differentiator for New Relic.
- **LLM Observability is a monitoring play, not an agentic integration play.** They monitor LLMs but don't deeply integrate with AI coding assistants or cloud provider agents.

---

## 2. DYNATRACE

### What They've Shipped

**Dynatrace Intelligence (rebranded platform, late 2025 / early 2026)**
- Complete rebrand from "Davis AI" to "Dynatrace Intelligence" as an "agentic operations system."
- Fuses deterministic AI (causal, topology-aware) with agentic AI (LLM-powered reasoning and action).
- Grail (unified data lakehouse) + Smartscape (real-time dependency graph) are the AI foundation.
- Key differentiator: "Answers, not guesses." Deterministic AI provides factual context that agentic AI then reasons over.
- Customer quote (Autodesk): "It's observability that doesn't just detect problems, it understands them and acts on them reliably."

**Three Domain-Specific Agents (shipped)**
1. **SRE Agent:** Stabilizes cloud/Kubernetes operations. Out-of-the-box anomaly detection that engages agentic workflows for K8s and other technologies. Produces clear, deterministic explanations and recommended actions. Auto-enriches tickets to eliminate manual triage.
2. **Developer Agent:** Auto-detects anomalies and pinpoints root cause enriched with Grail stack traces. Triggers agentic workflows to propose code-level fixes in context. Surfaces suggestions in original problem diagnostics.
3. **Security Agent:** Triages findings and scores threats to focus on what matters. Auto-creates vulnerability tickets and kicks off remediation workflows. Provides full evidence/context for quick, confident action.

**Dynatrace Assist (GA)**
- Natural language interface for exploring data across the platform.
- "Ask, analyze, and act" without needing to add context to prompts.
- Evolved from Davis CoPilot (GA earlier in 2025), now expanded platform-wide.

**Dynatrace MCP Server (shipped, listed in GitHub MCP Registry, Oct 2025+)**
- Enables AI coding assistants (GitHub Copilot, etc.) to interact with Dynatrace observability and security data directly from IDEs.
- Developers can troubleshoot, perform security checks, verify CI/CD builds, and create code using live production context without leaving their IDE.
- Blog published Oct 2025, updated Feb 2026, indicating active development.

**Agentic Ecosystem Integrations (broadest in the market)**
- **Azure SRE Agent:** Deep integration announced Nov 2025. Dynatrace provides AI-powered root cause analysis and real-time production insights to Azure SRE Agent. Joint autonomous incident remediation. Blog describes it as "a new benchmark for cloud operations."
- **AWS Kiro:** Real-time observability data powering AI-accelerated development.
- **GitHub Copilot:** Via Dynatrace MCP Server. Production observability data flows into Copilot suggestions.
- **ServiceNow Assist:** Bidirectional collaboration for ITSM workflows.
- **Atlassian Rovo Ops:** End-to-end incident management integration. Separate blog post on this partnership.
- Architecture: three-layer model (Grail/Smartscape foundation, MCP connectivity layer, agentic workflow layer).
- Blog (Jan 2026): "Whether it's invoking a coding agent, optimizing your cloud or Kubernetes infrastructure, or creating a ticket, Dynatrace Intelligence coordinates bi-directional interactions between agents."

**Agentic Workflows**
- Blog post "Write the future: Create your own agentic workflows" suggests a self-service workflow builder for custom agentic automation.
- "Remediation intelligence: Accelerate MTTR with AI-powered context and knowledge" blog suggests a knowledge-base approach to remediation.

**NVIDIA AI Factory Integration**
- "Unlocking productivity and trust: Dynatrace observability in NVIDIA AI Factory."
- Positioned for GPU/AI workload observability.

### Dynatrace Positioning/Messaging
- "The industry's first agentic operations system."
- "Action based on answers, not guesses." (deterministic + agentic AI)
- "Autonomous operations" is the North Star, with human oversight as the guardrail.
- BCG stat cited: "Organizations embedding AI agents into workflows achieve 30-50% faster processes, 40% reduction in low-value work."
- Analyst quote (TheCUBE/Smuget Consulting): "The real ROI in Dynatrace Intelligent Agents comes from precision, not prompts. Deterministic AI, unlike LLMs, reduces costs, increases trust, and enables supervised autonomy that enterprises can actually scale."

### Dynatrace Strengths vs. New Relic
- **Deterministic AI foundation.** Smartscape topology + Grail causal analysis gives their agents factual grounding that pure LLM approaches can't match. This is a trust advantage with enterprise buyers.
- **Broadest agentic ecosystem.** Azure SRE Agent, GitHub Copilot, ServiceNow, Atlassian, AWS Kiro. They're positioning as the "observability brain" that powers other vendors' agents. This is the most direct competition to New Relic's agentic integrations strategy.
- **Three domain-specific agents, not one.** SRE + Developer + Security covers more use cases than a single SRE agent.
- **Enterprise positioning.** "Supervised autonomy" messaging directly addresses CISO/CTO concerns about AI trust.
- **MCP Server is shipped and listed.** Already in the GitHub MCP Registry. Developers can use it today.
- **Active blog cadence on agentic topics.** 20+ blog posts on Davis AI/agentic topics visible. They're controlling the narrative.

### Dynatrace Weaknesses / New Relic Opportunities
- **Complexity and cost.** Dynatrace is the most expensive observability platform. Their "agentic operations system" adds cost layers. Mid-market teams can't afford this.
- **Closed ecosystem despite "ecosystem" messaging.** Dynatrace works best with Dynatrace data. Their deterministic AI advantage requires full OneAgent instrumentation. Organizations with heterogeneous tooling or OTel-first strategies don't get the full benefit.
- **Overpromising on autonomy.** "Autonomous operations" is aspirational for most enterprises. This could create expectation gaps and buyer hesitation.
- **Smartscape dependency.** The topology and causal AI advantages require deep OneAgent instrumentation. Customers using OTel or multi-vendor setups see degraded AI quality.
- **No clear consumption pricing.** Like Datadog, pricing is complex and seat/host-based. New Relic's pay-per-use model is simpler and more predictable.

---

## 3. SPLUNK / CISCO

### What They've Shipped

**Splunk AI Assistant**
- Natural language to SPL (Splunk Processing Language) translation.
- Helps users write and understand SPL queries without expertise.
- Positioned primarily for security (SIEM) use cases, not observability.

**IT Service Intelligence (ITSI) with AIOps**
- Predictive analytics, anomaly detection, event correlation.
- Service-level visibility and impact analysis.
- "Protect service performance with AIOps."
- This is traditional ML, not agentic AI. No autonomous agents.

**Splunk Observability Cloud**
- Standard observability platform (metrics, traces, logs).
- "Gain real-time visibility across any environment."
- No autonomous agent capabilities announced.

**AppDynamics (Cisco)**
- "Observe and secure hybrid and on-prem applications."
- Traditional APM. No significant agentic AI features visible.
- Cisco has been slow to integrate AppDynamics with their broader AI strategy.

**Cisco AI Strategy (broader, not Splunk-specific)**
- Cisco is investing heavily in AI for networking and security (Cisco AI Assistant for Security, Hypershield).
- Observability/Splunk side has not seen equivalent investment in agentic capabilities.
- Messaging: "Build digital resilience with Splunk AI" and "Maximize IT impact with AIOps."

### Splunk/Cisco Strengths vs. New Relic
- **Security/SIEM dominance.** If a customer's primary AI use case is security ops, Splunk is ahead.
- **Enterprise installed base.** Massive footprint in large enterprises, especially for log management.
- **Cisco distribution.** Cisco's sales channel can bundle observability into broader network/security deals.

### Splunk/Cisco Weaknesses / New Relic Opportunities
- **No agentic observability play.** No SRE agent, no autonomous remediation, no agentic integrations for observability. They're behind the entire field.
- **Fragmented portfolio.** Splunk + AppDynamics + Cisco ThousandEyes are separate products, not unified. No single AI brain across the portfolio.
- **Slow post-acquisition integration.** Cisco acquired Splunk in 2024, and integration is ongoing. AI innovation is being delayed by organizational complexity.
- **Pricing pain.** Splunk's ingest-based pricing is expensive and unpredictable.
- **This is a displacement opportunity.** Splunk customers who want AI-powered observability will need to look elsewhere. New Relic should target them aggressively with "your Splunk renewal is coming up" campaigns.

---

## 4. ELASTIC

### What They've Shipped

**AI Assistant for Observability (GA)**
- Agentic AI assistant that delivers root cause insights through natural language.
- Combined with zero-config ML that automatically surfaces issues.
- Positioned to help SREs "resolve problems faster without swivel chair analysis."
- Described as "agentic AI workflows" on their product page.

**Always-On AIOps (zero-config)**
- Anomaly detection, pattern analysis, automated correlation.
- "Instant dashboards" and "Significant Events" that auto-highlight features to watch.
- "Proven machine learning refined over a decade." Customers can use zero-config OOTB capabilities or customize with built-in or imported ML models.

**LLM Observability**
- Track latency, errors, prompts, responses, usage, and costs for major LLM services.
- "Remove blind spots for GenAI apps."

**AI-Driven Log Processing (Streams)**
- Automatically organizes data into logical streams with parsing, partitioning, field extraction, and lifecycle policies.
- "AI-driven auto-import for custom data."

**Search AI Platform (underlying)**
- Vector search and semantic search capabilities power their AI features.
- This is their structural differentiator: search-native AI.

### Elastic Positioning
- "Store more, spend less, and troubleshoot faster with agentic AI."
- "Use AI to get answers, not just alerts."
- "Fix problems in seconds, not hours."
- 2025 Gartner Magic Quadrant Leader for Observability Platforms.
- Heavy emphasis on open standards: "Stream native OTel without proprietary agents."
- Pricing message: "No pricing by ingest."

### Elastic Strengths vs. New Relic
- **Search-native AI.** Vector/semantic search foundation gives AI features a natural advantage for log analysis and pattern matching.
- **Open standards.** Native OTel, no proprietary agents. Appeals to teams that want flexibility.
- **Pricing simplicity.** Resource-based pricing without ingest caps.
- **Mature ML.** A decade of anomaly detection in production.

### Elastic Weaknesses / New Relic Opportunities
- **AI Assistant is conversational, not truly autonomous.** It helps you investigate but doesn't autonomously triage alerts, identify root cause, and remediate. It's an assistant, not an agent.
- **No dedicated SRE agent.** No autonomous alert response or automated remediation workflows at the agent level.
- **No agentic ecosystem.** No integrations with Azure SRE Agent, GitHub Copilot, AWS agents, etc.
- **Observability is secondary to search and security.** Elastic's primary business is Elasticsearch. Observability gets proportionally less R&D investment.
- **Self-hosted complexity.** Many Elastic deployments are self-managed, adding operational burden that competes for the same SRE attention the AI is supposed to save.

---

## 5. GRAFANA LABS

### What They've Shipped

**AI/ML Insights (Grafana Cloud)**
- Anomaly detection and pattern identification.
- "Contextual root cause analysis" and "automated anomaly correlation."
- Grafana Sift for automated investigation of metric anomalies.
- "3 active AI users" included in Grafana Cloud free tier (suggests AI features are being productized as a paid tier).

**Incident Response & Management (IRM)**
- Routine task automation for incidents.
- On-call management.
- AI features for incident summarization and correlation.

### Grafana Positioning
- "Monitor, analyze, and act faster with AI-powered observability."
- Open source first, vendor-neutral visualization layer.
- Not positioning as an "agentic" platform. No "agent" language in their product marketing.

### Grafana Strengths vs. New Relic
- **Open source community.** Massive adoption. Default visualization layer for many teams.
- **Vendor neutrality.** Works with any data source (including New Relic, Datadog, etc.).
- **Cost.** Generous free tier. OSS-first model.
- **Developer love.** Strong brand among developers and SREs.

### Grafana Weaknesses / New Relic Opportunities
- **No agentic AI.** No SRE agent, no autonomous remediation, no agentic integrations.
- **AI features are basic.** Anomaly detection and pattern matching, not autonomous investigation or action.
- **Visualization layer, not platform.** Grafana doesn't own the data layer for most customers, which limits what AI can do.
- **Not a competitive threat for agentic use cases.** Grafana is complementary, not competitive, in the AI agent space. Many teams will use Grafana for visualization alongside a platform like New Relic for the agentic layer.

---

## Competitive Matrix: Agentic AI Capabilities

| Capability | Datadog | Dynatrace | New Relic (planned) | Splunk/Cisco | Elastic | Grafana |
|---|---|---|---|---|---|---|
| **Autonomous SRE Agent** | Bits AI SRE (GA) | SRE Agent (GA) | SRE Agent (building) | None | None | None |
| **Auto alert triage** | Yes | Yes | Planned | ITSI (basic ML) | AI Assistant (manual) | Basic |
| **Auto root cause analysis** | Yes (parallel hypotheses) | Yes (deterministic + agentic) | Planned | ITSI (ML-based) | AI Assistant | Sift (basic) |
| **Auto remediation suggestions** | Code fix suggestions | Agentic workflows + ticket creation | Planned | None | None | None |
| **Azure SRE Agent integration** | Not announced | Yes (deep, Nov 2025) | Planned | None | None | None |
| **AWS agent integration** | Not announced | AWS Kiro (yes) | AWS DevOps Agent (planned) | None | None | None |
| **GitHub Copilot integration** | Not announced | MCP Server (shipped, Oct 2025) | Planned | None | None | None |
| **ServiceNow integration** | Workflow Automation | ServiceNow Assist (bidirectional) | ? | Yes (basic) | None | None |
| **Atlassian integration** | Not announced | Rovo Ops (yes) | ? | None | None | None |
| **MCP Server** | Not announced | Yes (GitHub Registry) | ? | None | None | None |
| **LLM Observability** | GA (most mature) | Yes | Yes (AI Monitoring) | None | Yes (basic) | None |
| **NL query interface** | Bits AI Agents | Dynatrace Assist | New Relic AI (NRQL) | SPL Assistant | AI Assistant | None |
| **Developer Agent** | Not separate | Developer Agent (GA) | Not announced | None | None | None |
| **Security Agent** | Not separate | Security Agent (GA) | Not announced | Splunk SOAR (security only) | None | None |
| **Named customer proof points** | 10+ (iFood, Uber Freight, Kyndryl, CAINZ, etc.) | Autodesk | TBD | None for AI | None for AI | None |

---

## Strategic Implications for New Relic

### The Competitive Clock is Ticking
Datadog has paying customers using Bits AI SRE today with hard MTTR reduction numbers. Dynatrace has the broadest agentic ecosystem and a compelling "deterministic + agentic" narrative. New Relic risks being perceived as a fast follower if the SRE Agent doesn't ship with differentiated capabilities soon.

### Where New Relic Can Win

1. **Consumption pricing for AI.** Both Datadog and Dynatrace will charge premium for AI agents on top of already-expensive platforms. New Relic's usage-based model could make AI-powered observability accessible to mid-market teams that can't afford $50K+ Datadog or Dynatrace contracts. Don't create a separate AI SKU. Make AI a reason to use more of the platform, not a separate line item.

2. **Transparency and control.** Enterprise SREs don't trust black-box AI. New Relic should lean into "show your work" agent design: every hypothesis visible, every signal examined, every decision explained, every action reversible. This directly counters Datadog's opaque "learns from every investigation" and Dynatrace's aspirational "autonomous operations" messaging.

3. **NRDB/NRQL as the AI foundation.** New Relic's unified telemetry data store is underappreciated. Position it as the open, queryable foundation that AI agents reason over, unlike Datadog's siloed product data or Dynatrace's proprietary Grail requiring OneAgent.

4. **OTel-native advantage.** Dynatrace's best AI features require OneAgent. Datadog's require their agent. New Relic's OTel support means the SRE Agent can work with data from any instrumentation source, not just proprietary. This matters for organizations with heterogeneous tooling.

5. **Agentic integrations must match Dynatrace's breadth.** Azure SRE Agent + AWS DevOps Agent + GitHub Copilot should be a coordinated launch. Publish an MCP Server and get it listed in the GitHub MCP Registry. ServiceNow and Atlassian integrations are also table stakes based on Dynatrace's moves.

6. **Displace Splunk.** Splunk/Cisco has no agentic play and is distracted by post-acquisition integration. Their massive enterprise base is ripe for displacement. Create a migration playbook specifically for Splunk customers who want AI-powered observability.

### Where New Relic is at Risk

1. **Proof points.** Datadog has 10+ named customers. Dynatrace has Autodesk. New Relic needs design partners and early customer wins urgently.

2. **Ecosystem partnerships.** Dynatrace's Azure + GitHub + ServiceNow + Atlassian + AWS partnerships create a network effect. If New Relic can't match this, enterprises will choose the platform that plugs into their existing tools.

3. **LLM Observability maturity gap.** Datadog's LLM Observability is the most complete (structured experiments, hallucination detection, drift analysis). New Relic's AI Monitoring needs to close this gap or concede the sub-market.

4. **Narrative clarity.** Dynatrace owns "deterministic + agentic AI." Datadog owns "AI on-call." New Relic's current homepage says "Your agentic platform is here." That's generic. What's the specific, memorable positioning that a buyer can repeat to their CFO?

### Recommended Actions (Priority Order)

1. **Get the SRE Agent into design partner hands immediately.** Collect real MTTR reduction data and customer quotes before Datadog's DASH conference (June 9-10, 2026).
2. **Ship an MCP Server and list it in the GitHub MCP Registry.** Dynatrace did this in Oct 2025. Every month without one is a lost opportunity for developer adoption.
3. **Coordinate the agentic integrations launch.** Azure SRE Agent + AWS DevOps Agent + GitHub Copilot announced together at a major event, not dripped out individually.
4. **Define the counter-positioning narrative.** "The agent that shows its work" or "Transparent AI for SREs" or similar. Something that makes Datadog's black-box and Dynatrace's autonomous claims feel like weaknesses.
5. **Price AI into consumption.** Confirm no separate AI SKU. This is the structural advantage over both Datadog and Dynatrace.
6. **Build a Splunk displacement playbook.** Target enterprise accounts with upcoming Splunk renewals.

---

*Sources: Direct product pages and blog posts from datadoghq.com (Bits AI SRE, LLM Observability, Watchdog, AI Integrations pages), dynatrace.com (Dynatrace Intelligence platform page, Azure SRE Agent blog Nov 2025, GitHub Copilot MCP blog Oct 2025, Agentic Ecosystem blog Jan 2026, Davis AI tag index), elastic.co (Observability page, Elastic Agent page), grafana.com (product navigation, Cloud feature descriptions), splunk.com (products page), newrelic.com (AI page, AIOps page). All accessed February 19, 2026. Customer quotes sourced from vendor marketing materials and should be independently verified.*
