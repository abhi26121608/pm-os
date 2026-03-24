# Business Information

## Company Overview

### Basic Information

**Company Name:** New Relic

**Industry:** Software/SaaS, Observability (formerly APM)

**Stage:** Formerly public (NEWR), now private after acquisition by TPG and Francisco Partners. Operates with the scale and maturity of a major public company, with a long-term growth focus under private ownership.

**Website:** https://newrelic.com

**Size:**
- Employees: ~3,000+
- Revenue: $900M+ ARR
- Funding: Private equity-backed (TPG / Francisco Partners acquisition)

---

## Product Information

### Core Product

**Product Name:** New Relic

**One-Line Description:**
A unified data platform that captures all telemetry (metrics, events, logs, and traces) to help engineers monitor, debug, and optimize their entire software stack.

**Detailed Description:**
New Relic provides a single platform for all observability needs. Instead of forcing engineering teams to stitch together separate tools for logging, infrastructure monitoring, APM, and distributed tracing, we bring everything into one place. The platform ingests all telemetry data into a single data store (NRDB) and lets engineers query, visualize, and alert on it in real time.

What makes us different is the "all-in-one" approach combined with consumption-based pricing. Engineers don't need to context-switch between tools during an incident. They can go from a high-level dashboard to a specific log line to a distributed trace in a single workflow. And with New Relic AI, they can ask questions in plain English and get answers immediately.

We serve everyone from two-person startups to 50% of the Fortune 100. If you have software running in production, we help you keep it healthy.

### Product Categories

**Primary Category:** Observability / Application Performance Monitoring (APM)

**Secondary Categories:** Infrastructure Monitoring, Log Management, Distributed Tracing, AIOps, Digital Experience Monitoring

**Key Features:**
1. APM (Application Performance Monitoring) with distributed tracing
2. Infrastructure monitoring (hosts, containers, Kubernetes, cloud services)
3. Log management with full-text search and correlation to traces/metrics
4. New Relic AI, a generative AI assistant for plain-English observability queries
5. Alerts and anomaly detection with error budgets and SLO tracking
6. Browser and mobile real user monitoring (RUM)
7. Synthetic monitoring for proactive uptime checks
8. Dashboards and custom visualizations via NRQL (New Relic Query Language)

**Technology Stack:**
- Frontend: React
- Backend: Go, Java, Ruby
- Database: NRDB (custom-built telemetry database), PostgreSQL
- Infrastructure: AWS (primary cloud provider)
- Mobile: React Native for mobile app

---

## Target Market

### Customer Segments

**Primary Customer:**
- **Who:** Software Engineers, SREs (Site Reliability Engineers), DevOps Engineers
- **Company size:** Startups to Fortune 100 (all sizes)
- **Industry:** Any industry with a digital footprint (tech, finance, retail, healthcare, media)
- **Geography:** Global, strongest in North America and EMEA
- **Budget:** Consumption-based, ranges from free tier to multi-million dollar enterprise contracts

**Secondary Customer:**
- **Who:** Engineering Managers, VPs of Engineering, CTOs
- **Company size:** Mid-market to enterprise
- **Industry:** Same as above (decision-makers who approve tooling budgets)
- **Geography:** Global
- **Budget:** Enterprise contracts, often consolidated from multiple point solutions

### Ideal Customer Profile (ICP)

**Firmographics:**
- Company size: 50+ engineers (sweet spot: 200-5,000 employees)
- Industry: Any with production software (SaaS, fintech, e-commerce, media, healthcare)
- Geography: North America, EMEA, expanding in APAC
- Tech stack: Cloud-native or hybrid, microservices, Kubernetes
- Growth stage: Scaling companies that have outgrown DIY monitoring or are drowning in tool sprawl

**Behavioral:**
- Current solution: Stitching together 3-10 different monitoring tools (Prometheus + Grafana + ELK + PagerDuty + custom scripts)
- Pain points: Tool sprawl, slow incident resolution, lack of correlation across telemetry types, high total cost of ownership
- Buying triggers: Major outage, migration to cloud/microservices, cost audit of existing tooling, team scaling
- Decision makers: Engineering leadership (VP Eng, CTO) with strong bottom-up influence from individual engineers
- Buying process: Often starts with free tier adoption by individual engineers, expands to team, then org-wide contract

