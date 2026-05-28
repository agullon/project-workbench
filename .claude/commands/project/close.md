---
description: Close a project workspace and mark it as done
argument-hint: [name-or-number] [closing notes]
---

# Close Project Workspace

Mark a project as done and optionally record closing notes.

Everything after "close" in `$ARGUMENTS` is parsed as:
- First token: optional project name or number
- Remaining text: closing notes

## Step 1: Select Project

### 1a. Resolve project name

Extract the first token from `$ARGUMENTS`. Run
`python3 scripts/resume-project.py <first-token>` via Bash (omit the
token if none was provided). Parse the JSON and handle by `status`:

- **`ok`** — use `project.name` as the target. Proceed to 1b.
- **`no_argument`** — check if a project was loaded earlier in this
  conversation (e.g., via `/project:resume`). If so, use that name.
  Otherwise, present the first 3 `alternatives` as AskUserQuestion
  options. Re-run with the chosen name.
- **`not_found`** / **`out_of_range`** — show `error_message`, present
  `alternatives` as a picker, re-run with chosen name.
- **`no_projects`** — show `error_message` and stop.

### 1b. Check current status

If `project.frontmatter.status` is `done`:
- Inform the user the project is already closed.
- Ask if they'd like to update closing notes. If no, stop.

## Step 2: Gather Closing Notes

If text after the project identifier exists in `$ARGUMENTS`, use it.
Otherwise ask:

> "Any closing notes? (outcome, resolution, PR links, etc.) Say 'no' to skip."

## Step 3: Update Project CLAUDE.md

### 3a. Read the current CLAUDE.md

### 3b. Update frontmatter

Using the Edit tool:
1. Change `status:` to `status: done`
2. Add `closed: <YYYY-MM-DD>` after the status line (update if exists)

### 3c. Add closing notes section

If notes were provided, add or replace `## Closing Notes` at end of file:

```markdown
## Closing Notes

_Closed YYYY-MM-DD_

<user's closing notes>
```

## Step 4: Confirm

```text
Project `<name>` marked as done.
```

Remind: closed projects won't appear in the session summary but can
still be resumed with `/project:resume <name>`.

## Notes

- Always Read before Edit
- Never delete the project directory — closing just updates metadata
- Use today's date for `closed`
