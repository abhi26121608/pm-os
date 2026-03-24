# SRE Agent: Generative UX Design Roadmap (Final)

**Owner:** Abhishek Pandey | **Design:** Madhan + Inez | **Engineering:** Manny + Team
**Date:** 2026-03-12 | **Status:** Ready for design execution

This is the definitive UX design roadmap for New Relic's Investigation Canvas. It covers every dimension of the experience that needs to be designed, organized into design workstreams. Use this as the master checklist for the UX work.

---

## How to Use This Document

This roadmap is organized into **15 design workstreams**. Each workstream is a distinct area of UX that needs design decisions, wireframes, and prototyping. They can be worked on in parallel by different designers or sequentially.

For each workstream, I've listed:
- **What it is** (the design problem)
- **Key screens/states to design** (specific deliverables)
- **Design considerations** (constraints, patterns, edge cases)
- **Priority** (P0 = must have for LP, P1 = must have for PP, P2 = GA, P3 = post-GA)
- **Reference** (what Datadog or others do, where applicable)

---

## Workstream 1: Investigation Canvas Layout (P0)

**The core page structure. Everything else lives inside this.**

### Screens to Design

1. **Full-page canvas layout** (the main investigation experience)
   - Header bar (60px fixed): status, title, agents, view toggle, actions
   - Left zone (55-60%): reasoning stream (scrollable, content streams in)
   - Right zone (40-45%): evidence panel (scrollable independently)
   - Bottom bar (80px fixed): chat input + quick actions
   - Responsive behavior: what happens at different screen widths?
   - Resizable split: can users drag the divider between left and right?

2. **Canvas view vs. Trace view** (toggle in header)
   - Canvas: visual, card-based, non-technical-friendly
   - Trace: raw chronological log of every agent action, tool call, and thought (power user view)
   - Transition animation between the two views

3. **Empty canvas state** (investigation just started, nothing loaded yet)
   - Skeleton loaders matching the shape of upcoming components
   - "SRE Agent is starting investigation..." message with animation
   - Estimated time indicator? ("Usually takes 2-4 minutes")

4. **Completed investigation state** (everything resolved)
   - Header changes from "Investigating" to "Conclusive" / "Inconclusive"
   - Title updates to the actual root cause
   - Feedback prompt appears
   - Actions shift from "live" to "post-mortem" mode

### Design Considerations

- The canvas must feel **alive** during investigation. Not a static page loading. Content should stream in with smooth animations, status indicators should pulse, progress should be visible.
- Left zone scrolls to follow the latest content (auto-scroll) but user can scroll up to review. Auto-scroll pauses when user scrolls up, resumes when they scroll to bottom.
- Right zone widgets appear as the agent discovers data. New widgets animate in (slide up or fade in). Widgets can be collapsed individually.
- On small screens (< 1200px), consider stacking left/right vertically, or allowing the user to toggle between reasoning and evidence views.

---

## Workstream 2: Reasoning Stream Design (P0)

**How the agent's thinking process renders in the left zone.**

### Screens to Design

1. **Context phase card**: Entity resolved, time window, knowledge check (runbook/memory/scan)
2. **Initial findings card**: Summary text with highlighted entities and metrics
3. **Hypothesis cards** (the core differentiator):
   - Each hypothesis as a collapsible card
   - Status badge states: Queued (grey), Testing (yellow pulse), Validated (green), Invalidated (red), Inconclusive (yellow solid), Skipped (grey strikethrough)
   - Expanded view: evidence chain with links to widgets
   - User actions: Skip, Prioritize, Pin as key finding
   - Agent handoff indicator (when delegated to specialist agent)
4. **Specialist agent finding cards**: DB Agent findings, K8s Agent findings, etc.
   - Visually distinct from SRE Agent cards (different icon, subtle background tint)
   - Shows which agent produced the finding
5. **Conclusion card**: Root cause, confidence, recommended actions, feedback
6. **Agent handoff card**: "SRE Agent → DB Agent" with context passing visualization
7. **User input cards**: When user provides context or asks a question, it appears inline in the stream

