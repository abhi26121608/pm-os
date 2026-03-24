# Everything Claude Code - Selective Installation

Installed on: 2024-03-24

This documents the selective components installed from [Everything Claude Code](https://github.com/affaan-m/everything-claude-code) to enhance PM-OS with engineering best practices.

## What Was Installed

### Rules (`~/.claude/rules/`)

**Common Rules (language-agnostic):**
| File | Purpose |
|------|---------|
| `coding-style.md` | Immutability, file organization, naming conventions |
| `git-workflow.md` | Commit format, PR process, branch naming |
| `testing.md` | TDD principles, 80% coverage requirement |
| `performance.md` | Model selection, context management |
| `patterns.md` | Design patterns, skeleton projects |
| `hooks.md` | Hook architecture, TodoWrite usage |
| `agents.md` | When to delegate to subagents |
| `security.md` | Mandatory security checks |
| `development-workflow.md` | Development process guidelines |

**TypeScript Rules (`~/.claude/rules/typescript/`):**
| File | Purpose |
|------|---------|
| `coding-style.md` | TS/JS specific patterns, React/Next.js conventions |
| `patterns.md` | TypeScript design patterns |
| `testing.md` | Jest, Vitest, testing patterns |
| `security.md` | XSS prevention, input validation |
| `hooks.md` | React hooks best practices |

### Agents (`~/.claude/agents/`)

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| `planner.md` | Feature implementation planning | Starting new features |
| `architect.md` | System design decisions | Architecture questions |
| `code-reviewer.md` | Quality and security review | After writing code |
| `build-error-resolver.md` | Fix build errors | Build failures |
| `tdd-guide.md` | Test-driven development | Writing tests first |
| `typescript-reviewer.md` | TS/JS code review | TypeScript/JavaScript code |
| `security-reviewer.md` | Vulnerability analysis | Security audits |

### Skills (`~/.claude/skills/`)

| Skill | Purpose |
|-------|---------|
| `frontend-patterns/` | React, Next.js patterns and best practices |
| `backend-patterns/` | API, database, caching patterns |
| `api-design/` | REST API design, pagination, error handling |
| `tdd-workflow/` | TDD methodology (Red-Green-Refactor) |
| `verification-loop/` | Continuous verification system |
| `search-first/` | Research-before-coding workflow |
| `coding-standards/` | Universal coding standards |

## What Was NOT Installed (Full Plugin Required)

- **Hooks** - Session persistence, memory, continuous learning
- **60 Commands** - /tdd, /plan, /build-fix, /code-review, etc.
- **119 Skills** - Full skill library
- **28 Agents** - Full agent library

To get these, install the full plugin:
```bash
/plugin marketplace add affaan-m/everything-claude-code
/plugin install everything-claude-code@everything-claude-code
```

## How to Use

### Invoking Agents

Claude will automatically use these agents when appropriate, or you can request them:

```
"Use the planner agent to help me design this feature"
"Review this code with the code-reviewer agent"
"Help me fix this build error"
```

### Using Skills

Skills are invoked through context or explicit request:

```
"Follow the TDD workflow for this feature"
"Use frontend patterns for this React component"
"Apply API design best practices"
```

### Rules Apply Automatically

Rules in `~/.claude/rules/` are always active. They guide Claude's behavior for:
- Code style and organization
- Git commit messages and PR format
- Testing requirements (80% coverage)
- Security best practices

## PM-OS Integration

Your PM-OS setup is preserved. The ECC components add engineering best practices on top:

| PM-OS | ECC Addition |
|-------|--------------|
| `/prd-draft` | `planner` agent for technical planning |
| `/prototype` | `frontend-patterns`, `backend-patterns` skills |
| `/code-first-draft` | `tdd-guide` agent, `coding-standards` skill |

## Updating

To update ECC components:
```bash
cd /tmp && rm -rf everything-claude-code
git clone --depth 1 https://github.com/affaan-m/everything-claude-code.git
# Then re-copy desired components
```

## Additional Resources

### Curated Tips (Also Installed)
See `context-library/claude-code-tips-reference.md` for 84 curated tips from Boris Cherny (Claude Code creator) including:
- The Golden Rules (Plan Mode, Verify Work, Use Opus)
- CLAUDE.md best practices (under 200 lines, `<important if="...">` tags)
- Prompting tips (don't babysit, challenge Claude)
- Agent/Skill/Command patterns

### Settings Enhancements Applied
Your `~/.claude/settings.json` now includes:
- `alwaysThinkingEnabled: true` - Better reasoning
- `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE: 80` - Avoid the "agent dumb zone"
- Safer permission patterns (ask before destructive commands)

### External Resources

- [ECC Shorthand Guide](https://x.com/affaanmustafa/status/2012378465664745795)
- [ECC Longform Guide](https://x.com/affaanmustafa/status/2014040193557471352)
- [ECC Security Guide](https://x.com/affaanmustafa/status/2033263813387223421)
- [Everything Claude Code Repo](https://github.com/affaan-m/everything-claude-code)
- [Claude Code Best Practice Repo](https://github.com/shanraisshan/claude-code-best-practice)
- [Boris's 13 Tips](https://x.com/bcherny/status/2007179832300581177)
- [HumanLayer - Writing a Good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
