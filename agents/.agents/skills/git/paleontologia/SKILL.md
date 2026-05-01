---
name: paleontologia
description: Time-travel investigation of the repository - trace commits from a point to present, or trace a topic backwards through history to understand its evolution and context.
license: Apache-2.0
metadata:
  author: opencode
  version: "1.0"
---

# Paleontología de Repositorio

Time-travel investigation of your codebase's history. Trace the evolution of ideas, features, or files through time.

## When to Use

Use this skill when you need to:

- Understand how a feature evolved from its first commit to now
- Find where a topic/theme appears in the repository history
- Investigate the "life story" of a specific change or pattern
- Go backwards from present day to find the origins of something
- Go forwards from a specific commit to see what came after

## Investigation Modes

### Mode 1: Forward Archaeology (Desde un punto hacia el presente)

Start from a specific commit, branch, or point in time and trace forward to see what happened after.

**Use when:**

- You found an interesting commit and want to understand its impact
- You want to see how a feature developed after being introduced
- You need to trace the evolution of a branch

**Commands:**

```bash
# From a specific commit to present
git log --oneline COMMIT_HASH..HEAD
git log --oneline --graph COMMIT_HASH..HEAD

# From a branch creation to now
git log --oneline BRANCH_NAME..HEAD
git log --format="%h %ad %s" --date=short BRANCH_NAME..HEAD

# From a date range
git log --oneline --since="2024-01-01" --until="2024-12-31"
```

### Mode 2: Backward Archaeology (Desde el presente hacia el pasado)

Start from a topic, file, or concept in the present and trace backwards to find its origins.

**Use when:**

- You see something in the code now and want to know how it got there
- You want to find the "first commit" that introduced something
- You're investigating the history of a specific pattern or fix

**Commands:**

```bash
# Find commits touching a specific topic/pattern
git log --all --oneline -S"TOPIC"
git log --all --oneline --grep="TOPIC"

# Trace a file's history
git log --oneline --follow path/to/file
git log --format="%h %ad %s" --date=short -- path/to/file

# Find when a specific line was introduced
git log -p -S"specific_code_snippet" -- path/to/file
git blame path/to/file

# Author-based investigation
git log --oneline --author="username" --since="1 year ago"
```

### Mode 3: Temporal Window (Ventana temporal)

Investigate a specific time period - useful for understanding context around releases, incidents, or milestones.

**Use when:**

- You want to understand what happened during a specific period
- Investigating context around a release or incident
- Finding patterns in a specific timeframe

**Commands:**

```bash
# Last N commits
git log -n 20 --oneline

# Last week/month/year
git log --since="2 weeks ago" --oneline
git log --since="2024-01-01" --until="2024-03-31" --oneline

# Between tags/releases
git log v1.0.0..v2.0.0 --oneline
```

## Investigation Process

### Step 1: Define Your Time Travel Parameters

Determine your investigation mode:

- **Forward**: Do you have a starting commit/branch? → Use Mode 1
- **Backward**: Are you investigating something in present code? → Use Mode 2
- **Window**: Do you need a specific time period? → Use Mode 3

### Step 2: Gather Commit Trail

Use git-master skills to collect commits:

```
# Forward investigation - get commits after starting point
git log --oneline START_COMMIT..HEAD --all

# Backward investigation - find commits containing topic
git log --all --oneline -S"TOPIC" --decorate

# Get detailed info for each relevant commit
git show --stat COMMIT_HASH
git log -p COMMIT_HASH
```

### Step 3: Analyze the Trail

For each significant commit, identify:

- **What**: Files changed, magnitude of change
- **Why**: Commit message, PR context, issue reference
- **Who**: Author and their pattern of work
- **When**: Date and relationship to other commits

### Step 4: Connect the Dots

Build the narrative:

- How did this feature/topic evolve?
- Were there reversals or iterations?
- What's the current state vs original intent?
- Are there patterns in how changes were made?

## Output Format

Present as a temporal investigation report:

```
⏳ PALAEONTOLOGICAL INVESTIGATION: [Topic/Commit/Feature]

🎯 MODE: [Forward/Backward/Window]
📅 INVESTIGATION RANGE: [Date range or commit range]

📊 THE TIMELINE
├── [Date/Commit] - [What happened]
├── [Date/Commit] - [What happened]
└── [Date/Commit] - [What happened]

🔍 KEY FINDINGS
- [Insight 1 about evolution]
- [Insight 2 about patterns]
- [Insight 3 about context]

🌱 ORIGIN
[Where/how it started - for backward mode]

📍 CURRENT STATE
[What exists now - connection to present]

🎬 CONCLUSION
[Summary of the journey through time]
```

## Practical Examples

### Example 1: "How did our auth system come to be?"

**Investigation**: Backward mode

```
git log --all --oneline -S"auth" --since="2 years ago"
git log --all --oneline --grep="auth" | head -30
```

### Example 2: "What happened after we added that big refactor?"

**Investigation**: Forward mode

```
git log --oneline REFACTOR_COMMIT..HEAD
git show REFACTOR_COMMIT --stat
```

### Example 3: "What was happening in the repo during the v2 release?"

**Investigation**: Window mode

```
git log v1.9.0..v2.0.0 --oneline
git log --since="2024-01-01" --until="2024-03-01" --oneline
```

## Integration with Other Skills

### With arqueologia

- Use arqueologia to understand the current state of files you find in commits
- After finding historical commits, investigate what those files look like now

### With git-master

- This skill IS the git-master integration for commit investigation
- Use git blame for line-by-line archaeology
- Use git bisect to find when bugs were introduced

### With safe-refactor

- Before refactoring, use this to understand the history of what you're changing
- Find related commits that might give context
- Understand why certain patterns exist

## Pro Tips

1. **Start broad, narrow down**: Begin with general logs, then focus on specific commits
2. **Follow the thread**: One commit often leads to another - follow the narrative
3. **Check branch context**: A commit might make sense in one branch but not another
4. **Look for patterns**: Iterations, reversals, and refinements tell a story
5. **Connect to issues/PRs**: Use commit hashes to find related discussions

Remember: Every line of code has a story. This skill helps you uncover it through time.
