# File Organization Rules

<important if="creating any new file">
ALL new files created by Claude go in `outputs/` organized by type. NEVER create files directly in `context-library/`.
</important>

## Context Library (Reference & History)
| Type | Location |
|------|----------|
| PRDs & Specs | `context-library/prds/` |
| Strategy | `context-library/strategy/` |
| Research | `context-library/research/` |
| Decisions | `context-library/decisions/` |
| Launches | `context-library/launches/` |
| Metrics | `context-library/metrics/` |
| Meeting notes | `context-library/meetings/` |
| Example PRDs | `context-library/example-prds/` |

## Outputs (Active Work)
| Type | Location |
|------|----------|
| PRDs | `outputs/prds/` |
| Research | `outputs/research-synthesis/` |
| Meeting Notes | `outputs/meeting-notes/` |
| Status Updates | `outputs/status-updates/` |
| Slack Messages | `outputs/slack-messages/` |
| Decisions | `outputs/decisions/` |
| Analyses | `outputs/analyses/` |
| Roadmaps | `outputs/roadmaps/` |
| Prototypes | `outputs/prototypes/` |
| Journey Maps | `outputs/journey-maps/` |
| Weekly Plans | `outputs/weekly-plans/` |
| Weekly Reviews | `outputs/weekly-reviews/` |

## Templates
`templates/` contains empty templates only (PRD template, interview template, launch checklist, etc.)

## Workflow
1. Claude creates ALL new files in `outputs/`
2. Once finalized, PM moves completed work to `context-library/` for reference
3. This keeps active work separate from historical context

## Key Reference Files
- Business info: `context-library/business-info-template.md`
- Writing styles: `context-library/writing-style-*.md`
- New Relic guide: `context-library/paul-claude-refs/new-relic-querying-guide-claude.md`
- Stakeholders: `context-library/stakeholder-template.md`
- Strategy frameworks: `context-library/strategy/` (7-powers, JTBD, PLG iceberg, etc.)
