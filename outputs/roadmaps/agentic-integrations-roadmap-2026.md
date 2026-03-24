# Agentic Integrations Roadmap: FY2026

**Product:** Agentic Integrations + SRE Agent
**Time Period:** Q1-Q4 2026
**Owner:** Abhishek Pandey (Senior PM, AI)
**Last Updated:** 2026-02-19
**Next Review:** 2026-03-07

---

## Strategic Context

**Goal:** Position New Relic as the observability intelligence layer every AI agent calls on. Win the agentic ecosystem race before Datadog DASH (June 9-10, 2026).

**Where we stand today:**
- SRE Agent in active development, Public Preview target Feb 24, 2026
- 3 customers already using AWS DevOps Agent with NR MCP (Genesis, Pearson, 1 undisclosed)
- Dynatrace has shipped 5 agentic integrations (Azure SRE Agent, GitHub Copilot MCP, ServiceNow Assist, Atlassian Rovo Ops, AWS Kiro)
- Datadog has NO agentic ecosystem play (Bits AI SRE is self-contained). Their gap is our window.
- MCP (Model Context Protocol) emerging as the universal connector standard

**Critical Dates:**
- Feb 24, 2026: SRE Agent Public Preview target
- March 2026: Datadog DASH early-bird registration opens (expect marketing ramp)
- June 9-10, 2026: Datadog DASH conference (likely major AI launch event)
- Throughout 2026: Dynatrace continuing to expand agentic ecosystem

**Capacity Assumption:** ~2 dedicated integration engineers + PM bandwidth. Adjust scenarios based on actual headcount.

---

## Current Portfolio: 15 Integrations, 3 Tiers

| Priority | Integration | Engineering Status | Competitive Position |
|----------|------------|-------------------|---------------------|
| **P1** | AWS DevOps Agent | Customers already using | Ahead (customer traction) |
| **P1** | Azure SRE Agent | Exists, needs fixes | Behind Dynatrace |
| **P1** | Azure Foundry | Glenn's team building | Ahead (unique play) |
| **P1** | GitHub Copilot | Phase 2 planned w/ Microsoft | Behind Dynatrace |
| **P1** | Atlassian (Jira/Confluence) | Atlassian building it | Even |
| **P1** | Nordstrom | Custom engagement | N/A (revenue play) |
| **P2** | Amazon Q Suite | MCP done, needs use cases | Neutral |
| **P2** | Claude/Cursor | Low effort, MCP reuse | Neutral |
| **P2** | Postman | Not started | Neutral |
| **P2** | PagerDuty/ServiceNow | Not started | Behind (Dynatrace has ServiceNow) |
| **P3** | AWS Kiro | MCP done, use case unclear | Behind (Dynatrace has it) |
| **P3** | AWS Q Index | Blocked (OAuth/OIDC) | Neutral |
| **P3** | Google Jules | Not started | Neutral |
| **P3** | Moveworks | Not started | Neutral |
| **P3** | AWS Security Agent | Depends on DevOps Agent | Neutral |

---

## Three Scenarios

The right scenario depends on engineering capacity, partnership momentum, and how aggressive we want to be before DASH. Each scenario shares the same Q1 (already committed). They diverge starting Q2.

---

### Scenario A: Conservative ("Ship What's Started")

**Philosophy:** Nail the P1 integrations. Get them production-quality with real customer proof points. Don't spread thin.

**Risk profile:** Low execution risk, moderate competitive risk (Dynatrace extends lead on breadth)

**What ships:**
- Q1-Q2: 6 P1 integrations + SRE Agent PP
- Q3-Q4: 2-3 P2 integrations
- Total by EOY: 8-9 integrations live

**Best for:** If engineering capacity is constrained (fewer than 2 dedicated engineers) or if we believe depth beats breadth.

#### Q1 2026 (Jan-Mar): Foundation

| Initiative | Description | Target | Status |
|-----------|-------------|--------|--------|
| SRE Agent Public Preview | Core product, enables all integrations | Feb 24 | In progress |
| AWS DevOps Agent | Formalize what customers are already using. Ship official integration. | Mar 31 | In progress |
| Azure SRE Agent (fix) | Fix output formatting (one word per line bug). Phase 1 only. | Mar 15 | In progress |
| GitHub Copilot MCP Server | Ship NR MCP Server. List in GitHub MCP Registry. | Mar 31 | Building |
| Atlassian (Jira/Confluence) | Atlassian-led build. NR provides API access + support. | Mar 31 | In progress (Atlassian-led) |
| Nordstrom | Custom engagement for fleet management observability. | Mar 31 | In progress |