### Design Considerations

- Hypothesis cards are the **most important visual element**. They need to communicate status at a glance. Consider using left-border color coding (green bar = validated, red bar = invalidated, etc.) similar to how editors show git changes.
- Evidence within hypothesis cards should be scannable: bullet points, not paragraphs. Each evidence item links to a widget in the right panel.
- When a hypothesis is being tested, show a subtle animation (pulsing border, shimmer effect) so the user knows it's active.
- Collapsed vs expanded: By default, validated hypotheses are expanded, invalidated are collapsed. User can toggle.

---

## Workstream 3: Evidence Widget System (P0)

**The library of interactive data components that render in the right zone.**

### Widgets to Design

1. **Alert context card**: Alert name, status, condition, current value, trigger time
2. **Golden signals widget**: 3 mini-charts (error rate, throughput, response time) with sparklines
3. **Deployment timeline**: Horizontal timeline with deploy markers, correlation arrows to error spike
4. **Trace flame graph**: Interactive waterfall with span details on hover, highlight problematic spans
5. **Log snippet**: Syntax-highlighted, severity-colored, collapsible, with count and "open in Log Explorer" link
6. **Connection pool widget**: Pool utilization chart, config comparison table, wait queue stats
7. **Entity relationship map**: Service dependency graph with affected nodes highlighted
8. **Config diff widget**: Side-by-side before/after with highlighted changes
9. **NRQL result widget**: Query display + rendered chart/table
10. **Error group cards**: Grouped errors with count, impact, stack trace preview
11. **K8s pod status widget**: Pod health grid, resource utilization, events timeline
12. **Infrastructure metrics widget**: CPU, memory, disk, network charts for a host
13. **Comparison widget**: Side-by-side of any two time periods (healthy vs unhealthy)
14. **SLO impact widget**: Shows which SLOs are breached or at risk

### Design Considerations

- Every widget must have 3 states: **skeleton** (loading shape), **streaming** (partial data), **complete** (full interactive)
- Every widget must link to the full NR product page ("Open in APM →", "Open in Log Explorer →") with the correct filters pre-applied
- Widgets should be **collapsible** (click to minimize to just the title bar)
- Widgets should show **provenance**: "Data from: analyze_entity_golden_metrics, queried at 3:05 AM" (subtle footer text)
- Consider a **"pin to top"** feature so users can keep the most relevant widget visible while scrolling
- Right zone should have a mini table of contents at the top showing all loaded widgets

---

## Workstream 4: Real-Time Streaming Experience (P0)

**How content appears as the agent works. The "watching it think" experience.**

### States to Design

1. **Agent thinking indicator**: Subtle animation showing the agent is processing. Not a spinner. Something like a pulsing dot, a shimmer effect on the latest card, or a "thinking..." text with animated ellipsis.

2. **Progressive content reveal**: Content blocks fade/slide in as they arrive. Not instant appear (jarring) and not slow fade (too laggy). ~200ms transition.

3. **Tool execution indicator**: When the agent calls a tool (e.g., `analyze_entity_golden_metrics`), show:
   - In reasoning stream: "Checking golden signals..." with tool name in subtle text
   - In evidence panel: Skeleton widget appears in the shape of the expected result

4. **Parallel execution**: When agent runs multiple tools simultaneously, show multiple skeleton widgets loading at once in the evidence panel.

5. **Auto-scroll behavior**:
   - Default: canvas auto-scrolls to follow latest content
   - User scrolls up: auto-scroll pauses, "↓ New content below" badge appears
   - User clicks badge or scrolls to bottom: auto-scroll resumes

6. **Long investigation handling**: If investigation takes > 5 minutes:
   - Show elapsed time prominently
   - Show progress ("Step 4 of 7", or "3 hypotheses tested, 2 remaining")
   - Allow user to navigate away and come back (investigation continues in background)

7. **Background investigation**: If user navigates away:
   - Browser notification when investigation completes
   - Badge on nav item: "🤖 AI Agents (1 complete)"
   - Investigation continues server-side, results available when user returns

