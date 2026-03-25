# MCP Integrations & Query Routing

## Connected MCPs

| MCP | Purpose | Key Tools |
|-----|---------|-----------|
| **New Relic** | Observability, NRQL, alerts, logs | `execute_nrql_query`, `analyze_golden_metrics`, `list_recent_issues` |
| **Bedrock Retrieval** | Knowledge base search | `QueryKnowledgeBases` |
| **Google Search** | Web search and fetching | `google_search`, `web_fetch` |
| **Atlassian Jira** | Issue tracking, tickets | `getJiraIssue`, `searchJiraIssuesUsingJql`, `createJiraIssue` |
| **Atlassian Confluence** | Documentation, wiki | `getConfluencePage`, `searchConfluenceUsingCql`, `createConfluencePage` |

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

## Atlassian Auto-Open Behavior

<important>
When ANY document, message, or context contains Jira or Confluence links, AUTOMATICALLY fetch their content AND follow nested links without waiting for user to ask.
</important>

### What to Auto-Fetch
- **Jira issue keys** (e.g., `PROJ-123`, `ABC-456`) - use `getJiraIssue`
- **Jira URLs** (e.g., `https://site.atlassian.net/browse/PROJ-123`) - use `getJiraIssue`
- **Confluence URLs** (e.g., `https://site.atlassian.net/wiki/spaces/...`) - use `getConfluencePage`

### Multiple Links
- Fetch ALL links in parallel using multiple tool calls
- Summarize key information from each linked resource

### Nested Link Following (Critical)

<important>
After fetching ANY Atlassian content, scan for internal links and fetch those too:
</important>

1. **Level 1**: Fetch the primary page/issue requested
2. **Level 2**: Scan content for Atlassian links, fetch ALL of them in parallel
3. **Level 3**: For comprehensive research, go one more level if relevant

**Examples of nested links to follow:**
- Confluence pages that link to other Confluence pages
- Jira issues that link to related issues, epics, or child tickets
- Confluence pages with embedded Jira issue references
- Pages that reference "see also" or "related" documents

**Don't ask permission** - just follow the links and present consolidated findings.

### Search Behavior
- Use `searchAtlassian` (Rovo Search) for general Jira/Confluence searches
- Use `searchJiraIssuesUsingJql` only when JQL is explicitly requested
- Use `searchConfluenceUsingCql` only when CQL is explicitly requested

### CloudId Handling
- Extract hostname from URLs (e.g., `site.atlassian.net`) and use as cloudId
- If that fails, use `getAccessibleAtlassianResources` to list accessible sites

## MCP Notes
- MCPs are optional. All skills work without them by falling back to context library files.
- Skills automatically detect MCP availability and fall back gracefully.