### Buyer Personas

**Persona 1: "The Firefighter" - Senior SRE**
- **Role:** On-call rotation, incident response, maintaining SLOs for production services
- **Goals:** Reduce MTTR (mean time to resolution), fewer 3am pages, stable systems
- **Challenges:** Jumping between 5+ tools during an incident. Context-switching kills speed. Alert fatigue from poorly tuned thresholds.
- **Motivations:** Wants to sleep through the night. Wants to spend time on reliability engineering, not firefighting.
- **Decision criteria:** Speed to root cause, data correlation across telemetry types, alert quality
- **Quote:** "I just need to find the needle in the haystack before the CEO starts asking questions."

**Persona 2: "The Builder" - Full-Stack Software Engineer**
- **Role:** Ships features, owns services end-to-end, debugs production issues for their services
- **Goals:** Ship fast without breaking things. Understand how their code performs in production.
- **Challenges:** Limited visibility into production. Relies on SRE team or cobbled-together dashboards. Doesn't want to learn 5 different tools.
- **Motivations:** Wants one place to check "is my deploy healthy?" and move on.
- **Decision criteria:** Ease of use, quick setup (agent install), good defaults, doesn't slow down their workflow
- **Quote:** "I don't want to become a monitoring expert. I just want to know if my code is working."

**Persona 3: "The Budget Owner" - VP of Engineering**
- **Role:** Manages engineering org, sets tooling strategy, owns budget for developer tools and infrastructure
- **Goals:** Reduce tooling costs, improve team productivity, ensure platform reliability
- **Challenges:** Paying for 5 overlapping tools. Hard to measure ROI on observability. Teams pick their own tools, creating fragmentation.
- **Motivations:** Consolidation. One vendor, one bill, one platform the whole org can use.
- **Decision criteria:** Total cost of ownership, platform breadth, enterprise features (SSO, compliance, support SLAs)
- **Quote:** "We're spending $2M a year on monitoring tools and nobody can tell me if it's working."

---

## Value Proposition

### Problem Statement

**The Problem:**
When systems go down or slow down, engineers face the "war room" headache. They jump between 10 different tools (one for logs, one for metrics, one for traces, one for alerts) trying to find the root cause. This tool sprawl means slower incident resolution, higher costs, and frustrated engineers. The average enterprise uses 5-10 monitoring tools, and none of them talk to each other well.

### Solution Statement

**Our Solution:**
New Relic puts all telemetry data (metrics, events, logs, traces) into a single platform with a single query language. Engineers can go from a high-level alert to the specific line of code causing the issue without switching tools. With consumption-based pricing, teams only pay for the data they actually use, not per-host or per-seat.

### Unique Value Proposition

**What makes us different:**
1. True all-in-one platform: Every observability capability in a single product, not a bundle of acquisitions
2. Consumption-based pricing: Pay for data ingested, not per host or per seat. Transparent and predictable.
3. New Relic AI: Ask questions in plain English ("Why is checkout slow?") and get instant, correlated insights across your entire stack

**Why customers choose us over alternatives:**
- vs. Datadog: More transparent pricing (no per-host charges that balloon with scale), stronger all-in-one story
- vs. Dynatrace: More flexible and open (supports OpenTelemetry natively), better consumption pricing model
- vs. Splunk: Purpose-built for observability (Splunk started as log search), simpler UX for engineering teams
- vs. Prometheus/Grafana (open-source): No operational overhead of running your own monitoring stack, built-in correlation across data types, enterprise support and security

---

## Strategy & Goals

### Company Mission

**Mission Statement:**
Help every engineer do their best work by giving them instant access to everything they need to understand and improve their software.

**Vision (3-5 years):**
Become the default observability platform for every engineering team, powered by AI that turns data into answers automatically.