### Design Considerations

- The streaming experience is what differentiates us from Datadog's "wait and see the tree" approach. It must feel responsive and alive.
- Avoid showing "loading" for too long on any single element. If a tool call takes > 10s, show an estimated time or a "this is taking longer than usual" message.
- Consider sound/haptic feedback on mobile when investigation completes (optional, user-configurable).

---

## Workstream 5: Human-in-the-Loop Interactions (P0)

**Every way a user can interact with the agent during and after investigation.**

### Interactions to Design

1. **Chat input** (bottom bar):
   - Free-form text input
   - Suggested prompts based on investigation state (e.g., during hypothesis phase: "Check the database", "Look at the deployment diff", "What about Kafka?")
   - @-mention agents: type "@" to see agent list, select to direct a message/task to a specific agent
   - Command palette: type "/" to see available commands (/create-incident, /page-team, /export)

2. **Hypothesis interaction** (in reasoning stream):
   - Skip button: deprioritize this hypothesis
   - Prioritize button: move this hypothesis to the top of the queue
   - Pin as key finding: mark this as important
   - "Tell me more" button: ask agent to go deeper on this hypothesis
   - Challenge button: "I disagree, here's why: ___"

3. **Evidence interaction** (in evidence panel):
   - Click any chart to zoom/drill down
   - Click any entity name to see entity popover
   - Click "Open in [product] →" to navigate to full NR product page
   - Annotate: add a sticky note comment to any widget (for collaboration)

4. **Feedback on conclusion**:
   - Three-button rating: Correct / Partially Right / Wrong
   - If wrong/partial: text field for actual root cause
   - Quality rating: 1-5 stars
   - "What should the agent do differently?": text field
   - This feedback creates a memory entry

5. **Redirect investigation**:
   - "I think you're looking at the wrong thing. Check X instead."
   - Agent acknowledges, adds new hypothesis, adjusts plan
   - User-provided context appears as a distinct card in the reasoning stream

6. **Approve/reject remediation actions**:
   - Low risk: just executes, shows result
   - Medium risk: confirmation dialog with pre-filled details, "Edit before executing" option
   - High risk: full impact assessment panel with risk score, rollback plan, approval button
   - Post-execution: show result ("Rollback successful. Error rate returning to normal." with live chart)

### Design Considerations

- Suggested prompts should be contextual and change based on investigation state. During context gathering: "Add more context about this service". During hypotheses: "Check the database too". After conclusion: "Create an incident for this".
- The @-mention agent feature should feel like Slack's @-mention UX. Type @, see a list of available agents with their current status.
- Challenge/disagree should be encouraged, not hidden. The agent should respond gracefully: "Thanks for the correction. I'll re-evaluate based on your input."

---

## Workstream 6: Action System (P1)

**Everything related to taking action from within the investigation.**

### Screens to Design

1. **Quick action bar** (bottom of canvas):
   - Contextual buttons that change based on investigation state
   - During: Create Incident, Page Team, Share to Slack
   - After conclusion: Rollback, Create Jira, Export Report, Create Post-Mortem
   - Each button shows what it will do on hover (tooltip with preview)

2. **Create Incident flow**:
   - Pre-filled from investigation: title, description, severity, affected services, timeline
   - User can edit before creating
   - Creates in NR Incident Response AND optionally in PagerDuty/Jira/ServiceNow
   - After creation: incident card appears in the investigation

3. **Rollback flow** (high-risk action):
   - Impact assessment panel
   - Shows: what will be rolled back, previous version stability data, estimated recovery time, risk score
   - Approval button with "I understand the risks" checkbox for production rollbacks
   - Live status after approval: "Rolling back... Deployment reverted. Monitoring recovery..."
   - Recovery chart showing metrics returning to normal

4. **Share to Slack flow**:
   - Channel selector
   - Preview of what will be posted (summary card with key findings)
   - Option to share full investigation link or just the summary
   - Thread reply option (if investigation was triggered from Slack)

