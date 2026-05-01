---
description: Quick commit investigation - find commits related to a topic or trace a file's history (fast mode). For deep time-travel analysis, load the paleontologia skill.
skills:
  - git-master
  - paleontologia
---

# Quick Paleontology (Fast Mode)

Use this command for quick investigations. For deep time-travel analysis, load the **paleontologia** skill.

## Quick Searches

**Find commits mentioning a topic:**

```bash
git log --all --oneline --grep="$ARGUMENTS"
git log --all --oneline -S"$ARGUMENTS"
```

**Trace a file's recent history:**

```bash
git log --oneline -n 15 -- path/to/file
```

**Find commits by an author:**

```bash
git log --all --oneline --author="$ARGUMENTS" -n 10
```

## When to Use Command vs Skill

| Need                                   | Use        |
| -------------------------------------- | ---------- |
| Quick "what commits mention X?"        | Command    |
| Trace evolution from commit to present | Load skill |
| Deep investigation with timeline       | Load skill |
| Find origins of something in code      | Load skill |

## Example Quick Searches

```
/paleontologia auth          # Quick: commits mentioning auth
/paleontologia path/to/file # Quick: file history
```

For full time-travel capabilities, use: **Load Skill → paleontologia**
