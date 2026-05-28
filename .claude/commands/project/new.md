---
description: Create a new project workspace for a development task
argument-hint: [description]
---

# New Project Workspace

Create a structured project workspace under `~/workspace/projects/`.

Everything after "new" in `$ARGUMENTS` is an optional initial description.

## Step 1: Gather Task Information

### 1a. Task Description

If the user provided a description in the arguments, use that.
Otherwise ask:

> "What task are you working on? Describe it in a sentence or two."

### 1b. Task Type

Based on the description, suggest a type and confirm with AskUserQuestion:

| Type | When to suggest |
|------|-----------------|
| Bug investigation | Mentions a bug, issue, regression, failure, broken behavior |
| Feature development | Mentions adding, implementing, creating new functionality |
| CI/testing | Mentions CI, Prow, test failures, promotion, jobs |
| Documentation | Mentions docs, writing, documenting |
| Analysis/review | Mentions reviewing, analyzing, investigating |

### 1c. JIRA Ticket (optional)

Ask: "Do you have a JIRA ticket? Paste the URL or say 'no'."

### 1d. Additional Context (optional)

Ask: "Any additional context? (PR URLs, links, etc.) Say 'no' to skip."

## Step 2: Generate Folder Name

1. If a JIRA ticket was provided, use the ticket ID (e.g., `OCPBUGS-74679`).
2. Otherwise, generate a kebab-case slug from the description (under 40 chars).
3. Check if `~/workspace/projects/<name>/` exists. If so, suggest appending `-2`.
4. Confirm the name with the user.

## Step 3: Create Project Scaffold

### 3a. Create directory

Run `mkdir -p ~/workspace/projects/<folder-name>/`

### 3b. Generate CLAUDE.md

Write a single `~/workspace/projects/<folder-name>/CLAUDE.md` containing
everything — no separate detail files. Keep it under ~200 lines.

**Frontmatter:**

```yaml
---
project: <folder-name>
type: <bug|feature|ci-testing|docs|analysis>
created: <YYYY-MM-DD>
status: active
jira: <URL or "none">
related_links:
  - <any URLs provided>
---
```

**Sections (in order):**

1. `# <Title>` — from JIRA or description
2. `## Summary` — 2-3 sentence description + metadata bullets (Jira, assignee, etc.)
3. `## Plan` — type-specific checklist (see below)
4. `## Progress` — `- [x] Project created` + type-specific milestones (unchecked)
5. `## Notes` — empty section for ongoing work notes

### Type-Specific Plan & Progress

**Bug** — Plan: Identify root cause, Determine fix, Implement, Test, Submit PR. Progress: Bug details captured, Logs analyzed, Root cause identified, Fix implemented, PR submitted.

**Feature** — Plan: Review requirements, Design, Implement, Write tests, Submit PRs. Progress: Design documented, Implementation started, Tests written, PR(s) submitted, PR(s) merged.

**CI/testing** — Plan: Identify failing jobs, Analyze failures, Implement fixes, Validate CI. Progress: CI jobs identified, Failures analyzed, Fixes implemented, CI passing.

**Docs** — Plan: Research and outline, Write draft, Technical review, Submit PR. Progress: Draft written, Technical review, PR submitted.

**Analysis** — Plan: Define scope, Gather data, Analyze findings, Write recommendations. Progress: Analysis started, Findings documented, Recommendations made.

### 3c. Generate .gitignore

```gitignore
*.log
*.txt.gz
*.tar.gz
```

## Splitting Rule

All content lives in CLAUDE.md. If during the project lifecycle CLAUDE.md
grows beyond ~200 lines, split the largest section into its own file
(e.g., `notes.md`, `investigation.md`) and replace the section content
in CLAUDE.md with a pointer:

```markdown
## Notes

See [notes.md](notes.md)
```

## Step 4: Summary

After creating the project:
1. Show what was created
2. Suggest concrete next steps
3. Remind the user they can resume later with `/project:resume`

## Notes

- Use the Write tool for files, Bash only for `mkdir -p`
- Use today's date for `created`
- If the user provides enough context in arguments, minimize questions