5. **Create Post-Mortem** (after conclusion):
   - Auto-generates post-mortem from investigation data
   - Template: Timeline, Root Cause, Impact, Resolution, Action Items, Lessons Learned
   - Each section pre-filled, user can edit
   - Export as Markdown, Confluence page, or Google Doc

6. **Create Jira/ticket**:
   - Pre-filled: title, description, priority, labels, affected components
   - Links back to investigation
   - Assignee suggestion based on service ownership

### Design Considerations

- Post-mortem auto-generation is a major differentiator. Nobody else does this well. The investigation already has the timeline, root cause, evidence, and resolution. Converting that into a post-mortem template should be one click.
- Action execution should show live progress. Not just "action triggered." Show: "Rolling back → Pods restarting (3/5) → Health check passing → Recovery complete ✅" with a progress bar.

---

## Workstream 7: Memory & Knowledge Management (P1)

**How customers teach the agent, manage what it knows, and see what it learned.**

### Screens to Design

1. **Memory dashboard** (/ai/memory):
   - Tabs: Learned Patterns, Runbooks, Architecture, Known Noise
   - Per-service grouping
   - Search and filter
   - Each memory item: source, creation date, usage count, accuracy rate, edit/delete

2. **Per-agent memory view**:
   - Click into "DB Agent Memory" to see DB-specific knowledge
   - Baselines (normal query times, pool usage)
   - Known slow queries (expected vs unexpected)
   - Investigation patterns for this domain

3. **Add memory manually**:
   - Form: service, pattern description, applies to which agent(s)
   - Examples and guidance text
   - Preview: "When the agent sees [trigger], it will [behavior]"

4. **Runbook management**:
   - Upload files (PDF, Markdown, text)
   - Link external pages (Confluence, Notion, GitHub wiki, PagerDuty runbook)
   - Preview of extracted knowledge: "We found 5 troubleshooting steps and 3 service references"
   - Edit extracted knowledge if the parsing got something wrong

5. **Architecture context editor**:
   - Free-form text description of system architecture
   - OR visual service map upload (image)
   - OR link to architecture diagram tool
   - Agent uses this to understand dependencies and blast radius

6. **Known noise patterns**:
   - List of patterns: "Nightly batch job 2-3 AM = CPU spike, ignore"
   - Schedule-based: time-of-day, day-of-week
   - Service-based: specific services/alerts that are known noisy
   - Impact: "Matched 14 times, all correctly classified as noise"
   - Toggle active/inactive

7. **Memory effectiveness view**:
   - Which memories are most useful (highest usage + accuracy)
   - Which memories are stale (never used, or accuracy declining)
   - Suggestion: "This pattern hasn't been used in 60 days. Delete?"

### Design Considerations

- Memory should feel like "training a new team member." The language should be warm and approachable, not technical.
- Show the impact of providing memory: "Agents with runbooks are 2x more accurate" (or similar encouragement).
- Allow bulk import: "Upload your team's runbook folder" → agent processes all of them.
- Memory conflicts: what if two memories contradict? Show a warning, let user resolve.

---

## Workstream 8: Multi-Agent Collaboration UX (P1)

**How multiple specialized agents work together visually.**

### Screens to Design

1. **Agent roster bar** (in canvas header):
   - Horizontal strip of agent badges
   - Each badge: icon + name + status dot + current action text
   - Click to expand agent detail popover
   - External agents (PagerDuty, Jira) shown with integration icon

2. **Agent detail popover** (click agent badge):
   - Status, duration, tools used, findings count
   - Memory count for this agent
   - "Re-run analysis" button
   - "View raw output" button

3. **Agent handoff card** (in reasoning stream):
   - Visual: SRE Agent → DB Agent (with arrow)
   - Shows what context is being passed
   - Shows the specialist agent's progress (steps with checkmarks)

4. **Specialist agent findings** (in reasoning stream):
   - Visually distinct from SRE Agent cards (different left-border color, agent icon)
   - Shows which agent produced it
   - Can be expanded to see the agent's full reasoning

