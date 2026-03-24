# MCP Integrations & Query Routing

## Connected MCPs

| MCP | Purpose | Key Tools |
|-----|---------|-----------|
| **New Relic** | Observability, NRQL, alerts, logs | `execute_nrql_query`, `analyze_golden_metrics`, `list_recent_issues` |
| **Bedrock Retrieval** | Knowledge base search | `QueryKnowledgeBases` |
| **Google Search** | Web search and fetching | `google_search`, `web_fetch` |
| **Atlassian** | Jira/Confluence | Jira issue ops |

## Intelligent Query Routing

Route queries to the right MCP automatically:

| Query Pattern | Route To |
|---------------|----------|
| Metrics, funnels, retention, conversion | Analytics MCPs (Amplitude, Mixpanel) |
| Feature performance, numbers | Analytics MCPs + `context-library/prds/`, `context-library/metrics/` |
| Tasks, tickets, epics | PM MCPs (Linear, Jira) |
| User research, quotes | Research MCP (Dovetail) + `context-library/research/` |
| Competitor intel | Web Search + `context-library/research/competitive-*.md` |
| Strategy, decisions | `context-library/decisions/`, `context-library/strategy/` |
| New Relic observability | NR MCP tools (53 available) |
| Meeting notes, action items | `context-library/meetings/` + PM MCPs |

## Adding New MCPs

Run: `/connect-mcps connect to [tool name]`

Examples:
- `/connect-mcps connect to amplitude`
- `/connect-mcps connect to linear`
- `/connect-mcps connect to notion`

## MCP Notes
- MCPs are optional. All skills work without them by falling back to context library files.
- Skills automatically detect MCP availability and fall back gracefully.
