# SRE Agent: Information Gaps Analysis
## What We Need to Build a Great User Experience Plan

**Purpose**: Identify missing information critical for UX redesign decisions

---

## Summary: What We Have vs. What We Need

| Category | What We Have | What We're Missing | Priority | Status |
|----------|--------------|-------------------|----------|--------|
| Technical Architecture | ✅ Strong | Minor gaps | Low | ✅ Complete |
| User Research | ❌ None | Critical gap | **HIGH** | 🔴 Still Needed |
| Usage Analytics | ❌ None | Critical gap | **HIGH** | 🔴 Still Needed |
| Competitive Analysis | ✅ Strong | Minor gaps | **HIGH** | ✅ Addressed |
| Success Metrics/KPIs | ⚠️ Partial | Clear targets needed | **HIGH** | 🟡 Partially Addressed |
| Error States/Edge Cases | ⚠️ Partial | User-facing handling | Medium | 🟡 Partially Addressed |
| Business Context | ❌ None | Pricing, GTM | Medium | 🔴 Still Needed |
| Design Assets | ⚠️ Partial | OneCore constraints documented | Medium | 🟡 Partially Addressed |
| Strategic Direction | ✅ Strong | None | **HIGH** | ✅ Addressed |

### Update Notes (March 25, 2026)

**Gaps Now Filled:**
- **Competitive Analysis**: Comprehensive research from PM-OS context library including:
  - Datadog Bits AI: 77-screenshot UX teardown, 48-minute demo analysis
  - Dynatrace Davis AI: Full UX teardown, deterministic vs hypothesis approach
  - PagerDuty, Grafana, incident.io coverage
  - UX archetypes, trust patterns, autonomy spectrum
- **Strategic Direction**: Camden meeting transcripts provide clear vision ("generative UX", "move away from chat", "dynamic canvas")
- **Design Constraints**: OneCore limitations documented, V0/V1/V2 evolution path clear

---

## Critical Gaps (Must Have for UX Planning)

### 1. User Research Data

**What we're missing:**

#### User Personas
- Who are the primary users? (SREs, DevOps, On-call engineers - but no detail)
- Experience levels? (Junior vs. Senior)
- Technical sophistication?
- Current tools they use alongside New Relic?
- Pain points in their daily workflows?

#### User Journey Maps
- How do users discover the SRE Agent?
- What triggers them to use it? (Alert? Proactive investigation? Curiosity?)
- What do they do with the results?
- Where does it fit in their incident response workflow?

#### User Feedback Verbatims
- What do users say about the current chat experience?
- What frustrations have they expressed?
- What do they wish it could do?
- Support tickets related to SRE Agent?

#### Jobs-to-be-Done
- What "job" are users hiring the SRE Agent to do?
- What outcomes matter most to them?
- What alternatives do they use when SRE Agent doesn't work?

**Questions to answer:**
1. Do we have any user research studies conducted?
2. Are there customer interviews or feedback sessions recorded?
3. Is there a user advisory board or beta user group?
4. What does Support see in terms of SRE Agent issues?

---

### 2. Usage Analytics

**What we're missing:**

#### Adoption Metrics
- Total active users (DAU, WAU, MAU)?
- User growth trend?
- Retention/churn rates?
- Accounts using SRE Agent vs. total New Relic accounts?

#### Engagement Metrics
- Average queries per user per session?
- Session duration?
- Return visit frequency?
- Feature adoption rates (reasoning panel, context card, alert integration)?

#### Query Analysis
- Most common query types/intents?
- Query success rate (user got useful answer)?
- Query abandonment rate?
- Average queries before user gets what they need?

#### Funnel Analysis
- Where do users drop off?
- Do users engage with results or just read them?
- Do users take action based on recommendations?
- Conversion from alert notification to resolution?

#### Behavioral Patterns
- Time of day usage patterns?
- Correlation with incident volume?
- Multi-turn conversation patterns?
- Do users refine queries or start over?

**Questions to answer:**
1. Is there a product analytics dashboard (Amplitude, Mixpanel, internal)?
2. What events are currently tracked?
3. Are there any A/B tests running or completed?
4. Do we have session recordings (FullStory, Hotjar)?

---

### 3. Deep Competitive Analysis ✅ ADDRESSED

**Status**: Comprehensive competitive research now available in PM-OS context library and incorporated into Current State Documentation.

**What we now have:**