**Q1 Success Criteria:**
- SRE Agent PP live with opt-in for Pro/Enterprise
- NR MCP Server listed in GitHub MCP Registry (closes gap with Dynatrace)
- AWS DevOps Agent: 5+ customers using in production
- At least 1 customer willing to share MTTR reduction data

#### Q2 2026 (Apr-Jun): Deepen and Prove

| Initiative | Description | Target |
|-----------|-------------|--------|
| Azure SRE Agent Phase 2 | Enable actions (scaling, config changes, trace sampling). | May 31 |
| Azure Foundry | NR as first-class observability on Foundry. Glenn's team drives. | Jun 30 |
| GitHub Copilot Phase 2 | Change Intelligence integration (deployment correlation). Shared Microsoft roadmap. | Jun 30 |
| Design Partner Program | Get 3-5 enterprise customers publishing results. Target: MTTR data. | Before Jun 9 |

**DASH Readiness (June 9-10):**
- 3+ customer proof points with quantified impact (MTTR reduction, alert noise reduction)
- Public blog post or case study from at least 1 design partner
- "NR as intelligence layer" positioning backed by shipped integrations
- Counter-narrative ready: "We integrate with your agents. Datadog doesn't."

#### Q3 2026 (Jul-Sep): Selective Expansion

| Initiative | Description | Target |
|-----------|-------------|--------|
| Amazon Q Suite | Ship 2 use cases (business persona, DevOps persona). Demos for AWS execs. | Aug 31 |
| Claude/Cursor | Extend MCP tools already built for Copilot. Low effort. | Aug 31 |
| SRE Agent GA readiness | Full remediation capabilities, fine-grained access controls. | Sep 30 |

#### Q4 2026 (Oct-Dec): Consolidate

| Initiative | Description | Target |
|-----------|-------------|--------|
| SRE Agent GA | Full launch with remediation. | Nov 30 |
| PagerDuty or ServiceNow | Pick one. Evaluate which has more customer pull. | Dec 31 |

**Scenario A Scorecard vs. Dynatrace (EOY 2026):**

| Integration | Dynatrace | NR (Scenario A) | Gap |
|---|---|---|---|
| Azure SRE Agent | Shipped | Shipped (Phase 2) | Closed |
| GitHub Copilot (MCP) | Shipped | Shipped (Phase 2 + Change Intel) | Closed, differentiated |
| AWS Agent | Kiro | DevOps Agent | Different agent, NR ahead on traction |
| ServiceNow | Assist (bidirectional) | Not shipped | Still behind |
| Atlassian | Rovo Ops | Shipped | Closed |
| Azure Foundry | Not yet | Shipped | Ahead |
| MCP Server (public) | Listed | Listed | Closed |
| Developer tools (Claude/Cursor) | Partial | Shipped | Ahead |

---

### Scenario B: Balanced ("Win Before DASH")

**Philosophy:** Ship all P1s fast, pull forward high-value P2s to maximize ecosystem breadth before DASH. Coordinate a big launch moment.

**Risk profile:** Moderate execution risk, low competitive risk (match Dynatrace breadth, exceed Datadog)

**What ships:**
- Q1-Q2: 6 P1 integrations + 2 P2 integrations + SRE Agent PP
- Q3-Q4: 2-3 more P2/P3 integrations + SRE Agent GA
- Total by EOY: 11-12 integrations live

**Best for:** If we can get 3 dedicated engineers or if partnership teams (Atlassian, Microsoft, AWS) carry their weight. This is the recommended scenario.

#### Q1 2026 (Jan-Mar): Foundation + Speed

Same as Scenario A, plus:

| Initiative | Description | Target |
|-----------|-------------|--------|
| Amazon Q Suite (use cases) | Build 2 demo use cases. Not a full integration, but enablement for AWS exec conversations. | Mar 31 |

#### Q2 2026 (Apr-Jun): Coordinated Launch

| Initiative | Description | Target |
|-----------|-------------|--------|
| Azure SRE Agent Phase 2 | Actions (scaling, config, trace sampling). | May 15 |
| Azure Foundry | First-class NR on Foundry. | May 31 |
| GitHub Copilot Phase 2 | Change Intelligence. Shared Microsoft roadmap. | May 31 |
| Claude/Cursor | Extend Copilot MCP tools. Quick win. | Apr 30 |
| Postman | API baseline comparison. Targets API-first segment. | Jun 15 |
| **Launch Event** | Coordinated announcement of full agentic portfolio (not drip-fed). Blog, webinar, customer stories. | Late May |
| Design Partner Program | 5+ enterprise customers. At least 2 with published case studies. | Before Jun 9 |

