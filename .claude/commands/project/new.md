---
description: Create a new project workspace for a development task
argument-hint: [description]
---

# New Project Workspace

Create a structured project workspace under `projects/`.

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
3. Check if `projects/<name>/` exists. If so, suggest appending `-2`.
4. Confirm the name with the user.

## Step 3: Create Project Scaffold

### 3a. Create directories

Base: `projects/<folder-name>/`

| Type | Extra directories |
|------|-------------------|
| Bug investigation | `logs/`, `docs/` |
| Feature development | `docs/`, `patches/` |
| CI/testing | `results/`, `scripts/` |
| Documentation | `drafts/` |
| Analysis/review | `docs/` |

### 3b. Generate CLAUDE.md

Write `projects/<folder-name>/CLAUDE.md` (~50-80 lines) with this structure:

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
2. `## <Type> Summary` — 2-3 sentence description + metadata bullets
3. `## Reference Files` — table `| File | Content |` with one row per detail file
4. `## <Plan Section>` — type-specific checklist (see below)
5. `## Progress` — `- [x] Project created` + type-specific milestone items (unchecked)

### 3c. Generate .gitignore

```gitignore
*.log
*.txt.gz
*.tar.gz
```

### 3d. Create detail files

| Type | Files |
|------|-------|
| Bug investigation | `investigation.md`, `ci-runs.md` |
| Feature development | `design.md` |
| CI/testing | `ci-runs.md`, `test-failures.md` |
| Documentation | `drafts.md` |
| Analysis/review | `findings.md` |

### Type-Specific Plan & Progress

**Bug** — Plan heading: `Fix Plan`. Plan: Identify root cause, Determine fix, Implement, Test, Submit PR. Progress: Bug details captured, Logs analyzed, Root cause identified, Fix implemented, PR submitted.

**Feature** — Plan heading: `Implementation Plan`. Plan: Review requirements, Design approach, Implement, Write tests, Submit PRs. Progress: Design documented, Implementation started, Tests written, PR(s) submitted, PR(s) merged.

**CI/testing** — Plan heading: `Test Plan`. Plan: Identify failing jobs, Analyze failures, Implement fixes, Validate CI. Progress: CI jobs identified, Failures analyzed, Fixes implemented, CI passing.

**Docs** — Plan heading: `Outline`. Plan: Research and outline, Write draft, Technical review, Submit PR. Progress: Draft written, Technical review, PR submitted.

**Analysis** — Plan heading: `Analysis Plan`. Plan: Define scope, Gather data, Analyze findings, Write recommendations. Progress: Analysis started, Findings documented, Recommendations made.

## Detail File Templates

### `investigation.md`

```markdown
# Investigation

## Failure Analysis

_Describe the observed failure and symptoms._

## Root Cause

_Root cause goes here once identified._

## Proposed Fix

| Option | Description | Pros | Cons |
|--------|-------------|------|------|
```

### `ci-runs.md`

```markdown
# CI Runs

<!-- Add a section per CI run analyzed -->
```

### `design.md`

```markdown
# Design

## Architecture

_High-level design and component interactions._

## API Changes

_New or modified APIs._

## Related PRs

| PR | Status | Description |
|----|--------|-------------|
```

### `test-failures.md`

```markdown
# Test Failures

| Test | Error | Root Cause | Fix | Status |
|------|-------|------------|-----|--------|
```

### `drafts.md`

```markdown
# Drafts

## Target Documents

| Document | Path | Status |
|----------|------|--------|

## Outline

_Document outline goes here._
```

### `findings.md`

```markdown
# Findings

## Scope

_What is being analyzed and why._

## Findings

_Analysis results._

## Recommendations

| # | Recommendation | Priority | Status |
|---|----------------|----------|--------|
```

## Step 4: Summary

After creating the project:
1. List files created
2. Suggest concrete next steps
3. Remind the user they can resume later with `/project:resume`

## Notes

- Use the Write tool for files, Bash only for `mkdir -p`
- Use today's date for `created`
- If the user provides enough context in arguments, minimize questions