5. **Synthesized conclusion** (when multiple agents contribute):
   - Shows which agents contributed
   - "SRE Agent and DB Agent agree: the root cause is..."
   - Evidence from each agent marked with agent badge

6. **Agent-to-agent communication** (for war room mode):
   - Swim lane timeline showing parallel agent work
   - Convergence point where findings merge
   - Human participants shown alongside agents

### Design Considerations

- Keep it simple for single-agent investigations. The agent roster bar should show just "🤖 SRE Agent: Investigating" when only one agent is active. Don't overwhelm with UI elements that aren't relevant.
- Multi-agent UX should feel like a team working together, not a complex system diagram. Think Slack channel with agents, not UML sequence diagram.
- External agents should be clearly labeled as external ("via PagerDuty MCP", "via Jira MCP").

---

## Workstream 9: Investigation List & Search (P1)

**How users find, filter, and manage investigations.**

### Screens to Design

1. **Investigation list page** (/ai/investigations):
   - Two sections: "In Progress" (expandable) and "Completed" (sortable table)
   - Each row: status badge, title, source, service, agent(s), time, duration, initiated by
   - Filters: service, status, source, agent, team, date range, initiated by
   - Search: full-text search across investigation titles and conclusions

2. **Investigation card** (in the list):
   - Compact view: title, status, time, key finding one-liner
   - Expandable: show generated hypotheses, initial finding, conclusion preview
   - Click to open full canvas

3. **Comparison mode**:
   - Select two investigations → view side by side
   - Useful for: "Was this the same as last Tuesday's incident?"
   - Shows: timeline overlap, shared root causes, shared services, different outcomes

4. **Bulk actions**:
   - Select multiple → export as report, share, tag, delete
   - "Mark all as reviewed" for completed investigations

5. **Tags and labels**:
   - User-defined tags on investigations (e.g., "deploy-related", "database", "false-alarm")
   - Auto-tags from agent findings
   - Filter by tag in the list view

### Design Considerations

- This page is the "investigation history." It should answer: "What happened last night?" and "Have we seen this before?"
- Comparison mode is powerful for pattern recognition. Design it as a simple side-by-side with highlighted differences.
- Consider a "Related investigations" section on each investigation canvas: "3 similar investigations in the past 30 days"

---

## Workstream 10: Morning Brief / Proactive Mode (P1)

**The ambient, always-on experience when there is no active incident.**

### Screens to Design

1. **Morning brief page** (/ai/morning-brief):
   - "Good morning" header with date and overnight summary
   - Three sections: Needs Attention, Auto-Resolved, Health Summary
   - Configurable: which services, which time window, what severity

2. **Needs Attention cards**:
   - Proactive findings (memory leaks, capacity trends, anomalies)
   - Each card: finding, trend chart, recommended action, approve/snooze/investigate buttons
   - Severity coloring: red (urgent), yellow (soon), blue (FYI)

3. **Auto-Resolved cards**:
   - Investigations that completed without human intervention
   - Matched known patterns ("nightly batch job noise")
   - One-line summary with "View investigation" link

4. **Health summary**:
   - Grid of top services with sparkline health indicators
   - Color coding: green (healthy), yellow (degraded), red (down)
   - Click any service → opens entity page or starts investigation

5. **Configuration for morning brief**:
   - Which services to monitor
   - What time to generate the brief
   - Where to deliver (in-app, Slack, email)
   - Sensitivity: "Tell me about everything" vs. "Only critical items"

### Design Considerations

- The morning brief should be scannable in 30 seconds. An SRE opening their laptop should know "everything is fine" or "here's what needs attention" immediately.
- Auto-resolved items build trust. They show the agent is working and making correct decisions without human intervention. Highlight the accuracy: "14 auto-resolutions this month, 100% correctly classified."
- Consider a daily/weekly email digest option for managers who don't log into NR daily.

---

## Workstream 11: Notification System (P1)

**How users are notified across the investigation lifecycle.**

