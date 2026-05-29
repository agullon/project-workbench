# Project Workbench

Lightweight project workspace manager. Projects live under `~/workspace/projects/` and provide structured task tracking with checklists, progress, and notes.

## Rules

- **Never assume repos exist on disk.** Any repository needed for a task MUST be cloned into the project directory. Do not search the filesystem for existing checkouts — each project workspace is self-contained.

## Commands

| Command | Description |
|---------|-------------|
| `/project:new` | Create a new project workspace |
| `/project:resume` | Resume an existing project |
| `/project:close` | Close a completed project |
