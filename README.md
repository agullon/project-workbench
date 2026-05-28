# Project Workbench

Lightweight Claude Code skill for managing development task workspaces.

## Setup

```bash
git clone https://github.com/agullon/project-workbench.git
cd project-workbench
./install.sh
```

This copies commands and scripts to `~/.claude/` and adds a SessionStart hook to `~/.claude/settings.json`. Projects are stored at `~/workspace/projects/`.

## Usage

### Create a project

```
/project:new fix kubelet timeout after fencing
```

You'll be asked for:
- Task type (bug, feature, ci-testing, docs, analysis)
- JIRA ticket (optional)
- Additional context (optional)

This creates a workspace under `~/workspace/projects/<name>/` with a single CLAUDE.md containing frontmatter, plan checklist, progress tracking, and notes.

### Resume a project

```
/project:resume
/project:resume fix-kubelet-timeout
/project:resume 1
```

Without arguments, you'll see a list of active projects to pick from. You can also pass the project name or its number from the recent projects table.

### Close a project

```
/project:close fix-kubelet-timeout
/project:close 1 resolved via PR #1234
```

Marks the project as done and optionally records closing notes. Closed projects are hidden from the session summary but can still be resumed.

## Project Structure

Each project lives under `~/workspace/projects/<name>/`:

```
~/workspace/projects/<name>/
├── CLAUDE.md       # All project state: metadata, plan, progress, notes
└── <repo>/         # Git repo checkout (cloned or linked here)
```

The workspace directory itself is **not** a git repo. The actual repository is always checked out as a subdirectory at the same level as `CLAUDE.md`.

### CLAUDE.md Layout

A single file holds everything:

```markdown
---
project: <folder-name>
type: <bug|feature|ci-testing|docs|analysis>
created: <YYYY-MM-DD>
status: <active|done>
jira: <URL or "none">
related_links:
  - <any relevant URLs>
---

# <Title>

## Summary
2-3 sentence description + metadata bullets.

## Plan
Type-specific checklist (e.g., identify root cause, implement fix, test, submit PR).

## Progress
Milestone checkboxes tracking what's done vs remaining.

## Notes
Free-form notes added during the project lifecycle.
```

### Splitting Rule

If `CLAUDE.md` grows beyond ~200 lines, the largest section is split into its own file (e.g., `notes.md`, `investigation.md`) and replaced with a pointer:

```markdown
## Notes

See [notes.md](notes.md)
```