### Notification Types to Design

1. **Investigation started** (auto-triggered):
   - In-app: toast notification + badge on AI Agents nav
   - Slack: "🤖 SRE Agent is investigating: {title}" in configured channel
   - Mobile push: "Investigation started for {service}" (if mobile app)
   - Email: optional digest

2. **Investigation complete**:
   - In-app: toast + update badge
   - Slack: summary card posted to thread (root cause, confidence, recommended action)
   - Mobile push: "Root cause found: {one-liner}"
   - Browser notification (if user navigated away)

3. **Action needs approval**:
   - In-app: modal or banner
   - Slack: interactive message with Approve/Reject buttons
   - Mobile push: "Rollback requested for {service} — approve?"

4. **Agent needs help**:
   - When agent is stuck or inconclusive
   - "SRE Agent needs your input on {investigation}" with suggested actions

5. **Proactive finding**:
   - Morning brief delivery
   - Urgent proactive findings: immediate notification
   - Non-urgent: batched in next morning brief

### Design Considerations

- Notification fatigue is a real risk. Default to minimal notifications (investigation complete + action needed only). Let users configure.
- Slack notifications should be actionable: approve/reject buttons inline, not just links.
- Mobile experience: the minimum viable mobile experience is reading investigation conclusions and approving/rejecting actions. Full canvas is desktop-only for V1.

---

## Workstream 12: Accessibility & Responsive Design (P1)

**Making the experience work for everyone.**

### Design Requirements

1. **Keyboard navigation**:
   - Tab through all interactive elements
   - Shortcuts: `Cmd+K` (command palette), `Esc` (close modals), `N` (new investigation)
   - Arrow keys to navigate between hypotheses
   - Enter to expand/collapse

2. **Screen reader support**:
   - Proper ARIA labels on all components
   - Alt text for charts (auto-generated: "Error rate chart showing spike from 0.2% to 4.8% at 3:02 AM")
   - Announce new content as it streams in
   - Investigation status changes announced

3. **Color accessibility**:
   - Don't rely on color alone for hypothesis status (use icons + text alongside color)
   - High contrast mode
   - All charts must have patterns (not just colors) for data series

4. **Responsive breakpoints**:
   - Desktop (> 1400px): full split-pane layout
   - Laptop (1200-1400px): narrower right panel
   - Tablet (768-1200px): stacked layout (toggle between reasoning and evidence)
   - Mobile (< 768px): simplified view (conclusion + key findings only, with link to full canvas on desktop)

5. **Dark mode**:
   - SRE tools are often used at night. Dark mode is not optional, it's default.
   - All components, charts, widgets must work in dark mode
   - Consider auto-switching based on time of day

---

## Workstream 13: Collaboration Features (P2)

**Multi-user interaction during and after investigations.**

### Screens to Design

1. **Presence indicators**:
   - Show who else is viewing this investigation (avatars in header)
   - "Sarah Chen is also viewing" — like Google Docs
   - Cursor presence optional (may be too much for V1)

2. **Comments/annotations**:
   - Click any card or widget to add a comment
   - Comment thread appears as a sidebar or popover
   - @-mention teammates in comments
   - Comments persist on the investigation for post-mortem review

3. **Share investigation**:
   - Generate shareable link (read-only or edit)
   - Share to Slack with summary card
   - Share via email with HTML formatted summary
   - Embed in Confluence or Notion (via iframe or integration)

4. **Investigation handoff**:
   - "Transfer ownership" to another person
   - Add collaborators
   - Notify: "Sarah transferred this investigation to you"

### Design Considerations

- Collaboration is important for SEV-1 incidents where multiple people are investigating. But for most investigations, it's single-user. Design for single-user first, collaboration as progressive enhancement.
- Comments are critical for post-mortems. "Why did we decide to rollback instead of hotfix?" should be captured in the investigation.

---

## Workstream 14: Post-Mortem & Reporting (P2)

**Turning investigations into documentation and insights.**

### Screens to Design