**Pre-DASH Launch Strategy (Late May 2026):**
- Announce "New Relic Agentic Ecosystem" as a portfolio
- Ship all P1 integrations simultaneously (even if some were ready earlier, hold for coordinated moment)
- Joint press with AWS, Microsoft, Atlassian
- Customer keynote with quantified results
- Counter-positioning: "Open ecosystem vs. walled gardens"

#### Q3 2026 (Jul-Sep): Ecosystem Depth

| Initiative | Description | Target |
|-----------|-------------|--------|
| PagerDuty/ServiceNow | Ship the one with more customer demand. Closes Dynatrace gap. | Aug 31 |
| Amazon Q Suite (full) | Move beyond demos to production integration. Joint AWS webinar. | Sep 30 |
| SRE Agent GA readiness | Full remediation, access controls. | Sep 30 |
| AWS Kiro | If developer workflow pattern proven via Copilot/Claude, extend. | Sep 30 |

#### Q4 2026 (Oct-Dec): Platform Play

| Initiative | Description | Target |
|-----------|-------------|--------|
| SRE Agent GA | Full launch. | Nov 30 |
| Agent Observability | NR monitors the AI agents themselves (tokens, latency, decisions, errors). Unique positioning. | Dec 31 |
| Remaining P2/P3 | ServiceNow or PagerDuty (whichever wasn't done in Q3). Google Jules if demand warrants. | Dec 31 |

**Scenario B Scorecard vs. Dynatrace (EOY 2026):**

| Integration | Dynatrace | NR (Scenario B) | Gap |
|---|---|---|---|
| Azure SRE Agent | Shipped | Shipped (Phase 2) | Closed, differentiated |
| GitHub Copilot (MCP) | Shipped | Shipped (Phase 2 + Change Intel) | Closed, differentiated |
| AWS Agent | Kiro | DevOps Agent + Q Suite | Ahead |
| ServiceNow | Assist (bidirectional) | Shipped | Closed |
| Atlassian | Rovo Ops | Shipped | Closed |
| Azure Foundry | Not yet | Shipped | Ahead |
| MCP Server (public) | Listed | Listed | Closed |
| Developer tools | Partial | Copilot + Claude/Cursor + Postman | Ahead |
| Agent Observability | Not yet | Building | Ahead |

---

### Scenario C: Aggressive ("Ecosystem Leader by DASH")

**Philosophy:** Go all-in on ecosystem breadth. Ship as many integrations as possible before June. Accept some will be MVP quality. Bet that breadth of ecosystem wins the narrative war at DASH.

**Risk profile:** High execution risk, low competitive risk (exceed both Dynatrace and Datadog). Risk of shipping shallow integrations that don't deliver real value.

**What ships:**
- Q1-Q2: All P1 + all P2 integrations (10 total) + SRE Agent PP
- Q3-Q4: P3 integrations + SRE Agent GA + depth passes on earlier integrations
- Total by EOY: 13-15 integrations live

**Best for:** If leadership greenlights additional headcount (5+ engineers on integrations) and is willing to accept MVP-quality integrations for some.

**Requires:**
- 5+ dedicated integration engineers (vs. current ~2)
- Dedicated DevRel/partnership manager for AWS, Microsoft, Atlassian coordination
- Acceptance that some integrations will be "demo-quality" at launch (MCP connected, basic scenarios, not production-hardened)

#### Q1 2026 (Jan-Mar): Sprint

Same as Scenario B, plus:

| Initiative | Description | Target |
|-----------|-------------|--------|
| Claude/Cursor | Pull forward. Ship alongside Copilot MCP. | Mar 31 |
| PagerDuty initial | Begin integration. Basic alert routing with NR intelligence. | Mar 31 |

#### Q2 2026 (Apr-Jun): Blitz Before DASH

| Initiative | Description | Target |
|-----------|-------------|--------|
| Azure SRE Agent Phase 2 | Full actions capability. | Apr 30 |
| Azure Foundry | First-class NR. | May 15 |
| GitHub Copilot Phase 2 | Change Intelligence. | May 15 |
| Postman | API baseline comparison. | May 15 |
| PagerDuty/ServiceNow | Both, if capacity allows. At least one. | May 31 |
| Amazon Q Suite (full) | Production integration + joint webinar. | May 31 |
| AWS Kiro | Basic MCP integration (already done). Ship with use cases. | May 31 |
| **"Agentic Ecosystem" Launch** | 10+ integrations announced together. Major event. | Late May |

**DASH Counter-Attack (Scenario C only):**
- Publish "Agentic Ecosystem Benchmark" showing NR integrates with 10+ AI agents vs. Datadog's 0
- Customer advisory board with 10+ design partners
- Open-source the NR MCP Server (if feasible) to drive community adoption
- Launch "Build Your Agent on NR" developer program

#### Q3 2026 (Jul-Sep): Depth Pass

| Initiative | Description | Target |
|-----------|-------------|--------|
| Depth pass on all integrations | Harden MVP integrations. Add error handling, production monitoring, customer feedback. | Sep 30 |
| SRE Agent GA | Full remediation. | Sep 30 |
| AWS Q Index | Resolve OAuth/OIDC blocker (needs SLC alignment). | Sep 30 |
| Agent Observability | NR monitors the agents. | Sep 30 |

#### Q4 2026 (Oct-Dec): Market Leadership

| Initiative | Description | Target |
|-----------|-------------|--------|
| Google Jules | If developer pattern proven. | Nov 30 |
| Moveworks | If enterprise demand. | Nov 30 |
| AWS Security Agent | If DevOps Agent pattern proven. | Dec 31 |
| Ecosystem Marketplace | Self-serve integration directory. Partners can build and list their own. | Dec 31 |

---

## Scenario Comparison

| Dimension | A: Conservative | B: Balanced (Recommended) | C: Aggressive |
|-----------|----------------|--------------------------|---------------|
| **Integrations by DASH (Jun 9)** | 6 | 8-9 | 10-12 |
| **Integrations by EOY** | 8-9 | 11-12 | 13-15 |
| **Engineers needed** | 2 | 3 | 5+ |
| **Quality at launch** | High | High for P1, Medium for P2 | Mixed (some MVP) |
| **Competitive position vs Dynatrace** | Gaps remain (ServiceNow) | Match or exceed | Clearly ahead |
| **Competitive position vs Datadog** | Ahead | Well ahead | Dominant |
| **Risk** | Low exec, moderate competitive | Moderate exec, low competitive | High exec, low competitive |
| **Design partner proof points** | 3+ | 5+ | 10+ |
| **Launch strategy** | Drip-fed | Coordinated big bang | Blitz |
| **DASH readiness** | Defensive (proof points) | Offensive (counter-narrative) | Dominant (they're playing catch-up) |

---

## Dependencies and Blockers

### Critical Dependencies (All Scenarios)

| Dependency | Impacts | Owner | Status | Risk |
|-----------|---------|-------|--------|------|
| SRE Agent Public Preview | All integrations need a working SRE Agent to demonstrate value | SRE Agent team | On track (Feb 24) | Medium: Any PP delay cascades to integration demos |
| NR MCP Server (public) | GitHub Copilot, Claude/Cursor, all MCP-based integrations | Integration team | Building | High: Dynatrace already listed. Every week of delay is a week behind. |
| Microsoft Phase 2 agreement | GitHub Copilot Phase 2, Azure SRE Phase 2, Azure Foundry | Glenn's team + Microsoft | Active discussions | Medium: External dependency, can't fully control timeline |
| Atlassian building their integration | Jira/Confluence integration | Atlassian | In progress | Low: They're motivated. Risk is they also build for Datadog. |
| OAuth/OIDC for AWS Q Index | AWS Q Index integration | SLC + AWS | Blocked | High: SLC rejected Cognito workaround. Needs escalation or alternative approach. |
| Design partner recruitment | Proof points before DASH | PM (Abhishek) + Sales | Needs acceleration | High: No proof points = no counter-narrative at DASH |

### Scenario-Specific Dependencies

| Dependency | Scenario | Notes |
|-----------|----------|-------|
| 3rd engineer for integrations | B | Need to staff up by April to hit Q2 targets |
| 5+ engineers for integrations | C | Requires headcount approval from Camden/SVP |
| DevRel/partnership manager | B, C | Coordinating AWS + Microsoft + Atlassian launch requires dedicated person |
| "Product team buy-in" for third-party agents | B, C | Internal teams have "our baby" mentality about NR agents. Need to get alignment that third-party agents complement (not replace) NR's own agents. |

---

## Key Milestones and Decision Points

### Decision Points

**March 15, 2026: Scenario Selection**
After Q1 execution data, decide which scenario to commit to for Q2-Q4.
- Inputs: SRE Agent PP status, MCP Server status, engineering capacity confirmation, design partner pipeline
- Decision maker: Camden (Head of AI)

**April 30, 2026: DASH Readiness Check**
Assess what we can credibly announce before DASH.
- Inputs: Shipped integrations, design partner data, competitive landscape update
- Decision: Coordinated launch scope and timing

**July 31, 2026: Post-DASH Strategy Adjustment**
React to Datadog's DASH announcements.
- Inputs: What Datadog shipped/announced at DASH, market reaction, customer feedback
- Decision: Adjust H2 priorities based on competitive moves

**September 30, 2026: PagerDuty vs ServiceNow**
For Scenarios B and C, pick which ITSM to prioritize.
- Inputs: Customer demand data, partnership interest, Dynatrace's ServiceNow traction
- Decision: Which to ship first (or both if capacity allows)

### Milestone Timeline (Scenario B)

```
Feb 24 -------- SRE Agent Public Preview
Mar 15 -------- NR MCP Server in GitHub Registry
Mar 31 -------- AWS DevOps Agent official, Atlassian integration, Nordstrom live
Apr 30 -------- Claude/Cursor MCP, Amazon Q demos ready
May 15 -------- DASH readiness check
Late May ------ Coordinated "Agentic Ecosystem" launch
Jun 9-10 ------ Datadog DASH (counter-narrative ready)
Jun 30 -------- GitHub Copilot Phase 2, Azure SRE Phase 2, Azure Foundry, Postman
Aug 31 -------- PagerDuty or ServiceNow, Amazon Q full
Sep 30 -------- SRE Agent GA readiness, AWS Kiro
Nov 30 -------- SRE Agent GA
Dec 31 -------- Agent Observability, remaining integrations
```

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| SRE Agent PP delayed past March | Medium | High (cascades to everything) | Reduce PP scope if needed. Integration demos don't require full PP, just working agent. |
| No design partner proof points by DASH | High | High (no counter-narrative) | Start recruiting NOW. Offer co-marketing, engineering support, early access. Genesis and Pearson are warm leads. |
| Dynatrace ships more integrations in Q1-Q2 | High | Medium (widens gap) | Focus on depth over breadth where possible. Their integrations may be shallow too. |
| Datadog announces agentic ecosystem at DASH | Medium | High (first-mover narrative) | Pre-empt with late May launch. If they announce, our response is "we've been live for months." |
| Atlassian also builds for Datadog | Medium | Medium (reduces exclusivity) | Differentiate with Change Intelligence, SRE Agent depth, consumption pricing. |
| Microsoft Phase 2 timeline slips | Medium | Medium (GitHub Copilot, Azure delayed) | Decouple where possible. Ship Phase 1 improvements independently. |
| Internal resistance to third-party agents | Medium | Medium (slows progress) | Frame as complementary: "Third-party agents bring customers to NR platform. More platform usage = more consumption." |

---

## Recommendation

**Go with Scenario B (Balanced)** and plan for the Scenario Selection decision point on March 15.

Here's why:

1. **It matches our realistic capacity.** We can stretch from 2 to 3 engineers with focused hiring. We can't realistically staff 5+ by Q2.

2. **Coordinated launch beats drip-feed.** Announcing 8-9 integrations together in late May creates a bigger narrative than shipping them one by one. It also pre-empts whatever Datadog announces at DASH.

3. **Quality matters more than quantity for trust.** The SRE Agent's core differentiator is transparency ("shows its work"). Shipping shallow, demo-quality integrations would undermine that positioning. Scenario B lets us ship high-quality P1s and medium-quality P2s, not MVP throwaways.

4. **The DASH deadline forces focus.** Everything we do in Q1-Q2 should answer: "Can we tell a credible agentic ecosystem story before June 9?"

**Immediate next steps:**
1. Finalize SRE Agent PP (on track for Feb 24)
2. Ship NR MCP Server and list it in GitHub Registry (target: Mar 15)
3. Start design partner recruitment this week (Genesis, Pearson as first conversations)
4. Confirm engineering capacity for Q2 (need decision on 3rd engineer by Mar 1)
5. Align with Glenn's team on Microsoft Phase 2 timeline

---

**Owner:** Abhishek Pandey (Senior PM, AI)
**Approved by:** [Pending - Camden]
**Last Updated:** 2026-02-19
