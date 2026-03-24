# Claude Code Best Practices & Tips Reference

Source: [claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice) - Curated tips from Boris Cherny (Claude Code creator) and the team.

---

## 🔑 The Golden Rules (From Boris Cherny)

### 1. Always Start with Plan Mode
> "Start most sessions in Plan mode (shift+tab twice). If the goal is to write a Pull Request, use Plan mode and go back and forth with Claude until you like its plan. From there, switch into auto-accept edits mode and Claude can usually 1-shot it. A good plan is really important."

### 2. Give Claude a Way to Verify Its Work
> "Probably the most important thing to get great results out of Claude Code — give Claude a way to verify its work. If Claude has that feedback loop, it will 2–3x the quality of the final result."

### 3. Use Opus with Thinking for Everything
> "Even though it's bigger and slower than Sonnet, since you have to steer it less and it's better at tool use, it is almost always faster than using a smaller model in the end."

---

## 💬 Prompting Tips (Don't Babysit)

| Tip | Why It Works |
|-----|--------------|
| **"Grill me on these changes"** | Challenge Claude to test your understanding before making a PR |
| **"Prove to me this works"** | Forces Claude to diff between main and your branch |
| **"Knowing everything you know now, scrap this and implement the elegant solution"** | After a mediocre fix, resets Claude's approach |
| **Paste the bug, say "fix"** | Don't micromanage how — Claude fixes most bugs by itself |

---

## 📋 CLAUDE.md Best Practices

### File Size
- **Target under 200 lines per file** (HumanLayer recommends 60 lines)
- Use `.claude/rules/` to split large instructions
- Use multiple CLAUDE.md files for monorepos (ancestor + descendant loading)

### Making Claude Follow Instructions
```markdown
<important if="working on authentication">
Always use the existing AuthService. Never create a new auth implementation.
</important>
```
> Wrap domain-specific rules in `<important if="...">` tags to stop Claude from ignoring them as files grow longer.

### The Litmus Test
> "Any developer should be able to launch Claude, say 'run the tests' and it works on the first try — if it doesn't, your CLAUDE.md is missing essential setup/build/test commands."

### Keep Codebases Clean
> "Finish migrations — partially migrated frameworks confuse models that might pick the wrong pattern."

---

## 🤖 Agents & Skills

### When to Use What
| Need | Use |
|------|-----|
| Workflow you do many times/day | **Slash Command** |
| Isolated task with fresh context | **Subagent** |
| Progressive disclosure of knowledge | **Skill** |

### Key Tips
- **"Use subagents"** to throw more compute at a problem — keeps main context clean
- Have **feature-specific** subagents (not generic "qa" or "backend engineer")
- Use **test time compute** — separate context windows make results better; one agent can cause bugs and another can find them

### Skills Best Practices
- Skills are **folders**, not files — use `references/`, `scripts/`, `examples/` subdirectories
- Skill description is a **trigger**, not a summary — write "when should I fire?"
- Build a **Gotchas section** — highest-signal content, add Claude's failure points over time
- Don't state the obvious — focus on what pushes Claude out of default behavior
- Don't railroad Claude — give goals and constraints, not step-by-step instructions

---

## 🪝 Hooks

### Most Useful Hooks

**PostToolUse - Auto-format code:**
```json
"PostToolUse": [
  {
    "matcher": "Write|Edit",
    "hooks": [{
      "type": "command",
      "command": "bun run format || true"
    }]
  }
]
```

**Stop hook - Nudge Claude to verify:**
> Use a Stop hook to nudge Claude to keep going or verify its work at the end of a turn.

**Permission routing:**
> Route permission requests to Opus via a hook — let it scan for attacks and auto-approve safe ones.

---

## ⚙️ Settings & Workflow

### Recommended Settings
```json
{
  "alwaysThinkingEnabled": true,
  "model": "opus"
}
```
- Use **thinking mode true** to see reasoning
- Use **Output Style Explanatory** for detailed output with ★ Insight boxes

### Context Management
- **Manual /compact at max 50%** — avoid the "agent dumb zone"
- Use **/clear** to reset context mid-session when switching tasks
- Use **Esc Esc or /rewind** to undo when Claude goes off-track

### Permissions
- **Don't use `--dangerously-skip-permissions`**
- Use `/permissions` with wildcard syntax: `Bash(npm run *)`, `Edit(/docs/**)`

### Session Management
- `/rename` important sessions (e.g., "[TODO - refactor task]")
- `/resume` them later
- Commit often — at least once per hour

---

## 🔄 Development Workflow Pattern

**Research → Plan → Execute → Review → Ship**

### Starting a New Feature
1. Start in **Plan mode** (shift+tab twice)
2. Use AskUserQuestion tool — let Claude interview you
3. Go back and forth until you like the plan
4. Switch to auto-accept edits mode
5. Let Claude 1-shot it

### Planning Tips
- Always make a **phase-wise gated plan** with tests (unit, automation, integration)
- Spin up a second Claude to **review your plan** as a staff engineer
- Write detailed specs and **reduce ambiguity** before handing off work
- **Prototype > PRD** — build 20-30 versions instead of writing specs

---

## 🛠️ Parallel Development

### Run Multiple Claudes
1. Run 5 Claudes in parallel in terminal (number tabs 1-5)
2. Use system notifications to know when Claude needs input
3. Use claude.ai/code for even more parallelism (5-10 web sessions)

### Agent Teams
- Use **tmux** for agent teams
- Use **git worktrees** for isolated branches in parallel development

---

## 🐛 Debugging Tips

| Situation | Solution |
|-----------|----------|
| Stuck on any issue | Take **screenshots** and share with Claude |
| Need to see browser logs | Use MCP (Claude in Chrome, Playwright, Chrome DevTools) |
| Need terminal logs | Ask Claude to run as a **background task** |
| Installation issues | Run **/doctor** |
| Error during compaction | Use `/model` to select 1M token model, then `/compact` |
| Need QA | Use **cross-model** approach (e.g., Codex for review) |

---

## 📊 The Orchestration Pattern

```
Command → Agent → Skill
```

1. **Command** — User-invoked workflow trigger
2. **Agent** — Autonomous actor in fresh isolated context
3. **Skill** — Progressive disclosure of domain knowledge

---

## 📚 Resources

- [Boris's 13 Tips (Jan 2026)](https://x.com/bcherny/status/2007179832300581177)
- [Boris's 10 Tips (Feb 2026)](https://x.com/bcherny/status/2017742741636321619)
- [Boris's 12 Tips (Feb 2026)](https://x.com/bcherny/status/2021699851499798911)
- [Thariq on Skills (Mar 2026)](https://x.com/trq212/status/2033949937936085378)
- [HumanLayer - Writing a Good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
- [Full Repo](https://github.com/shanraisshan/claude-code-best-practice)
