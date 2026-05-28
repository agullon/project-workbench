# Project Workbench

Lightweight Claude Code skill for managing development task workspaces.

## Setup

Install globally by copying commands and scripts to `~/.claude/`:

```bash
cp -r .claude/commands/project ~/.claude/commands/
cp scripts/*.py ~/.claude/scripts/
```

Add the SessionStart hook to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.claude/scripts/recent-projects.py"
          }
        ]
      }
    ]
  }
}
```

Projects are stored at `~/workspace/projects/`.

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

Each project gets a single `CLAUDE.md` with everything in one file:

```yaml
---
project: fix-kubelet-timeout
type: bug
created: 2026-05-28
status: active
jira: https://issues.redhat.com/browse/OCPBUGS-12345
---
```

If CLAUDE.md grows beyond ~200 lines, the largest section is split into its own file with a pointer left in place.
