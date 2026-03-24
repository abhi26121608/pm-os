# PM Workflows

## Daily PM Workflow
1. Morning: `/daily-plan` for prioritized plan with meeting context
2. During meetings: Take raw notes or record
3. After each meeting: `/meeting-notes` for structured notes + action items
4. End of day: `/slack-message` for any follow-ups

## Weekly PM Cycle
1. Monday morning: `/weekly-plan` to set priorities
2. Daily: Follow daily workflow above
3. Friday: `/weekly-review` to reflect on what shipped, slipped, learned
4. Friday: `/status-update` for stakeholder update

## PRD Lifecycle
1. `/user-research-synthesis` - synthesize research
2. `/impact-sizing` - size the opportunity
3. `/prd-draft` - draft the PRD
4. `/prd-review-panel` - multi-perspective review
5. `/create-tickets` - break into engineering tickets
6. `/launch-checklist` - plan the launch
7. `/feature-results` - post-launch analysis
8. Feed learnings back into next cycle

## Strategic Planning
1. `/define-north-star` - validate North Star metric
2. `/metrics-framework` - build indicator hierarchy
3. `/write-prod-strategy` - write full strategy
4. `/prioritize` - classify and prioritize backlog

## Sub-Agents for Review
When asked to review from multiple perspectives, use sub-agents in `sub-agents/`:
- `engineer-reviewer.md` - Technical feasibility
- `designer-reviewer.md` - UX/UI feedback
- `executive-reviewer.md` - Strategic alignment
- `legal-advisor.md` - Compliance, risk
- `uxr-analyst.md` - User research synthesis
- `skeptic.md` - Devil's advocate
- `customer-voice.md` - Simulate user perspective

## Context Management
- Use `clear` when switching to a completely different initiative
- Don't clear ongoing context about a single initiative
- If approaching token limits, suggest creating a new thread
- Always preserve critical context when creating new threads
