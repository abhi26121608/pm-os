---
name: capture-learnings
description: Capture session learnings, update learning log, and suggest rule improvements
---

## Quick Start

1. Run `/capture-learnings` at the end of any significant session
2. I will analyze the conversation for corrections, feedback, and patterns
3. I will update `context-library/pm-os-learning-log.md` with session entry
4. If patterns repeat (2+ times), I'll suggest promoting them to rules
5. Optionally update `.claude/rules/` files directly

**Best practice:** Run this whenever you corrected my behavior or noticed something that should be different next time.

## Purpose

Continuous improvement system for PM-OS. Captures what went well, what needed correction, and promotes patterns to auto-loaded rules so mistakes don't repeat.

## Usage

- `/capture-learnings` - Analyze current session
- `/capture-learnings "specific feedback"` - Add specific learning you want captured
- `/capture-learnings review` - Review learning log and suggest rule promotions

---

## Context Routing

**Check these files:**
1. `context-library/pm-os-learning-log.md` - Existing learnings and patterns
2. `.claude/rules/` - Current rules to potentially update
3. Current conversation - Analyze for corrections and feedback

**No MCP needed** - this skill works entirely from conversation analysis and local files.

---

## Workflow

### Step 1: Analyze Current Session

Scan the conversation for:

**Explicit Corrections:**
- User said "you should have..." or "why didn't you..."
- User had to repeat a request differently
- User pointed out missing information
- User expressed frustration or correction

**Implicit Signals:**
- User did something themselves that I should have done
- User provided context I should have found
- Requests that required multiple attempts
- Tasks where user had to guide step-by-step

**Positive Patterns:**
- What worked well (to reinforce)
- Tasks completed efficiently
- Good proactive behavior

**Extract for each correction:**
```
- What happened (observation)
- What user said/did (feedback)
- What should have happened (learning)
- Category: [research | communication | proactivity | tool-use | other]
```

---

### Step 2: Check for Pattern Repetition

Read `context-library/pm-os-learning-log.md`

For each new learning, check:
- Has this pattern been observed before?
- How many times? (frequency count)
- Is it already in a rules file?

**Pattern matching:**
- Same category of mistake
- Same type of task
- Same user correction

**Threshold for rule promotion:**
- 2+ occurrences: Suggest promoting to rules
- 3+ occurrences: Strongly recommend rule creation
- Already in rules but repeated: Rule needs strengthening

---

### Step 3: Update Learning Log

Append to `context-library/pm-os-learning-log.md`:

```markdown
## Session: [Date] - [Brief Topic Description]

### Context
[1-2 sentence description of what was being worked on]

### Corrections Received

#### 1. [Title]
**Observation**: [What happened]
**User Feedback**: "[Quote if available]"
**Learning**: [What should be done differently]
**Category**: [research | communication | proactivity | tool-use | other]
**Action**: [Rule created? File updated? Noted for future?]

[Repeat for each correction]

### What Worked Well
- [Positive pattern to reinforce]

### Patterns Identified
| Pattern | Frequency | Rule Created? |
|---------|-----------|---------------|
| [Pattern] | [X sessions] | [Yes/No/Suggested] |

### User Preferences Noted
- [Any preferences expressed]
```

---

### Step 4: Suggest or Create Rules

**If pattern frequency >= 2:**

Present to user:
```
I've noticed this pattern [X] times:
- [Date 1]: [Brief description]
- [Date 2]: [Brief description]

Suggested rule:
[Draft rule text]

Options:
1. Add to existing rules file: `.claude/rules/[relevant-file].md`
2. Create new rules file: `.claude/rules/[new-topic].md`
3. Just log it for now (don't create rule yet)
```

**If user approves:**
- Update or create the appropriate rules file
- Update learning log to mark "Rule Created: Yes"
- Update the Rules Promotion Tracker table

---

### Step 5: Generate Summary

Output to user:

```markdown
## Session Learnings Captured

### Corrections Logged: [X]
1. **[Learning 1]** - [Brief description]
2. **[Learning 2]** - [Brief description]

### Rules Updated: [Y]
- `.claude/rules/[file].md` - Added [description]

### Patterns Approaching Threshold:
- **[Pattern]** - [N-1] more occurrence before rule suggestion

### Learning Log Updated
See: `context-library/pm-os-learning-log.md`

---

*Run `/capture-learnings review` periodically to review accumulated patterns.*
```

---

## Review Mode

When user runs `/capture-learnings review`:

### Step 1: Analyze Learning Log

Read `context-library/pm-os-learning-log.md`

Calculate:
- Total sessions logged
- Patterns by frequency
- Categories with most corrections
- Rules created vs pending

### Step 2: Generate Review Report

```markdown
## PM-OS Learning Review

### Summary Statistics
- **Sessions logged:** [X]
- **Total corrections:** [Y]
- **Rules created:** [Z]
- **Patterns pending promotion:** [A]

### Top Correction Categories
| Category | Count | % of Total |
|----------|-------|------------|
| Research | X | Y% |
| Proactivity | X | Y% |
| Tool-use | X | Y% |

### Patterns Ready for Rule Promotion (2+ occurrences)

#### 1. [Pattern Name]
**Occurrences:** [X]
**Sessions:** [List of dates]
**Suggested Rule:**
```
[Draft rule text]
```
**Relevant rules file:** `.claude/rules/[file].md`

**Action:** [Create rule] [Skip] [Need more data]

### Recently Created Rules
| Rule | Created | File | Working? |
|------|---------|------|----------|
| [Rule] | [Date] | [File] | [Yes/No/Unknown] |

### Recommendations
1. [Specific recommendation based on patterns]
2. [Another recommendation]
```

---

## Rule Categories

When creating rules, categorize appropriately:

| Category | Rules File | Examples |
|----------|------------|----------|
| Research behavior | `research-behavior.md` | Link following, folder exploration |
| MCP usage | `mcp-routing.md` | Atlassian, Jira, tool selection |
| Writing style | `writing-style.md` | Tone, formatting, banned words |
| File organization | `file-organization.md` | Where to save outputs |
| Workflows | `workflows.md` | Process sequences |
| Communication | `communication.md` (new) | How to interact with user |

---

## Learning Categories Reference

When categorizing corrections:

| Category | Description | Example |
|----------|-------------|---------|
| **research** | Didn't find information that existed | Missed PM-OS folder, didn't follow links |
| **proactivity** | Waited when should have acted | Asked permission instead of doing |
| **tool-use** | Used wrong tool or missed capability | Should have used parallel calls |
| **communication** | Miscommunicated or misunderstood | Wrong tone, too verbose, unclear |
| **output-quality** | Output didn't meet expectations | Missing sections, wrong format |
| **context** | Missed relevant context | Didn't check related files |

---

## Integration with Other Skills

**After any skill:**
- If user corrected behavior, run `/capture-learnings`

**Periodic:**
- Weekly: Run `/capture-learnings review` to check accumulated patterns
- Monthly: Review and clean up learning log

**Related skills:**
- `/weekly-review` - May surface learnings about PM-OS usage
- All skills - Can trigger learnings capture

---

## Tips for Best Results

**When to run:**
- End of any session where you received corrections
- After complex multi-step tasks
- When you notice "I should remember this for next time"

**What makes good learnings:**
- ✅ Specific and actionable
- ✅ Includes the "why" not just the "what"
- ✅ Connected to a category
- ❌ Vague ("do better")
- ❌ One-off situations unlikely to repeat

**Building the habit:**
- I'll occasionally prompt "Want me to capture learnings from this session?"
- Over time, patterns emerge that make PM-OS smarter

---

## Output Quality Self-Check

Before completing:

- [ ] **Each correction has all fields:** Observation, feedback, learning, category, action
- [ ] **Patterns checked against history:** Verified if this is new or repeated
- [ ] **Learning log updated:** New entry appended with correct format
- [ ] **Rules suggested when appropriate:** 2+ occurrences triggers suggestion
- [ ] **User has clear next steps:** Know what was captured and what actions taken