1. **Auto-generated post-mortem**:
   - One-click from completed investigation
   - Template sections, all pre-filled:
     - **Incident Summary**: Auto-generated from conclusion
     - **Timeline**: Every phase with timestamps (from investigation data)
     - **Root Cause**: From conclusion card
     - **Impact**: Services affected, duration, SLO impact, user impact (if available)
     - **Resolution**: Actions taken (from action log)
     - **Action Items**: Suggested by agent + user-added
     - **Lessons Learned**: From feedback + investigation patterns
   - User can edit everything before publishing
   - Export: Markdown, PDF, Confluence, Notion

2. **Investigation report** (export):
   - Full investigation as a document: every hypothesis, every evidence widget, conclusion
   - Chart images (static snapshots of interactive charts)
   - PDF or HTML format
   - Shareable link with read-only view

3. **Trends dashboard** (/ai/reports):
   - Investigation volume over time
   - Top root causes (recurring patterns)
   - MTTR trend (before agent vs. with agent)
   - Agent accuracy trend
   - Most-investigated services
   - Auto-resolution rate trend
   - Agent usage by type (SRE, DB, K8s, etc.)
   - Team-level breakdown

4. **Recurring issue detection**:
   - "This is the 3rd time in 30 days that checkout-service had connection pool exhaustion"
   - Suggest: create a permanent fix, adjust pool config, add monitoring
   - Link to all related investigations

### Design Considerations

- Post-mortem generation is a killer feature. It saves hours of writing and ensures nothing is forgotten. Make it prominent.
- Recurring issue detection helps justify the agent's value: "The agent found this pattern 3 times. If you fix it permanently, you'll prevent future incidents."

---

## Workstream 15: Settings, RBAC & Audit (P1)

**Configuration, permissions, and compliance.**

### Screens to Design

1. **Agent settings page** (/ai/settings):
   - Active agents: toggle SRE, DB, K8s, Infra agents on/off
   - LLM preference: (if configurable)
   - Language: investigation output language
   - Notification preferences
   - Integration connections (Slack, PagerDuty, Jira, GitHub)

2. **Auto-investigate configuration**:
   - Per-monitor toggle (list all monitors, toggle auto-investigate on/off)
   - Bulk toggle: "Enable for all P1 monitors"
   - Rate limit: max investigations per 24 hours (per monitor and org-wide)
   - Exclusions: "Never auto-investigate monitors matching [pattern]"

3. **RBAC / Permissions**:
   - Who can start investigations: all users vs. specific roles
   - Who can approve high-risk actions: admin-only or designated approvers
   - Who can manage memory: team leads vs. all team members
   - Who can view investigation history: role-based filtering
   - Who can configure auto-investigate: admin only

4. **Audit trail**:
   - Every agent action logged: tool calls, handoffs, conclusions, human actions
   - Filterable: by investigation, by agent, by user, by action type
   - Exportable for compliance
   - "Who approved the rollback on Mar 10 at 3:15 AM?" → instant answer

5. **Cost & usage**:
   - Investigation count vs. plan limits (if applicable)
   - Agent usage breakdown
   - Token/compute usage (if consumption-based billing)

---

## Design Execution Order (Recommended)

### Sprint 1-2: Foundation (P0)
Focus: Get the canvas working with a single investigation flow.

| # | Workstream | Deliverable |
|---|---|---|
| 1 | Canvas Layout | Full-page wireframe + responsive breakpoints |
| 2 | Reasoning Stream | Card designs for all 7 phase types |
| 3 | Evidence Widgets | Design for top 6 widgets (golden signals, deployments, traces, logs, alerts, entity map) |
| 4 | Streaming UX | Loading states, skeleton screens, auto-scroll behavior |
| 5 | HITL - Basic | Chat input, hypothesis skip/prioritize, conclusion feedback |

### Sprint 3-4: Richness (P0/P1)
Focus: Make the experience feel complete and polished.

