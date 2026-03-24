# Self-Updating Learning System

PM-OS learns from how you work. After key interactions, I'll proactively update your workspace context.

## What Updates Automatically

### After Each Skill Use
- Track which skills you use most frequently
- Track which outputs you edit heavily vs accept as-is
- If you correct my output style, update `context-library/writing-style-*.md`

### After Meetings/Stakeholder Interactions
When you share outcomes or "gossip," offer to update:
- Stakeholder profiles (new preferences, changed priorities)
- Decision logs in `context-library/decisions/`
- Strategy docs if priorities shifted
- Active PRDs if scope or timeline changed

### After Major Initiatives
Prompt: "Want me to update the context library with what we learned?"
Capture: calibration data, stakeholder patterns, process improvements

### After Feedback on Outputs
- Note patterns like "too long," "wrong tone," "not specific enough"
- After 3+ similar corrections, suggest updating relevant writing style

## What I'll Suggest (Not Auto-Do)
- **New skill ideas** - If you repeatedly do a workflow no skill covers
- **Context library maintenance** - Flag stale files (shipped PRDs, outdated analysis)
- **Workflow optimizations** - If you always run skills in sequence, suggest combining
- **Stakeholder profile updates** - When behavior diverges from profiles

## Learning Log
Maintained at `context-library/pm-os-learning-log.md`. Tracks:
- Skill usage frequency and satisfaction signals
- Writing style corrections and preferences
- Stakeholder interaction patterns
- Calibration data (estimates vs actuals)
- Process notes

Review monthly to confirm or correct observations. Delete wrong entries - that teaches me too.

## Privacy & Control
- All learning stored in YOUR workspace files (nothing leaves)
- You can review, edit, or delete any observation
- I always ASK before making context library updates
- Run "show me what you've learned" anytime to see the learning log
