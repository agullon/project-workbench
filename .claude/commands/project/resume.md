---
description: Resume an existing project workspace
argument-hint: [name-or-number]
---

# Resume Project Workspace

Resume work on an existing project from `~/workspace/projects/`.

## Step 1: Resolve Project

Run `python3 ~/.claude/scripts/resume-project.py $ARGUMENTS` via Bash.
Parse the JSON and handle by `status`:

- **`ok`** — proceed to Step 2.
- **`no_argument`** — present the first 3 `alternatives` as AskUserQuestion
  options plus "See all projects". Re-run with the chosen name.
- **`not_found`** or **`out_of_range`** — show `error_message`, present
  `alternatives` as a picker, re-run with the chosen name.
- **`no_projects`** — show `error_message` and stop.

Store the `project` object from the JSON as `P`.

## Step 2: Load Project

Read `P.context_file` using the Read tool (skip if null). If the project
has split-out files (referenced via links in CLAUDE.md), read those too.

## Step 3: Present Summary

```text
## Project: <P.name>

| Field | Value |
|-------|-------|
| **Type** | <P.frontmatter.type or "Unknown"> |
| **Created** | <P.frontmatter.created or "Unknown"> |
| **Status** | <P.frontmatter.status or "Unknown"> |
| **JIRA** | <P.frontmatter.jira or "None"> |
```

Show checklist progress as `P.checklist.checked`/`P.checklist.total`.

## Step 4: Sync CLAUDE.md

Before proceeding, check if the project's CLAUDE.md is stale:

1. If the repo subdirectory exists, run `git log --oneline -5` inside it
   to see recent commits since the project was last touched.
2. If there are commits not reflected in Progress or Notes, update
   CLAUDE.md briefly — check off completed milestones, add a one-line
   note for anything significant.
3. Keep updates minimal — one line per new development is enough.

## Step 5: Task Selection

Build a task menu from `P.checklist.unchecked_items` and present via
AskUserQuestion with options like:

- "Next: \<task text\>"
- "Review full project"
- "Something else"

## Notes

- Always use the Read tool for files, never cat via Bash
- If no context file exists, ask the user for context