### Current Strategic Priorities

**Priority 1: Consumption-Based Pricing**
Moving away from per-host pricing to a model where customers only pay for the data they ingest. This drives transparency, removes adoption friction (no more "do I have budget for another host?"), and aligns our revenue with customer value.

**Priority 2: All-in-One Platform (New Relic Data Plus)**
Consolidating point solutions into a single platform. The goal is to be the only observability tool an engineering team needs. Replace the 5-10 tool stack with one.

**Priority 3: AI-Driven Observability (New Relic AI)**
Using generative AI to let engineers ask questions in plain English (e.g., "Why is the checkout service slow in AWS?") and get instant, correlated insights. This reduces the skill barrier to observability and dramatically speeds up incident resolution.

**Priority 4: Agentic AI (SRE Agent + Agentic Integrations)**
Building an autonomous SRE Agent (always-on L1 responder for alert triage, RCA, remediation) and a portfolio of agentic integrations (AWS DevOps Agent, Azure SRE Agent, GitHub Copilot, Atlassian, etc.) that position New Relic as the observability intelligence layer every AI agent calls on. This is the company's key bet to differentiate in the AI observability arms race against Datadog (Bits AI SRE) and Dynatrace (Dynatrace Intelligence).

See detailed briefs: `context-library/prds/sre-agent-product-brief.md` and `context-library/prds/agentic-integrations-brief.md`
See competitive analysis: `context-library/research/competitive-intel-ai-agentic-2026-02.md`

