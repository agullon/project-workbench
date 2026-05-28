# Project Tracker

Track development tasks with structured workspaces inside Claude Code.

## Setup

Open Claude Code in this directory. The SessionStart hook will automatically show your recent active projects.

## Usage

### Create a project

```
/project:new fix kubelet timeout after fencing
```

You'll be asked for:
- Task type (bug, feature, ci-testing, docs, analysis)
- JIRA ticket (optional)
- Additional context (optional)

This creates a workspace under `projects/<name>/` with a CLAUDE.md index, checklists, and type-specific detail files.

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

Each project gets:

```
projects/<name>/
  CLAUDE.md       # Index with frontmatter, reference files table, plan, progress
  .gitignore      # Excludes large files
  <detail files>  # Type-specific (investigation.md, design.md, etc.)
```

The `CLAUDE.md` frontmatter tracks metadata:

```yaml
---
project: fix-kubelet-timeout
type: bug
created: 2026-05-28
status: active
jira: https://issues.redhat.com/browse/OCPBUGS-12345
---
```

Detail files are loaded on demand when resuming, keeping context lean.
