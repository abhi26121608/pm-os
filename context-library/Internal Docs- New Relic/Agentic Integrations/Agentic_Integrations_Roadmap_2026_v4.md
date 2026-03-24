# New Relic Agentic Integrations Roadmap - FY2026

## Executive Summary

**Vision:** New Relic becomes the orchestration layer for agentic workflows. Users stay in NR while AWS DevOps Agent, Azure SRE Agent, GitHub Copilot, and other agents work behind the scenes. Issues get detected, analyzed, and fixed automatically.

**Strategic Intent:** Bridge strategy - leverage partner agents to deliver customer value NOW while NR's in-house SRE Agent (SRE NERD) is developed.

**2026 Capacity:** 5-6 moderate-depth integrations

---

## Priority Definitions

| Priority | Definition | Timeline |
|----------|------------|----------|
| **P1** | Must-have for FY26. Critical for customer retention and competitive positioning | Q1-Q2 2026 |
| **P2** | High value. Complete in FY26 if capacity allows | Q2-Q3 2026 |
| **P3** | Evaluate for late FY26 or FY27 | Q3-Q4 2026 |

---

## Integration Priority Table

### P1 - Must Have (6 Integrations)

| Integration | Priority | Integration Scenario | Explanation |
|-------------|----------|---------------------|-------------|
| **AWS DevOps Agent** | P1 | NR detects latency spike → identifies EC2 capacity issue → invokes AWS DevOps Agent → DevOps Agent scales ECS tasks → response appears IN NR platform (no context switch) → NR enriches with app data ("3x traffic from marketing campaign") → user sees unified view | **Why P1:** (1) Most NR customers are on AWS - this is our largest cloud segment. (2) Genesis, Pearson, and one undisclosed customer are ALREADY using DevOps Agent with NR MCP today - customers aren't waiting for NR SRE Agent. (3) Current integration is one-way only; customers at re:Invent complained about context switching between NR and AWS console. (4) AWS product team is actively asking "how do you want us to send information to you?" - they're ready to build deeper. (5) Muthuvelan has 3 architecture options ready. **Business risk if we don't:** Customers get value from DevOps Agent without NR involvement → NR becomes just a data source, loses platform stickiness, revenue at risk. |
| **Azure SRE Agent** | P1 | NR detects API degradation → identifies App Service at capacity → tells Azure SRE Agent "scale from 2 to 5 instances" → Azure executes (has permissions NR doesn't have) → NR also requests "increase trace sampling to 100% for 15 min" → Azure adjusts Application Insights → NR gets enriched data → identifies root cause (memory leak from recent deployment) | **Why P1:** (1) Growing Azure customer base - many customers are multi-cloud (AWS + Azure). (2) Integration already exists but returns messy output (one word per line) - minor fix unlocks value. (3) Phase 2 is the strategic play: Azure SRE Agent can take actions NR cannot (scaling, config changes, adjusting trace granularity) - Glenn confirmed these exact use cases. (4) Microsoft QBR in February - window to align roadmaps with RoIT. **Business risk if we don't:** Azure customers needing remediation actions will use Azure Monitor instead of NR as their primary platform. |
| **Azure Foundry** | P1 | Customer builds custom "Order Processing Agent" on Foundry → agent needs observability → queries NR for service health → NR returns "payment-gateway P99 is 2.3s" → agent routes orders to backup processor → agent logs its decision to NR for agent observability | **Why P1:** (1) Azure Foundry is WHERE enterprises build custom AI agents - this is the platform play. (2) Glenn's team is actively working on making NR "first class" on Foundry. (3) If customer-built agents don't integrate with NR by default, they'll use Azure Monitor. (4) Platform stickiness: once customer agents depend on NR intelligence, switching cost is high. **Business risk if we don't:** Enterprises building agents on Foundry default to Azure Monitor, not NR. |
| **GitHub Copilot** | P1 | Developer commits code → NR Change Intelligence detects performance regression in production → NR identifies slow database query → creates GitHub issue with context → Copilot coding agent analyzes → creates PR with index optimization → merged → NR verifies fix in production telemetry | **Why P1:** (1) This is the "code meets production" integration - developers write code, NR sees production impact, Copilot fixes it. (2) Phase 2 integration already planned with Microsoft - shared roadmap exists. (3) Change Intelligence (NR's deployment correlation capability) is the differentiator - we know WHICH deployment caused issues. (4) Future coding agents (Jules, etc.) plug into same flow - build once, extend to many. **Separate from Security RX:** Security RX Agent (CVE detection → Copilot fix) is a P1 use case owned by Crystal's team, already near public preview. This is complementary but distinct - Change Intelligence is about performance, Security RX is about vulnerabilities. Both use Copilot as the fix mechanism. |
| **Atlassian (Jira/Confluence)** | P1 | NR detects incident → auto-creates Jira ticket with: alert details, affected services, recent deployments, suggested runbook from Confluence → engineer opens ticket with full context → resolves → NR auto-closes alert when Jira marked resolved | **Why P1:** (1) Enterprise DevOps teams live in Jira - this is where incidents are tracked. (2) Atlassian is building this integration themselves (low NR engineering effort). (3) Suda set up partner-owned model - "more of them using us than us using them." (4) Confluence connector already built and working - SRE Agent uses it for runbook context. **Business risk if we don't:** Engineers context-switch between NR and Jira constantly. Atlassian integrates with Datadog instead. |
| **Internal Customers (Nordstrom)** | P1 | Custom integration between NR and Nordstrom's fleet management systems → NR provides observability for their specific operational requirements → Nordstrom becomes reference customer | **Why P1:** (1) Direct revenue impact - this is a paying customer asking for support. (2) Orin (NR leadership) explicitly wants this supported. (3) Requires three-way meeting (fleet team, Orin, Camden) - Abhishek has call with Camden scheduled. (4) Reference customer value - "Nordstrom uses NR" unlocks similar enterprise deals. **Business risk if we don't:** Lose strategic customer, lose reference case, Orin unhappy. |

---

### P2 - High Value (5 Integrations)

| Integration | Priority | Integration Scenario | Explanation |
|-------------|----------|---------------------|-------------|
| **Amazon Q Suite** | P2 | VP asks Q Suite "How is checkout performing?" → Q Suite queries NR MCP → NR returns SLO compliance, MTTR trends, error budget → Q Suite presents business summary. OR: Engineer asks "What's wrong with order-service?" → Q Suite queries NR → returns alerts, recent deployment, error spike → suggests "deployment xyz likely caused issue" | **Why P2 (not P1):** (1) MCP integration is ALREADY COMPLETE - technical work done. (2) Blocked on use case development, not engineering. (3) AWS pushing back: "Why would a business user need telemetry? Give us a compelling use case." (4) Anush wants demos for executive conversations. **What's needed:** Develop 2 use cases (business persona, DevOps persona), create demos, plan joint AWS webinar. This is enablement work, not integration work. |
| **Claude** | P2 | Developer in Claude asks "Why is /api/orders slow in production?" → Claude queries NR MCP → NR returns P99 latency (2.3s), trace showing 80% time in DB query, actual slow query → Claude suggests "Add index on orders.customer_id" and generates migration code | **Why P2:** (1) Growing developer adoption of Claude for coding. (2) MCP-first architecture = same tools built for Copilot work for Claude with minimal effort. (3) Shift-left observability: developers get production context while writing code, catch issues before deployment. (4) Low engineering effort, extends NR reach into AI coding tools beyond GitHub. |
| **Cursor** | P2 | Same as Claude - developer debugging in Cursor gets NR production context (traces, latency, error patterns) to fix issues faster | **Why P2:** (1) Popular AI coding assistant with strong developer following. (2) Same MCP tools work - near-zero incremental engineering. (3) Combined with Claude, covers major non-GitHub AI coding tools. (4) Developer productivity play - NR embedded in where developers work. |
| **Postman** | P2 | Developer tests new API in Postman → Postman queries NR "What's baseline for /api/orders?" → NR returns P50: 120ms, P99: 450ms → developer runs test → Postman compares → warns "Your P99 is 800ms, 78% slower than production baseline" → developer fixes before deploying | **Why P2:** (1) API development workflow - catch regressions before production. (2) API-first companies are strong NR segment. (3) Need to define specific use cases before building. **What's needed:** Define use cases, evaluate build vs. partner approach. |
| **PagerDuty** | P2 | NR detects payment service issue → analyzes root cause ("DB connection pool, not app code") → invokes PagerDuty → routes to DBA on-call (not app team) with full NR context → DBA acknowledges → NR tracks time to resolve → DBA fixes → NR auto-resolves alert | **Why P2:** (1) Natural incident management fit - on-call engineers use PagerDuty. (2) Smarter routing = faster MTTR. NR intelligence tells PagerDuty WHO should fix it. (3) Enterprise ITSM is key buying center alongside ServiceNow. **Consideration:** Evaluate priority vs ServiceNow (similar space). |

---

### P3 - Evaluate Later (6 Integrations)

| Integration | Priority | Integration Scenario | Explanation |
|-------------|----------|---------------------|-------------|
| **AWS Bedrock** | P3 | Customer running LLM on Bedrock → installs NR dashboard template → sees token usage, latency by model, cost per request → identifies "Claude 3x more expensive, only 10% better for our use case" → switches models, saves cost | **Why P3:** (1) NOT an agentic integration - just dashboard visibility. (2) Data is already flowing to NR, nobody's using it. (3) Needs dashboard templates, not agent integration. (4) Puja Bancha working on cloud cost intelligence overlap. **Lower priority than:** True agentic integrations that enable automated remediation. |
| **AWS Kiro** | P3 | NR detects CloudFormation drift (Lambda timeout changed unexpectedly) → sends context to Kiro → developer asks Kiro "Why is Lambda timing out?" → Kiro queries NR for traces → identifies downstream API is slow → suggests CloudFormation update with retry logic | **Why P3:** (1) MCP integration already done - technical work complete. (2) AWS pushing back hard: "Why would a developer need telemetry? Give us a use case." (3) Best potential is Infrastructure-as-Code scenarios (CloudFormation drift). (4) Even Datadog isn't prioritizing developer platforms - they're focused on Bits. **Evaluate after:** Copilot, Claude, Cursor prove the developer workflow pattern. |
| **AWS Q Index** | P3 (Blocked) | NR SRE Agent investigating DB timeout → queries customer's Q Index for "database timeout runbook" → Q Index returns internal runbook (data stays in customer environment) → SRE Agent says "Per your runbook, step 1: check connection pool, step 2: verify RDS status" | **Why P3 (Blocked):** (1) HIGH POTENTIAL for enterprise customers with strict data governance - data doesn't leave their environment. (2) BLOCKED by OAuth/OIDC - SLC rejected Cognito workaround. (3) Login service says OIDC "in roadmap" but no date. (4) Abhishek working with Ram on workaround. **If unblocked:** Moves to P2 - game-changer for security-conscious enterprises. |
| **Google Jules** | P3 | Same as Copilot - NR detects issue → creates GitHub issue → Jules (instead of Copilot) analyzes and creates PR → NR verifies fix | **Why P3:** (1) Lower market share than GitHub Copilot. (2) MCP architecture means same tools work - low incremental effort. (3) Wait for Copilot to prove the pattern, then extend to Jules. **Not a focus for FY26** given capacity constraints. |
| **Moveworks** | P3 | Employee reports "Salesforce is slow" → Moveworks queries NR → NR says "Salesforce API is fine, your SSO service is slow" → Moveworks routes to SSO team (not Salesforce team) | **Why P3:** (1) Enterprise IT automation - lower strategic priority than cloud agents and developer tools. (2) Evaluate customer demand before investing. (3) FY27 candidate if customer requests increase. |
| **AWS Security Agent** | P3 (Q2) | NR Security RX detects S3 bucket publicly accessible → queries AWS Security Agent "What's infrastructure blast radius?" → AWS returns "3 Lambda functions accessing, GuardDuty saw suspicious pattern" → NR adds "Lambda functions handle 10K requests/day with PII" → combined recommendation → AWS Security Agent fixes bucket policy → NR verifies | **Why P3 (Q2 timing):** (1) Depends on AWS DevOps Agent success first - prove third-party agent pattern works. (2) Internal product team has "our baby" mentality about NR agents - need alignment. (3) Muthuvelan planning call with AWS Security Agent team in Q2. (4) AWS has 3 frontier agents (Developer, DevOps, Security) - we're starting with DevOps. |

---

## Priority Summary

| Priority | Count | Integrations |
|----------|-------|--------------|
| **P1** | 6 | AWS DevOps Agent, Azure SRE Agent, Azure Foundry, GitHub Copilot, Atlassian, Internal Customers |
| **P2** | 5 | Amazon Q Suite, Claude, Cursor, Postman, PagerDuty |
| **P3** | 6 | AWS Bedrock, AWS Kiro, AWS Q Index (Blocked), Google Jules, Moveworks, AWS Security Agent |

---

## Multi-Agent Orchestration Patterns

### Pattern 1: Performance Incident → Auto-Remediation
```
NR APM detects latency spike
    ↓
NR identifies: infrastructure issue (scaling needed) + code issue (memory leak)
    ↓
PARALLEL:
  → AWS DevOps Agent / Azure SRE Agent scales infrastructure (immediate relief)
  → GitHub Copilot creates PR to fix memory leak (permanent fix)
    ↓
NR verifies both fixes in production telemetry
    ↓
Jira ticket auto-closed
```

### Pattern 2: Security Vulnerability → End-to-End Fix
```
NR Security RX detects CVE in production code
    ↓
Security RX analyzes: blast radius, affected services, exploitation signals
    ↓
Creates remediation plan
    ↓
Creates GitHub issue with full context
    ↓
GitHub Copilot creates PR (dependency update, input validation, tests)
    ↓
PR merged (human approval or auto for low-risk)
    ↓
NR verifies vulnerability gone from production
```

### Pattern 3: Proactive Prevention
```
NR World Model predicts: "DB connection pool exhausts in 2 hours"
    ↓
AWS DevOps Agent increases connection pool proactively
    ↓
NR logs prevented incident
    ↓
Team notified: "Prevented incident, no action needed"
```

### Pattern 4: Developer Productivity (Shift-Left)
```
Developer writing code in Claude/Cursor
    ↓
Asks: "What should I watch out for in this service?"
    ↓
NR returns: "N+1 query pattern caused issues in similar endpoints"
    ↓
Developer avoids issue before writing problematic code
    ↓
Deploys → NR confirms no regression
```

---

## Critical Blockers

| Blocker | Impact | Status | Owner | Action |
|---------|--------|--------|-------|--------|
| **OAuth 2.0 / OIDC** | Blocking Q Index, limiting enterprise integrations | Login service says "in roadmap" but no date. SLC rejected Cognito workaround. | Ram (auth product lead) | Abhishek working on workaround with Ram |
| **Internal Alignment** | Product team (Dharmi) protective of NR SRE Agent vs third-party agents | "Our baby" mentality. Reality: customers already using AWS DevOps Agent. | Dharmi / EPD | Align on "orchestration layer" vision |
| **Azure Payload Issues** | Azure SRE Agent returns messy output (one word per line) | Minor technical fix needed | Glenn Thomas | Coordinating with Microsoft |

---

## Quarterly Phasing

### Q1 2026 (Jan-Mar)
| Integration | Milestone |
|-------------|-----------|
| AWS DevOps Agent | Bidirectional architecture finalized, implementation started |
| Azure SRE Agent | Payload issues fixed, Phase 2 design complete |
| Azure Foundry | First-class support shipped |
| GitHub Copilot | Change Intelligence → Copilot flow progressing |
| Atlassian | Support their development, ensure APIs available |
| Nordstrom | Three-way meeting complete, requirements defined |

### Q2 2026 (Apr-Jun)
| Integration | Milestone |
|-------------|-----------|
| AWS DevOps Agent | Bidirectional integration live |
| Azure SRE Agent | Phase 2 (NR → Azure remediation) live |
| GitHub Copilot | GA, proactive remediation beta |
| Amazon Q Suite | Use cases documented, joint AWS webinar |
| Claude/Cursor | MCP tools exposed, docs published |
| AWS Security Agent | Initial call with AWS team |

### Q3-Q4 2026
| Integration | Milestone |
|-------------|-----------|
| PagerDuty | Integration live |
| Postman | Use cases defined, development |
| AWS Bedrock | Dashboard templates live |
| AWS Q Index | Live if OAuth resolved |

---

## Team & Resources

**Current Team:**
- Justin (Software Developer) - Integration development
- Ome (Engineering Manager)
- 3 engineers joining in ~2 weeks

**Key Stakeholders:**
- Glenn Thomas - Azure/Microsoft
- Muthuvelan - AWS
- Dharmi - Product (EPD)
- Ram - OAuth/Auth
- Crystal Portoero - Security RX
- Rahul - Technical lead (returning from vacation)

**Capacity:** 5-6 moderate integrations in FY26

---

## Competitive Positioning vs Datadog

| Dimension | Datadog | New Relic | NR Advantage |
|-----------|---------|-----------|--------------|
| Strategy | One agent (Bits) to rule all | Orchestration layer for many agents | Partner-friendly, more flexible |
| AWS DevOps Agent | MCP-level only, not going deep | Deep bidirectional with enrichment | AWS recommending NR to customers |
| Developer Tools | Limited IDE integration | Copilot, Claude, Cursor all get NR intelligence | Embedded in developer workflow |
| Multi-Cloud | Separate workflows | Single NR orchestration | One pane of glass |

---

## Next Steps

**This Week:**
- [ ] Muthuvelan sends AWS DevOps Agent architecture proposal (3 options)
- [ ] Abhishek call with Camden re: Nordstrom
- [ ] Set up bi-weekly sync with Muthuvelan

**Next Week:**
- [ ] Review proposal with Muthuvelan and Rahul
- [ ] Glenn checks on RoIT (Microsoft) meeting
- [ ] Abhishek follows up with Ram on OAuth

**End of January:**
- [ ] Roadmap alignment with Dharmi/EPD
- [ ] Nordstrom three-way meeting complete

---

*Document Owner: Abhishek Pandey*
*Last Updated: January 29, 2026*
*Version: 4.0*
