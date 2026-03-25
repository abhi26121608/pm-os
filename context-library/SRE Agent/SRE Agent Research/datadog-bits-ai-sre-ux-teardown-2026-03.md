# Datadog Bits AI SRE: Complete UI/UX Teardown

**Date:** March 2026
**Sources:** 77 demo screenshots (Mar 10, 2026), 48-min video transcript (Observability Guru YouTube), Datadog product pages, docs
**Demo app:** CARBOOK (car rental app on EC2 with api-gateway, car-service, location-service, reservation-service + MySQL)
**Screenshot location:** `context-library/research/Datadog BITS AI SRE DEMO Screenshots/`
**Transcript:** `BITS AI SRE Datadog Demo Transcripts.pdf` (same folder)

---

## 1. Page Layout & URL Structure

- **URL pattern**: `us5.datadoghq.com/bits-ai/investigations/{uuid}?v=tree`
- **Nav location**: "Bits AI" is a top-level item in the left sidebar, directly below "Recent"
- **Core layout**: Split-pane. Left panel = chat/conversation (~45%). Right panel = investigation tree/visual flowchart (~55%).
- The `?v=tree` query param controls the tree view toggle
- Full-page experience (not a side panel or overlay)

---

## 2. Header Bar

| Element | Details |
|---|---|
| Back arrow (←) | Returns to investigation list |
| Status badge | `Investigating` (blue), `Conclusive` (green), `Inconclusive` (yellow) |
| Timing | "Started [time]" during investigation. "Completed in 2m", "Finished 5m ago" after. |
| Title | Auto-generated from root cause. Updates dynamically when investigation concludes. |
| Source | Shows trigger: "Source: Monitor" + "Initiated by @[username]" |

**Title behavior:**
- While investigating: "API Gateway Error Spike" (from monitor name)
- After conclusion: "API Gateway errors caused by connection refused to 44.204.119.253:9003 backend"
- Another example: "API Gateway latency spike caused by car-service repository layer delay, not MySQL"
- Title becomes the actual root cause finding, very specific

---

## 3. Feedback Banner (Persistent, Top-Right)

- **Yellow/orange banner**: "Review and Help Bits Learn"
- **Question**: "Did Bits find the root cause?"
- **Two buttons**: `✓ Yes` (green) | `✗ Not Quite` (red with X)
- **Dismissible** via X button
- This is the ONLY feedback mechanism. Binary choice, no text input, no granular rating.
- Appears on every completed investigation
- Feeds into Bits AI's learning system

---

## 4. Right Panel: Investigation Tree (Visual Flowchart)

This is Datadog's signature UI element. A vertical flowchart that visualizes the entire investigation process as a tree of nodes connected by arrows.

### Tree Structure (Top to Bottom):

**Node 1: SOURCE: MONITOR ALERT** (orange-bordered card)
- Alert name displayed (e.g., "API Gateway Error Spike")
- Small embedded line chart showing the triggering metric
- Settings gear icon (⚙) for configuration
- Orange/coral colored header

**Arrow down to three parallel cards:**

**Node 2a: RUNBOOK** (orange label)
- "Checking the monitor message for any telemetry links you've included"
- Shows: "Bits took 3 steps" with green checkmark
- If no runbook: still checks but finds nothing

**Node 2b: MEMORY** (orange label)
- "Recalling past investigations from memory"
- Shows: "Bits took 1 step" or "No memories found"
- Recalls relevant past investigations from same account

**Node 2c: GENERAL SEARCH** (orange label)
- "Scanning your environment broadly for issues"
- Shows: "Bits took 6 steps" with green checkmark
- Scans across the entire Datadog environment

**"Summarizing..." node** (during active processing, disappears when done)

**Node 3: INITIAL FINDINGS** (blue-bordered card)
- Bullet-point summary of what was found
- Example: "High latency in location-service blocks api-gateway GET /api/locations/ by 3.32s, mainly in LocationRepository.findAll (2.65s), no errors"
- Second bullet: "High latency in car-service GET /api/cars/ with 5.71s wait, CarRepository.findAll takes 4.12s, MySQL query only 145ms, no errors"

**"Finished in 1 minute"** label between sections

