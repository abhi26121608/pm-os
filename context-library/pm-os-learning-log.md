# PM-OS Learning Log

This log captures session-specific learnings, corrections, and patterns observed during PM-OS usage. Significant patterns should be promoted to `.claude/rules/` files.

---

## Session: March 25, 2026 - SRE Agent Research

### Context
Building comprehensive current-state documentation for SRE Agent UX reimagining initiative.

### What Went Well
- Parallel file reading when given explicit list
- Comprehensive synthesis of competitive research
- Good integration of multiple source types (Jira, Confluence, meeting transcripts, PDFs)

### Corrections Received

#### 1. Link Following Depth
**Observation**: Did not automatically dig into sub-links within Atlassian pages.
**User Feedback**: "You kept on making errors like I had to ask you to dig down into sub links"
**Learning**: When fetching Atlassian content, follow ALL internal links automatically, not just the top-level page.
**Action**: Added to `.claude/rules/research-behavior.md`

#### 2. Folder Exploration Proactivity
**Observation**: User had to explicitly point to PM-OS context library folder for competitive research.
**User Feedback**: "in the pm-os context library there is a folder sre agent with more information"
**Learning**: Should have proactively explored PM-OS context library when building research documentation.
**Action**: Added folder exploration rules to `.claude/rules/research-behavior.md`

#### 3. Comprehensive vs. Surface Research
**Observation**: Initial information gaps analysis listed "competitive analysis" as a gap, but didn't proactively search for existing research.
**Learning**: Before declaring information gaps, search the workspace thoroughly for existing documentation.
**Action**: Added to research behavior rules

### Patterns Identified

| Pattern | Frequency | Rule Created? |
|---------|-----------|---------------|
| Need to follow nested links | This session | Yes |
| Need to explore folders thoroughly | This session | Yes |
| Need to search before declaring gaps | This session | Yes |

### Suggested Improvements for Future Sessions

1. **Start research tasks by exploring context-library**: Before external research, check what already exists locally.

2. **When user provides ANY link**: Follow it immediately, then follow all links within it.

3. **When building documentation**: Actively search for related files in the workspace, don't wait to be told.

### User Preferences Noted

- Prefers comprehensive research over quick surface-level answers
- Values proactive behavior over asking permission
- Wants learnings captured systematically for improvement

---

## Log Entry Template

```markdown
## Session: [Date] - [Topic]

### Context
[Brief description of what was being worked on]

### Corrections Received
#### [Number]. [Title]
**Observation**: [What happened]
**User Feedback**: [Quote if available]
**Learning**: [What should be done differently]
**Action**: [Rule created? File updated?]

### Patterns Identified
| Pattern | Frequency | Rule Created? |
|---------|-----------|---------------|

### User Preferences Noted
- [Preference 1]
- [Preference 2]
```

---

## Rules Promotion Tracker

| Learning | Sessions Observed | Promoted to Rules? | Rule File |
|----------|-------------------|-------------------|-----------|
| Auto-follow Atlassian links | 1 | Yes | research-behavior.md |
| Explore folders thoroughly | 1 | Yes | research-behavior.md |
| Search before declaring gaps | 1 | Yes | research-behavior.md |

*Promote to rules after 2+ similar observations or if user explicitly requests.*

---

## Monthly Review Checklist

- [ ] Review all session entries
- [ ] Identify repeated patterns (3+ occurrences)
- [ ] Promote patterns to rules files
- [ ] Archive old entries (>3 months)
- [ ] Check if any rules are outdated

---

*Last updated: March 25, 2026*