#### Datadog Bits AI ✅
- 77-screenshot UX teardown with detailed component analysis
- 48-minute demo transcript analyzed
- Investigation tree visualization pattern documented
- Hypothesis-based approach understood
- Known gaps: No memory, no prevention recommendations, no post-mortem generation

#### Dynatrace Davis AI ✅
- Full UX teardown completed
- Deterministic (causal) AI approach vs. hypothesis-based
- Distributed UX pattern (embedded throughout platform, not standalone)
- Three domain agents (SRE, Developer, Security)
- Broadest ecosystem integrations documented

#### Other Competitors ✅
- PagerDuty AIOps: Alert routing focus, limited investigation depth
- Grafana IRM: Open-source approach, Slack-native
- incident.io: Modern incident management, narrative focus
- Azure, AWS native approaches documented

#### UX Archetypes Identified ✅
1. Chat-Native (Datadog, current NR)
2. Sidebar Copilot (GitHub Copilot pattern)
3. Dashboard-Embedded (Dynatrace)
4. Autonomous Background (PagerDuty)

#### Critical UX Patterns Documented ✅
- Autonomy Spectrum (most critical - no one does well)
- Trust-building patterns (5 patterns identified)
- UX Maturity Model (L1-L5)
- Progressive disclosure patterns

**Remaining gaps:**
- Pricing/packaging comparison across competitors
- Analyst reports (Gartner, Forrester) on AIOps UX
- Direct user comparison feedback ("I prefer X because...")

---

### 4. Success Metrics & KPIs

**What we're missing:**

#### Current Metrics
- How is SRE Agent success measured today?
- What dashboards exist?
- Who reviews metrics and how often?

#### Business Goals
- What's the target for user adoption?
- Revenue goals (if monetized separately)?
- Impact on overall New Relic platform engagement?

#### UX Redesign Goals
- What does success look like for the redesign?
- What metrics would indicate the new UX is better?
- What's the timeline for measuring impact?

#### Leading vs. Lagging Indicators
- Leading: Engagement, feature adoption, task completion rate
- Lagging: Retention, NPS, revenue impact

**Questions to answer:**
1. What OKRs exist for SRE Agent?
2. What's the north star metric?
3. How will we measure UX redesign success?

---

## Important Gaps (Should Have)

### 5. Error States & Edge Cases (User-Facing)

**What we have:** Technical error handling (ExpectedException vs UnexpectedException)

**What we need:**
- How are errors communicated to users today?
- What does the user see when analysis fails?
- What recovery options exist?
- How do users handle the 15-second timeout "failed" status?
- What happens when token limits are hit?

**Screenshots/recordings of:**
- Error states in the UI
- Timeout handling
- Empty state (no results)
- Partial results

---

### 6. Business Context

**What we're missing:**

#### Pricing & Packaging
- Is SRE Agent a separate SKU?
- Is it included in certain tiers?
- What's the cost model (tokens, queries, unlimited)?
- How does this affect UX decisions? (e.g., showing token usage to users?)

#### Target Customer Segments
- Enterprise vs. SMB focus?
- Specific verticals prioritized?
- Existing customer expansion vs. new logo acquisition?

#### Go-to-Market Strategy
- How is SRE Agent being positioned?
- What's the messaging?
- Sales enablement materials?

---

### 7. Design Assets & Constraints

**What we're missing:**

#### Current Design Documentation
- Design specs for current chat UI
- Component library used
- Design system documentation

#### Screenshots/Recordings
- Current state walkthrough
- All screens and states
- Mobile experience (if any)

#### Design Constraints
- Platform design system requirements
- Accessibility requirements
- Internationalization considerations
- Performance budgets (load time, etc.)

#### Design Principles
- What design principles guide New Relic UX?
- Are there specific patterns to follow or avoid?

---

### 8. Stakeholder Context

**What we're missing:**

#### Product Vision
- What's the long-term vision for AI at New Relic?
- How does SRE Agent fit into the broader AI strategy?
- What's the 1-year, 3-year vision?

#### Engineering Constraints
- What's technically feasible in what timeframe?
- Are there architectural constraints that limit UX options?
- What would require significant backend changes?

#### Cross-Team Dependencies
- Which teams need to be involved in redesign?
- What approvals are needed?
- Who are the key stakeholders?

---

## Nice to Have (Could Inform Decisions)

### 9. Historical Context

- Why was chat chosen originally?
- What alternatives were considered?
- What learnings exist from V1 to V2?
- Any failed experiments or pivots?

