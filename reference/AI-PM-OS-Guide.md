# AI PM OS Guide - Complete Reference

Source: Aakash Gupta's PM Operating System Guide (Feb 2026)

---

## Overview

The PM OS is a Claude Code setup designed for Product Managers to automate and accelerate PM workflows. It includes:

- **CLAUDE.md** - Master context file (Claude reads this first)
- **context-library/** - Company info, writing styles, stakeholders
- **.claude/skills/** - 41+ custom commands for PM tasks
- **sub-agents/** - 7 AI reviewers (engineer, designer, exec, legal, UXR, skeptic, customer voice)
- **templates/** - Launch checklists, roadmaps, OKRs, retros

---

## 1. Installation

### Step 1: Install Claude Code
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

### Step 2: Open in Cursor (Recommended)
- Download Cursor at cursor.sh
- File > Open Folder > select PM OS folder
- Set up 3-pane view: file explorer (left), file preview (top-right), terminal (bottom-right)

### Step 3: Start Claude Code
```bash
claude --dangerously-skip-permissions
```
> Use this flag to skip permission prompts for faster workflow. Only use when you trust the tasks.

### Step 4: Initialize
```
init
```
Claude will read CLAUDE.md and guide you through setup.

---

## 2. Context Setup (Critical)

Fill out these files in `context-library/`:

### Required Context Files
1. **business-info.md**
   - Company name and product
   - Target users
   - Main competitors
   - Key metrics
   - Current priorities
   - Product strategy

2. **personal-context-pm-background.md**
   - Your role and experience
   - What you own

3. **personal-context-working-preferences.md**
   - How you like to work
   - Communication style

4. **stakeholder profiles** (in `stakeholders/`)
   - Key people you work with
   - What they care about
   - How to communicate with them

### Pro Tip
Don't fill templates manually. Dictate context to Claude:
```
I'm VP of PM for Growth which includes pricing, activation, information architecture, expansion.
Each team has OKRs: pricing is drive 10% ARR growth...
Key stakeholders are CEO Tim, CPO Shek, CRO Becky, CMO David
```
Claude will fill in the context files automatically.

---

## 3. GitHub Sync

1. Click branching icon in Cursor's file explorer
2. Create new repo at github.com
3. Copy the git commands and paste in terminal
4. Authorize Visual Studio Code when prompted

**Benefits:**
- Version control for your PM OS
- Kick off Claude Code tasks from phone via Claude app
- Share setup with teammates

---

## 4. MCP Setup (Data Integrations)

Connect Claude Code to your data sources:

```
/connect-mcp (tool name)
```

### Recommended MCPs
- **Product Analytics**: Amplitude, Pendo, PostHog
- **Support Tickets**: Zendesk, Intercom
- **User Research**: Dovetail, Enterpret
- **Business Intelligence**: Tableau, Looker
- **Calendar/Email**: Google Calendar
- **Project Management**: Linear, Jira

### Example: PostHog Setup
1. Get API key from Settings > Project > Project API Keys
2. Tell Claude:
```
Add PostHog MCP to my config with API key phx_[YOUR_KEY] and host https://us.posthog.com
```

---

## 5. Top 9 Use Cases

### Category 1: Automation

#### Use Case 1: Meeting Writeups
```
/meeting-notes @[drag file from explorer]
```
Outputs: Formatted meeting notes with extracted action items

**Why PM OS > generic AI note-takers:** Your PM OS has company context, trained to think like a PM

#### Use Case 2: Competitive Intelligence
```
/competitor-analysis [competitor name]
```
Outputs: Feature comparison matrix, positioning map, strategic recommendations

---

### Category 2: Discovery

#### Use Case 3: Analyze Customer Data
After MCP setup:
```
"What's our WAU growth week-over-week?"
"Show me the signup funnel conversion rates"
"Pull NPS data from last quarter"
```

Then:
```
create an executive summary of our key metrics this month
```

#### Use Case 4: Process User Interviews
```
Transcribe this interview recording and save the output into a customer interview markdown file within context-library (do not synthesize yet)
```

Then:
```
/user-interview for [point to file]
```

Outputs:
- Key observations
- Frequency counts across users
- Pattern identification
- Direct quotes
- Severity ratings

#### Use Case 5: Synthesize Customer Feedback
```
/user-research-synthesis for [point to location]
```

For multi-source synthesis:
```
Synthesize across these sources:
- [Point to interview transcripts]
- [Point to survey responses]
- [Point to support ticket export]
- [Point to NPS location]

Find patterns across all sources and prioritize by signal strength.
```

Outputs:
1. Executive Summary (1 page)
2. Full Synthesis Report
3. Quote Bank (for PRDs)
4. Research Archive

---

### Category 3: Building Features

#### Use Case 6: Creating PRDs
```
/prd-draft [describe feature, point to relevant docs]
```

Use `@` to reference meeting notes and context files.

**Generated PRD includes:**
- Hypothesis
- Strategic Fit
- Non-Goals
- Metrics
- Rollout plan
- Behavior Examples

Then run multi-perspective reviews:
```
Review this PRD from the perspective of an engineer, designer, executive, legal advisor, UX researcher, skeptic, and customer voice. Use the sub-agents in sub-agents/ for each perspective.
```

#### Use Case 7: Creating Linear Tickets
```
/meeting-cleanup extract action items from: [paste meeting notes]
```

Then:
```
/create-tickets Create Linear tickets for each of these action items with proper titles, descriptions, priority levels, and effort estimates: [paste action items]
```

#### Use Case 8: Explore Solution Space (Prototyping)
```
/napkin-sketch Create an interactive prototype of [feature]:
- [Describe key flows]
- [List main components]
- Make it functional enough to click through

Use React and Tailwind. Make it look modern.
```

Refine:
```
Make these changes:
1. Move search bar to top right
2. Add bulk actions (select multiple)
3. Make priority labels more prominent
```

Collect feedback:
```
/prototype-feedback
I have a prototype ready for user testing: [link]
Help me create:
1. User testing script
2. Interview questions
3. Feedback collection form
```

---

### Category 4: Strategy Docs

#### Use Case 9: Creating Strategy Docs
```
/strategy-sprint
Create a quarterly roadmap for: [describe product/initiative]
```

Then get executive review:
```
Read sub-agents/executive-reviewer.md and review this roadmap for strategic alignment, ROI, and risk.
```

---

### Category 5: Building as a PM

#### Use Case 10: Code First Draft Yourself
```
/code-first-draft Build the feature defined in [PRD file]
```

Outputs: Production-ready full-stack implementation with tests

#### Use Case 11: Ralph Wiggum Technique (Autonomous Loops)
```
/ralph-wiggum Build the feature defined in [PRD file]
```

**What it is:** Autonomous iterative loop that keeps working until task is complete

**How it works:**
- Runs Claude Code in continuous loops
- Learns from each failure
- Uses error logs, test results, git history to self-correct
- Continues until success criteria met

**When to use:**
- Building dashboards/prototypes from scratch
- Generating complete PRDs with all reviews
- Multi-step workflows with clear completion criteria
- Overnight automation (start before bed)

**Prevent infinite loops:**
- Define clear success criteria: `output <promise>COMPLETE</promise> when done`
- Set `--max-iterations 30`

---

## 6. Other Use Cases

### Internal Comms
```
/status-update (topic)
```

### Product Launch
```
Create product launch plan for [feature/product name]

Launch details:
- Launch date: [Date]
- Type: [Soft launch / Beta / Full launch / Staged rollout]
- Target audience: [Who gets it first]
- Success metrics: [From PRD]

Generate:
1. Launch checklist (Eng, Design, Marketing, Sales, Support, Legal)
2. Go-to-market timeline (T-2 weeks to T+2 weeks)
3. Internal announcement draft
4. Customer-facing materials needed
```

---

## 7. Pro Tips

1. **Use dictation** - Talk to Claude Code like a colleague (use Speechify)
2. **Gossip to Claude** - Keep it updated on context ("You won't believe what happened in my stakeholder meeting...")
3. **Plan mode for complex tasks** - Use `Shift+Tab` to review plan before execution
4. **Multiple instances** - Run 2-3 sessions in parallel for different initiatives
5. **Clear context when switching** - Use `/clear` for new topics

---

## 8. Claude Code Basics

### Essential Commands

| Command | Purpose |
|---------|---------|
| `/clear` | Reset conversation, start fresh |
| `/context` | See what files Claude has loaded |
| `/model` | Switch between Opus/Sonnet/Haiku |
| `ESC` | Cancel current action |
| `Shift+Tab` | Enter Plan mode (review before execute) |

### Model Selection
```
/model haiku    # Fast, cheap - transcription cleanup, bulk ops
/model sonnet   # Balanced - most PM workflows (default)
/model opus     # Powerful - complex PRDs, deep analysis
```

**Cost optimization workflow:**
```
/model haiku
"Clean up this meeting transcript and format as markdown"

/model sonnet
"Now synthesize insights and create action items"

/model opus
"Review this PRD from 7 different perspectives using sub-agents"
```

### Check Usage
```
claude --usage
```

---

## 9. Sub-Agents (7 Reviewers)

Located in `sub-agents/`:

| Agent | File | Purpose |
|-------|------|---------|
| Engineer | engineer-reviewer.md | Technical feasibility, architecture |
| Designer | designer-reviewer.md | UX, visual design, accessibility |
| Executive | executive-reviewer.md | Strategic alignment, ROI |
| Legal | legal-advisor.md | Compliance, privacy, risk |
| UXR | uxr-reviewer.md | Research validity, user insights |
| Skeptic | skeptic-reviewer.md | Devil's advocate, assumptions |
| Customer Voice | customer-voice.md | End-user perspective |

**Usage:**
```
Read sub-agents/engineer-reviewer.md and review this PRD from an engineering perspective: [paste PRD]
```

Or all at once:
```
Review this PRD from the perspective of an engineer, designer, executive, legal advisor, UX researcher, skeptic, and customer voice. Use the sub-agents in sub-agents/ for each perspective.
```

---

## 10. Debugging & FAQ

### Installation Issues

**Claude Code won't install:**
```bash
sudo curl -fsSL https://claude.ai/install.sh | bash
```
- Windows: Use WSL2
- Check corporate firewall

**"init" doesn't work:**
```bash
cd ~/pm-operating-system
claude "Read README.md and run the init command"
```

### Permission Issues

**Keep asking for permissions:**
```bash
claude --dangerously-skip-permissions
```

### Context Issues

**Claude doesn't remember context:**
- Ensure context saved to `context-library/`
- Start each session: `claude "Read CLAUDE.md and load my context"`
- Keep one long-running session vs fresh starts

**Claude "forgets" mid-conversation:**
- Hit context window limit
- Use `/clear`, re-load essential context
- Save progress to markdown files regularly

### Output Quality Issues

**PRDs too generic:**
- Fill out context library more
- Add examples to `context-library/example-prds/`
- Be more specific in prompts

**Sub-agent reviews shallow:**
- Load sub-agent file AND PRD in same prompt
- Ask for specific feedback areas
- Run reviews one at a time for deeper analysis

### Ralph Wiggum Issues

**Keeps running forever:**
- Define clear success criteria
- Set `--max-iterations 30`
- Use `Ctrl+C` to kill

---

## 11. Time Savings Reference

| Task | Before | After |
|------|--------|-------|
| PRD Creation | 4-8 hours | 30-90 minutes |
| User Interview Processing | 2-3 hours | 15 minutes |
| Meeting Cleanup | 2 hours | 5 minutes |
| User Research Synthesis | 6-8 hours | 30 minutes |
| Launch Coordination | 5-8 hours | 1-2 hours |
| Strategy Docs | 2-3 days | 2-3 hours |

---

## 12. Skills Quick Reference

### Automation
- `/meeting-notes` - Transform meeting transcripts to action items
- `/meeting-cleanup` - Extract action items
- `/status-update` - Internal comms drafts
- `/competitive-intel-weekly` - Competitor monitoring

### Discovery
- `/user-interview` - Process interview transcripts
- `/user-research-synthesis` - Synthesize across sources
- `/competitor-analysis` - Deep competitive analysis

### Building
- `/prd-draft` - Generate PRD with hypothesis, metrics, rollout
- `/create-tickets` - Batch create Linear/Jira tickets
- `/napkin-sketch` - Quick prototypes
- `/prototype-feedback` - User testing scripts

### Strategy
- `/strategy-sprint` - Roadmaps and strategy docs
- `/feature-results` - Post-launch analysis

### Advanced
- `/ralph-wiggum` - Autonomous completion loops
- `/code-first-draft` - Generate working code from PRD

---

## 13. File Structure

```
pm-operating-system/
├── CLAUDE.md                    # Master context (read first)
├── README.md                    # Setup guide
├── setup/
│   ├── installation-guide.md
│   ├── environment-keys.md
│   └── first-session-checklist.md
├── context-library/
│   ├── business-info.md
│   ├── personal-context-*.md
│   ├── stakeholders/
│   ├── writing-styles/
│   └── example-prds/
├── .claude/
│   └── skills/                  # 41+ slash commands
├── sub-agents/
│   ├── engineer-reviewer.md
│   ├── designer-reviewer.md
│   ├── executive-reviewer.md
│   ├── legal-advisor.md
│   ├── uxr-reviewer.md
│   ├── skeptic-reviewer.md
│   └── customer-voice.md
├── templates/
│   ├── launch-checklist.md
│   ├── roadmap-template.md
│   ├── okr-template.md
│   └── retrospective-template.md
└── outputs/                     # Generated artifacts
```
