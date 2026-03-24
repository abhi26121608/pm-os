# Claude Code Hooks Mastery - Quick Reference

Source: https://github.com/disler/claude-code-hooks-mastery

## What's Here

This folder contains reference implementations for Claude Code's hook system, subagents, status lines, and output styles.

---

## Directory Structure

```
claude-code-hooks-mastery/
├── hooks/                    # All 13 hook lifecycle handlers
│   ├── pre_tool_use.py      # Block dangerous commands (rm -rf, .env access)
│   ├── post_tool_use.py     # Log tool completions, extract chat transcripts
│   ├── user_prompt_submit.py # Prompt validation, logging, context injection
│   ├── stop.py              # AI-generated TTS completion messages
│   ├── session_start.py     # Load dev context on session start
│   ├── session_end.py       # Cleanup on session end
│   ├── notification.py      # TTS alerts for user input needed
│   ├── permission_request.py # Auto-allow read-only ops
│   ├── pre_compact.py       # Backup transcripts before compaction
│   ├── setup.py             # Repo init/maintenance
│   ├── subagent_*.py        # Subagent lifecycle hooks
│   ├── utils/
│   │   ├── llm/             # LLM integrations (OpenAI, Anthropic, Ollama)
│   │   └── tts/             # Text-to-speech (ElevenLabs, OpenAI, pyttsx3)
│   └── validators/          # Code quality hooks
│       ├── ruff_validator.py # Python linting
│       └── ty_validator.py   # Python type checking
│
├── agents/                   # Subagent configurations
│   ├── meta-agent.md        # Agent that creates other agents!
│   ├── hello-world-agent.md # Simple example
│   ├── work-completion-summary.md
│   ├── llm-ai-agents-and-eng-research.md
│   └── team/
│       ├── builder.md       # Implementation agent (all tools)
│       └── validator.md     # Read-only validation agent
│
├── status_lines/            # Terminal status displays
│   ├── status_line.py       # v1: Basic (git, dir, model)
│   ├── status_line_v2.py    # v2: Color-coded task types
│   ├── status_line_v3.py    # v3: Agent sessions
│   ├── status_line_v4.py    # v4: Extended metadata
│   ├── status_line_v5.py    # v5: Cost tracking
│   ├── status_line_v6.py    # v6: Context window bar ★
│   ├── status_line_v7.py    # v7: Session timer
│   ├── status_line_v8.py    # v8: Token stats
│   └── status_line_v9.py    # v9: Powerline minimal
│
├── output-styles/           # Response formatting
│   ├── genui.md             # HTML with modern styling ★
│   ├── table-based.md       # Markdown tables
│   ├── yaml-structured.md   # YAML format
│   ├── bullet-points.md     # Nested lists
│   ├── ultra-concise.md     # Minimal output
│   └── ...
│
├── ai_docs/                 # Documentation
│   ├── claude_code_hooks_docs.md
│   ├── claude_code_subagents_docs.md
│   └── claude_code_status_lines_docs.md
│
├── settings.example.json    # Full hooks configuration
└── README.md                # Original docs
```

---

## Key Concepts

### Hook Exit Codes

| Code | Behavior | Use Case |
|------|----------|----------|
| 0 | Success | Normal completion |
| 2 | Block | Prevent action, show error to Claude |
| Other | Non-blocking error | Show warning, continue |

### Hook JSON Output

```json
{
  "decision": "block",    // "approve" | "block" | undefined
  "reason": "Explanation",
  "continue": true,       // false stops Claude
  "stopReason": "..."     // shown when continue=false
}
```

---

## Quick Start - To Use These

### 1. Copy hooks to your project
```bash
cp -r hooks/ ~/.claude/hooks/
# or
cp -r hooks/ .claude/hooks/
```

### 2. Configure in settings.json
```json
{
  "hooks": {
    "PreToolUse": [{
      "hooks": [{
        "type": "command",
        "command": "uv run $CLAUDE_PROJECT_DIR/.claude/hooks/pre_tool_use.py"
      }]
    }]
  }
}
```

### 3. Set status line
```json
{
  "statusLine": {
    "type": "command",
    "command": "uv run $CLAUDE_PROJECT_DIR/.claude/status_lines/status_line_v6.py"
  }
}
```

---

## Most Valuable Items

1. **`pre_tool_use.py`** - Security (blocks rm -rf, .env access)
2. **`meta-agent.md`** - Creates new agents from descriptions
3. **`status_line_v6.py`** - Visual context window usage
4. **`genui.md`** - Beautiful HTML output style
5. **`ruff_validator.py`** - Auto-lint Python on write

---

## Prerequisites

- **[uv](https://docs.astral.sh/uv/)** - Fast Python runner (required)
- Optional: ElevenLabs, OpenAI, Ollama for TTS/LLM features