### 10. Industry Trends

- AIOps market trends
- Conversational AI vs. task-based AI trends
- How are enterprise B2B products handling AI UX?
- Emerging patterns from ChatGPT, Copilot, etc.

### 11. Technical Deep Dives

- Detailed token cost breakdown by operation
- Latency breakdown by component
- Scalability limits
- API rate limits that affect UX

---

## Recommended Information Gathering Plan

### Phase 1: Critical (Week 1-2)

| Action | Owner | Source |
|--------|-------|--------|
| Request usage analytics dashboard access | PM | Data/Analytics team |
| Gather user feedback from Support | PM | Support team |
| Conduct 5-10 user interviews | UX Research | Customer Success |
| Deep competitive analysis | PM | Product Marketing, demos |
| Define success metrics for redesign | PM | Leadership |

### Phase 2: Important (Week 2-3)

| Action | Owner | Source |
|--------|-------|--------|
| Document current error states (screenshots) | Design | Engineering |
| Understand pricing/packaging implications | PM | Product Marketing |
| Review design system constraints | Design | Design Systems team |
| Map stakeholders and get buy-in | PM | Cross-functional |

### Phase 3: Nice to Have (Week 3-4)

| Action | Owner | Source |
|--------|-------|--------|
| Historical context interviews | PM | Original team members |
| Industry trends research | PM | Analyst reports |
| Technical deep dive sessions | PM | Engineering |

---

## Questions to Ask the AEON Team

Based on the demo transcripts, here are specific questions for the engineering team:

1. **Reasoning Panel Usage**: Do you have data on how many users expand/engage with the reasoning panel?

2. **Context Card Adoption**: Since `editable_context_card` is feature-flagged, what's the adoption/usage data?

3. **Query Patterns**: What are the most common queries users ask? Can we get a sample (anonymized)?

4. **Failure Modes**: Beyond technical errors, when does the SRE Agent fail to help users? What feedback have you received?

5. **Alert Integration Adoption**: How many customers have enabled "AI SRE" on their alert policies?

6. **Token Visibility**: Do users see token consumption? Should they?

7. **Response Length**: Is ~1.5 minutes acceptable to users? Any feedback on this?

8. **Mobile Usage**: Any mobile usage data? Is this a consideration?

---

## Suggested Documents to Request

1. **Product Analytics Dashboard** - Usage metrics, funnels, retention
2. **User Research Studies** - Any past research on SRE Agent or AI features
3. **Customer Feedback Compilation** - Support tickets, NPS comments, advisory board notes
4. **Competitive Analysis Deck** - If exists from Product Marketing
5. **Design Specs** - Current state designs and component documentation
6. **OKRs/Success Metrics** - Current team goals and KPIs
7. **Pricing/Packaging Documentation** - How SRE Agent is monetized
8. **AI Strategy Document** - Broader vision for AI at New Relic

---

## Summary: Top 5 Critical Questions

Before finalizing UX strategy, we must answer:

| Question | Status | Action Needed |
|----------|--------|---------------|
| 1. **Who is actually using this and how?** | 🔴 Not Answered | Request usage analytics, conduct user research |
| 2. **What do users love and hate about current experience?** | 🔴 Not Answered | User interviews, Support ticket analysis |
| 3. **What are competitors doing better?** | ✅ Answered | Comprehensive analysis complete |
| 4. **What does success look like?** | 🟡 Partially | Success metrics proposed, need validation |
| 5. **What are the constraints?** | ✅ Answered | OneCore, V0/V1 path, strategic direction clear |

---

## Revised Priority for Information Gathering

Given the gaps now filled, the revised priority order is:

### Immediate Priority (Week 1)
1. **Usage Analytics** - Get dashboard access, understand who's using it and how
2. **User Research** - 5-10 user interviews to understand real pain points
3. **Support Ticket Analysis** - What are users complaining about?

### Secondary Priority (Week 2)
4. **Success Metrics Validation** - Confirm proposed metrics with leadership
5. **Business Context** - Pricing implications for UX decisions

### Already Addressed
- ✅ Competitive Analysis (comprehensive)
- ✅ Strategic Direction (Camden meetings)
- ✅ Technical Architecture (documentation complete)
- ✅ Design Constraints (OneCore, V0/V1/V2 path)

---

*Updated March 25, 2026: Competitive analysis and strategic direction gaps addressed via PM-OS research documents. User research and usage analytics remain critical gaps.*
