# Research Behavior Rules

## Core Principle
**Dig deeper automatically. Don't wait to be asked.**

---

## Link Following (Critical)

<important>
When ANY document contains links, AUTOMATICALLY follow them without asking:
</important>

### Atlassian Links
- **Jira issues**: Fetch full details, then check for linked issues, epics, child tickets
- **Confluence pages**: Fetch content, then follow ALL internal links within the page
- **Nested links**: If a fetched page contains more Atlassian links, follow those too (up to 3 levels deep)
- **Attachments**: Note any attachments and offer to analyze them

### GitHub Links
- **PRs**: Fetch PR details, linked issues, and review comments
- **Issues**: Fetch issue details and linked PRs
- **Files**: Read the file and understand context

### General Web Links
- If research documents reference external URLs, fetch them proactively

---

## Folder Exploration

<important>
When user mentions a folder or directory, explore it THOROUGHLY:
</important>

1. **List all contents** first (including subdirectories)
2. **Read ALL relevant files** in parallel, not just the first few
3. **Explore subdirectories** without being asked
4. **Summarize what you found** before proceeding

### Example Pattern
```
User: "Check the research folder for competitor info"

WRONG: Read one file, ask if they want more
RIGHT: List folder → Read ALL .md files in parallel → Explore subfolders → Synthesize findings
```

---

## Document Analysis

### When Reading Research Documents
1. **Extract all links** and follow them
2. **Note references** to other documents and fetch them
3. **Identify gaps** proactively ("This mentions X but I don't see details, should I search for it?")

### When Building Comprehensive Documentation
1. **Cross-reference** multiple sources automatically
2. **Reconcile conflicts** between sources
3. **Flag missing information** explicitly

---

## Proactive Behaviors

### Always Do (Without Asking)
- Follow links in documents (Atlassian, GitHub, etc.)
- Explore entire folders when mentioned
- Read multiple related files in parallel
- Synthesize information across sources

### Ask Before Doing
- Making changes to existing files
- Creating new files outside `outputs/`
- Reaching out to external APIs beyond initial scope

---

## Session Learnings Integration

After each significant research task:
1. Note what could have been done better
2. Identify patterns that should become rules
3. Update learning log if significant insight discovered

---

## Anti-Patterns to Avoid

| Don't Do This | Do This Instead |
|---------------|-----------------|
| Read one file, wait for instruction | Read all relevant files in parallel |
| Surface-level link following | Follow links 2-3 levels deep |
| Ask "should I check the subfolder?" | Check it automatically |
| Provide partial information | Gather comprehensively, then present |
| Wait to be told about related docs | Proactively search for related content |

---

*These rules capture learnings from research sessions. Update when new patterns emerge.*