**Not Doing (Explicitly):**
- Not competing on "cheapest" (we compete on value and total cost of ownership)
- Not building a general-purpose data analytics platform (we're focused on observability for engineers)
- Not trying to replace developer IDEs or CI/CD tools (we integrate with them, not compete)

---

## Market & Competition

### Competitive Landscape

**Direct Competitors:**

**Datadog**
- Positioning: "Modern monitoring and security platform" + "AI on-call" (Bits AI SRE)
- Strengths: Strong brand, aggressive GTM, broad product surface, good UX. Bits AI SRE is GA with 10+ named customers (iFood: 70% MTTR reduction). Most mature LLM Observability product.
- Weaknesses: Per-host pricing gets expensive at scale. No agentic ecosystem integrations (no Azure SRE Agent, no GitHub Copilot MCP, no ServiceNow). Black-box AI ("learns from every investigation" but doesn't show its work).
- Pricing: Per-host + data ingestion (opaque, separate AI SKU)
- Market share: Market leader by revenue in cloud monitoring
- AI threat level: HIGH. First-mover on autonomous SRE agent with real proof points. DASH conference June 9-10, 2026 will likely be a major AI launch moment.

**Dynatrace**
- Positioning: "Dynatrace Intelligence" - rebranded as "agentic operations system." "Answers, not guesses" (deterministic + agentic AI).
- Strengths: Broadest agentic ecosystem in market (Azure SRE Agent, GitHub Copilot MCP Server, ServiceNow Assist, Atlassian Rovo Ops, AWS Kiro). Three domain-specific agents (SRE, Developer, Security). Deterministic AI foundation (Smartscape + Grail) creates trust advantage.
- Weaknesses: Most expensive platform. Best AI features require full OneAgent (poor with OTel/multi-vendor). Overpromises on "autonomous operations."
- Pricing: Per-host, consumption add-ons (complex)
- Market share: Strong in large enterprise, especially EMEA
- AI threat level: HIGH. Most direct competitor to NR's agentic integrations strategy. Has shipped what NR is building.

**Splunk (now Cisco)**
- Positioning: "Data-to-everything platform"
- Strengths: Dominant in log management, strong security (SIEM) story, massive install base, Cisco distribution channel
- Weaknesses: NO agentic AI play at all. Fragmented portfolio (Splunk + AppDynamics + ThousandEyes). Slow post-acquisition integration. Expensive.
- Pricing: Data ingestion-based (historically very expensive)
- Market share: Large in logging/SIEM, growing in observability
- AI threat level: LOW. Major displacement opportunity for NR.

Full competitive analysis (Datadog, Dynatrace, Splunk, Elastic, Grafana): `context-library/research/competitive-intel-ai-agentic-2026-02.md`

**Indirect Competitors:**
- Prometheus + Grafana (open-source stack): Free but requires significant operational overhead to run and scale
- ELK Stack (Elasticsearch, Logstash, Kibana): Strong for log search but limited observability correlation
- Cloud-native tools (AWS CloudWatch, Azure Monitor, GCP Cloud Operations): Convenient but lock you into one cloud and lack cross-cloud visibility

**Our Positioning:**
The only all-in-one observability platform with truly transparent, consumption-based pricing. We're for engineers who want one tool that does everything, not ten tools duct-taped together.

---

## Business Model

### Revenue Model

**Primary Revenue Stream:** Consumption-based SaaS (pay for data ingested + optional add-ons)

**Pricing Tiers:**

**Free Tier:**
- Price: $0
- Features: 100GB/month data ingest, 1 full-platform user, access to all 30+ capabilities
- Limits: Limited data retention, community support only
- Target: Individual developers, small teams evaluating the platform

**Standard:**
- Price: Consumption-based (per GB ingested)
- Features: Full platform access, extended data retention, core support
- Target: Growing teams standardizing on observability

**Pro:**
- Price: Consumption-based + per-user fees for advanced capabilities
- Features: Advanced security, compliance features (HIPAA, FedRAMP), vulnerability management
- Target: Mid-market and enterprise teams with compliance needs

**Enterprise (Data Plus):**
- Price: Custom contracts
- Features: Extended retention (up to 90 days), HIPAA/FedRAMP compliance, advanced security, premium support, New Relic AI
- Target: Large enterprises consolidating observability tooling

### Key Metrics

**North Star Metric:** Data ingested per active customer (measures both adoption depth and platform value)

**Primary Metrics:**
- ARR/MRR: $900M+ ARR
- Growth rate: Focus on net revenue retention and consumption growth
- Customers: 16,000+ active accounts
- ARPU: Varies widely (free tier to multi-million dollar enterprise)

**Product Metrics:**
- DAU/MAU: [To be filled]
- Activation rate: [To be filled]
- Retention: [To be filled]
- NPS: [To be filled]

---

## Go-to-Market

### Sales Motion

**Sales Model:** Product-Led Growth (PLG) with sales-assist. Engineers start on the free tier, expand usage, and eventually trigger a sales conversation when consumption grows or enterprise features are needed.

**Sales Cycle:**
- Self-serve: Instant (free tier sign-up)
- Mid-market: 30-60 days
- Enterprise: 3-6 months

---

## Product Development

### Development Process

**Methodology:** Agile/Scrum

**Sprint Length:** 2 weeks

**Release Cadence:** Continuous deployment (hundreds of deploys per day via CI/CD)

**Key Practice:** Error budgets to balance shipping velocity with system stability.

**Tools:**
- Project management: Jira
- Design: Figma
- Documentation: Confluence / internal docs
- Communication: Slack, Zoom
- Analytics: New Relic (dogfooding), Pendo, Amplitude
- Research: [To be filled]

---

## Culture & Values

### Product Principles

1. **Engineers first** - We build for the people who build software. Every feature should make an engineer's life easier.
2. **All-in-one over best-of-breed** - One platform that does everything well beats ten tools that each do one thing great.
3. **Data transparency** - Customers should always understand what they're paying for and why.
4. **Open by default** - Support open standards (OpenTelemetry), open APIs, and interoperability.
5. **Ship fast, measure everything** - We practice what we preach. We use our own platform to monitor our platform.

---

## Key Resources

### Communication

**Meeting Cadence:**
- Daily: Standups per squad
- Weekly: Team syncs, cross-functional planning
- Bi-weekly: Sprint reviews, retrospectives
- Monthly: Product reviews, all-hands
- Quarterly: OKR planning, strategy reviews

---

**Owner:** Product Team
**Last Updated:** 2026-02-19
