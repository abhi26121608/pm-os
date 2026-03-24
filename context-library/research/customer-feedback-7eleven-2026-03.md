# Customer Feedback: 7-Eleven PM

**Date:** March 2026
**Source:** Product Manager at 7-Eleven (direct conversation with Abhishek)
**Context:** Challenges and opportunities they see with New Relic

## Top 3 Asks
1. **Find gaps before we do**: Auto-identify missing alerts, missing instrumentation, hidden risks
2. **Help us prevent repeats**: Translate logs + RCA into guidance on what to log/instrument next time
3. **True end-to-end visibility**: Auto-correlate multi-system journeys (fuel → CFD → orchestration → APIs → comms → POS)

## Detailed Feedback

### 1. Hard to know where alerts should exist
- System spans APIs, SDKs, mobile, in-store devices, orchestration layers, vendor systems
- Don't know which components lack alerts until something breaks
- Alert coverage is inconsistent (teams add reactively, not proactively)
- Want: "alert coverage report" showing services with no alerts, recommended alerts, anomaly-without-alert detection

### 2. Post-incident follow-ups unclear
- After RCA, teams don't know exactly where to add logs, attributes, or spans
- Logging quality varies across services
- Waste time re-discovering context that could have been captured earlier
- Want: After investigation, recommend where to add logging, what attributes, what alerts to create, sample code snippets

### 3. No single view for multi-system products
- Customer journeys span disconnected systems (fuel → CFD → orchestration → APIs → comms → POS)
- Can observe each system individually but not as a single flow
- Issues in one part show up downstream with no clear connection
- Want: Auto-stitch cross-system traces into single "product flow" view, journey-stage alerts

### 4. Can't correlate business impact with technical failures
- Product teams want: "Did this incident reduce redemptions? Did outage impact offer selection?"
- Requires manual correlation today
- Want: Tie system metrics to business KPIs (click-through, offer delivered, offer redeemed)

### 5. Recurring incidents from incomplete signal correlation
- Errors Inbox helps but multi-service issues still require manual investigation
- Incident threads jump across several dashboards
- Want: AI-driven root cause summary combining logs, errors, traces, deployments + upstream/downstream auto-highlighting