**Node 4: HYPOTHESIS INVESTIGATION** section
- Header: "HYPOTHESIS INVESTIGATION"
- Main hypothesis card:
  - Teal/green border when validated
  - Title: e.g., "Connection Refused to Ba..."
  - Subtitle: "API Gateway errors caused by backend connection refusals"
  - Green circle (●) indicator for validated

**Child hypothesis cards** (branching below main):
- "Port blocking firewall" / "Found blocking port 9003, causes connection failures"
- "Backend service down" / "Backend service on port 9003 is down"
- "Network connectivity issue" / "Network connectivity issue, blocking specific ports"
- Each shows a brief evidence summary
- Color-coded by status (green = validated, yellow = inconclusive, etc.)

**Node 5: INVESTIGATION CONCLUSION** (bottom card, larger)
- Full root cause title with copy icon (📋)
- Bullet points summarizing evidence:
  - "Error from connection refused to specific IP port"
  - "Includes detailed trace and timing evidence matching alert"
  - "Identifies technical failure, not just alert signal"

### Hypothesis Legend (Top-Right of Tree Panel)

| Icon | Status |
|---|---|
| ✅ Green checkbox | Validated |
| 🟨 Yellow checkbox | Inconclusive |
| ❌ Red checkbox (strikethrough) | Invalidated |

### Tree Interaction Controls (between panels)
- **+** Zoom in
- **-** Zoom out
- **📌** Pin/lock view
- Tree is scrollable and pannable

---

## 5. Left Panel: Chat Interface

### Message Types

**Bits AI messages** (robot avatar):
- Conversational text, NOT structured cards
- "I'm currently summarizing the initial investigation. Anything I can help with in the meantime?"
- "I've wrapped up my investigation. Where should we focus next?"
- Root cause explanations with **bold keywords** and **entity badges** inline (e.g., `🟢 api-gateway`)

**Follow-up suggestions** (clickable text, appear after investigation completes):
- "Have there been similar past incidents involving MySQL connectivity failures for car-service or reservation-service?"
- "Were there any recent deployments or config changes to car-service or location-service before the latency spike?"
- "Create an incident for the API gateway connection reviews?"
- "How can I make the investigation more effective next time?"

**Code blocks** (when remediation is discussed):
```
java -jar /path/to/location-service-0.0.1-SNAPSHOT.jar &
./start-location-service.sh
```
After starting, verify:
```
ps aux | grep location-service-0.0.1-SNAPSHOT.jar
ss -tlnp | grep 9003
```
To prevent recurrence:
```
dmesg | grep -i "oom|killed" | tail -20
```

**Recommended next steps** (numbered list in chat):
1. Enable Continuous Profiler on `car-service`
2. Check for N+1 query patterns
3. Review the ORM mapping for the `Car` entity
4. Add custom instrumentation around the repository method

**Pattern recognition** (when Bits finds patterns):
- "A similar latency pattern was also found in `location-service` with `LocationRepository.findAll` (2.65s), suggesting this could be a systemic issue across services."
- Links hypothesis data inline

**Limitations communicated honestly:**
- "I don't have the ability to SSH into hosts or check running processes on 44.204.119.253. My capabilities are limited to querying Datadog telemetry: logs, traces, metrics, and performing actions."
- "Unfortunately, the incident creation action keeps failing because your Datadog organization requires a description field that isn't supported as a configurable parameter in the available action."
- Suggests alternatives: "Here's what I can do instead: Check recent logs/traces, Page your on-call team, Send a Slack message"

### Reaction Buttons (on each message)
- 👍 (thumbs up)
- 👎 (thumbs down)
- 📋 (copy message)

---

## 6. Chat Input Bar (Bottom)

| Element | Details |
|---|---|
| Text input | "Chat with Bits..." placeholder |
| Send button | Arrow icon (↑) |
| Run Action button | "⚡ Run Action" - triggers Datadog Actions |
| Run Workflow button | "🔄 Run Workflow" - triggers Datadog Workflow Automation |

---

## 7. Actions System

### "Run Action" Capabilities
When user asks to create an incident, Bits shows an expandable action card:

```
┌─ Create Incident ──────────────────────── ▶ ∧ ─┐
│ Create incident 🔧 incident with severity      │
│ [empty] and assign [empty] as incident commander│
│                                                  │
│ > Inputs                                         │
└──────────────────────────────────────────────────┘
```

- Play button (▶) to execute
- Expandable inputs section
- If it fails, Bits explains error and suggests alternatives:
  - "Create a Datadog Case"
  - "Page the on-call"