| # | Workstream | Deliverable |
|---|---|---|
| 6 | Action System | Create incident, rollback, share to Slack, page team |
| 7 | Evidence Widgets (remaining) | Connection pool, K8s, infra, config diff, NRQL, comparison |
| 8 | Investigation List | List page, filters, search, tags |
| 9 | Entry Points | All 7 entry points designed (auto-trigger, alert page, APM, Slack, prompt, brief, list) |
| 10 | Notifications | Basic notification types (started, complete, needs approval) |

### Sprint 5-6: Intelligence (P1)
Focus: Memory, multi-agent, and proactive features.

| # | Workstream | Deliverable |
|---|---|---|
| 11 | Memory System | Memory dashboard, per-agent memory, manual add, runbook linking |
| 12 | Multi-Agent UX | Agent roster, handoff cards, specialist findings |
| 13 | Morning Brief | Daily digest page, needs-attention cards, auto-resolved, health summary |
| 14 | Agent Onboarding | First-time setup wizard (4 steps) |
| 15 | Settings & RBAC | Settings page, auto-investigate config, permissions |

### Sprint 7-8: Polish & Advanced (P2)
Focus: Collaboration, reporting, and advanced features.

| # | Workstream | Deliverable |
|---|---|---|
| 16 | Post-Mortem Generation | One-click post-mortem with auto-filled template |
| 17 | Reports Dashboard | Effectiveness metrics, MTTR trends, recurring issues |
| 18 | Collaboration | Presence, comments, share, handoff |
| 19 | Comparison Mode | Side-by-side investigation comparison |
| 20 | Accessibility | Full keyboard nav, screen reader, dark mode, responsive |

---

## Appendix: Competitive Comparison (What to Beat)

| UX Element | Datadog Bits AI SRE | Our Investigation Canvas | Delta |
|---|---|---|---|
| Layout | Split pane (chat + tree) | Split pane (reasoning + evidence) | Similar structure, different content |
| Tree visualization | Post-completion tree | **Live streaming canvas** | We stream in real-time, they show after |
| Hypothesis display | Collapsible nodes in tree | **Interactive cards with skip/prioritize/challenge** | We let users steer, they just show results |
| Evidence rendering | Embedded images/links | **Native interactive widgets** (charts, flame graphs) | Our evidence is interactive, theirs is static |
| Specialist agents | Single agent only | **Multi-agent with visible handoffs** | We show collaboration, they hide complexity |
| Memory | bits.md + feedback memories | **Visual memory dashboard + per-agent memory** | Our memory is richer and more manageable |
| Onboarding | bits.md (markdown file) | **Visual wizard + runbook linking + Confluence** | Lower friction for non-technical users |
| Actions | Chat commands only | **Risk-tiered action cards with impact assessment** | Our actions are safer and more transparent |
| Post-mortem | None | **One-click auto-generated post-mortem** | They don't have this at all |
| Morning brief | None (auto-investigate exists) | **Full daily digest with proactive detection** | They don't have this at all |
| Mobile | No mobile experience | **Read + approve on mobile** | They don't have this |
| Collaboration | Single-user only | **Multi-user with presence + comments** | They don't have this |
| Reports | Investigation count only | **Full effectiveness dashboard with MTTR trends** | Ours is much richer |
| Entry points | 5 (monitor, status, event, Slack, prompt) | **7 (+ APM graph selection, morning brief)** | Two extra entry points |
| Third-party data | Grafana, Dynatrace, Splunk, Sentry, ServiceNow, Confluence | **Via MCP: any tool** | We're more extensible |

---

## What to Prototype First

If you're going to vibe code a prototype, start with these screens in this order:

1. **Investigation canvas** with hardcoded data (left reasoning + right evidence)
2. **Hypothesis cards** with all 5 states (queued, testing, validated, invalidated, skipped)
3. **3 evidence widgets** (golden signals chart, log snippet, trace flame graph)
4. **Conclusion card** with feedback buttons
5. **Streaming simulation** (content appearing progressively with animations)

These 5 screens demonstrate the core experience and can be shown to Camden, the engineering team, and eventually customers for feedback.