### Known Action Types (from demo)
- Create Incident
- Create Datadog Case
- Page on-call team
- Send Slack message
- Run Workflow (connects to Datadog Workflow Automation)

### Limitation Observed
- Actions can fail if organization has required fields not supported by the action configuration
- Bits retries once, then offers alternatives
- "It's like a team member right? It might make mistake, will identify the mistake and then it will just try to fix it by itself"

---

## 8. Investigation Triggers

| Trigger | How |
|---|---|
| From Monitor alert page | Click alert -> "Bits AI" button -> "Investigate" |
| From Bits AI nav | Navigate to Bits AI -> manual investigation |
| Auto-investigate | Per-monitor toggle (when enabled, fires automatically on alert) |
| Multiple simultaneous | Can run multiple investigations in parallel on different alerts |

---

## 9. Investigation Process Flow (from transcript)

1. **Alert fires** (from monitor)
2. **Bits consumes the payload** - understands alert details
3. **Initial analysis starts**:
   a. Checks **runbook** details (from alert body, embedded links)
   b. Checks **memory** (past investigations)
   c. Does a **general search** (environment-wide scan)
4. **Comes up with initial finding** - summary of what's happening
5. **Creates hypotheses** - failure scenarios identified
6. **Validates hypotheses** - uses telemetry data (logs, traces, metrics) to validate/invalidate each
7. **Reaches conclusion** - root cause with evidence
8. **Provides follow-up options** - fix suggestions, incident creation, next steps
9. **Total time**: ~2-4 minutes typical

---

## 10. Memory System

- Bits recalls past investigations from the same account
- Shows in tree: "MEMORY: Recalling past investigations from memory"
- If first time using: "No memories found"
- Learns from feedback (Yes/Not Quite on root cause)
- No visible memory management dashboard (unlike our planned design)
- `bits.md` file mentioned in docs for providing context (markdown file)

---

## 11. Observed UX Issues & Limitations (from demo presenter)

1. **Scrolling issues**: "Sometimes this UI issue happens where it's sometimes a little difficult to go up"
2. **No SSH capability**: Can't check host processes, limited to Datadog telemetry
3. **Action failures**: Incident creation fails if org requires fields not in action config
4. **Context dependency**: "If you want to get the best out of Bits AI SRE, you definitely have to update more detail in the monitor providing more context"
5. **Shallow investigations**: Some investigations don't go deep enough ("it was uh didn't go into the deep")
6. **No prevention recommendations**: Finds root cause and suggests fix, but doesn't tell you how to prevent recurrence with alerts/instrumentation
7. **No business impact**: No revenue/business metric correlation
8. **Single agent**: No specialist sub-agents (DB agent, K8s agent, etc.)
9. **Presenter verdict**: "I wouldn't say like you know it's perfect but I think it's in the right direction"

---

## 12. Tips for Getting Best Results (from demo)

- Put detailed context in monitor alert body (not just title)
- Link Confluence pages or runbooks to alerts
- Use proper service tagging
- Provide microservice architecture details in alert body
- "Treat it as a new team member: start training it, provide runbook, tell it what your application is doing"
- Tag logs to proper services
- More context = better root causes

---

## 13. Key Design Patterns

| Pattern | Implementation |
|---|---|
| Investigation visualization | Vertical tree/flowchart (unique to Datadog) |
| Primary interaction | Chat-first (left panel) |
| Evidence display | Text descriptions with inline entity badges, not interactive charts |
| Status communication | Badge + timing in header |
| Feedback loop | Binary Yes/Not Quite (minimal) |
| Remediation | Code snippets in chat (copy-paste, not one-click execute) |
| Transparency | Tree shows process steps but not real-time (shows after completion) |
| Error handling | Honest about limitations, suggests alternatives |

---

## 14. What Datadog Does NOT Have (as of Mar 2026)

- No interactive evidence widgets (charts, flame graphs in investigation)
- No hypothesis skip/prioritize by user
- No human steering during investigation
- No morning brief / proactive mode
- No prevention recommendations
- No business impact correlation
- No multi-agent visible collaboration
- No post-mortem generation
- No investigation comparison mode
- No memory management dashboard
- No granular feedback (only Yes/Not Quite)
- No auto-remediation execution (suggests only)
- No mobile experience
