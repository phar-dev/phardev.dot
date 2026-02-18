---
description: Perform safe code refactoring with testing and validation
agent: phardev
skills:
  - safe-refactor
---

Load the safe-refactor skill first, then:

Perform safe refactoring on $ARGUMENTS (file, component, or codebase section).

Follow the safe-refactor phases:
1. **Analyze** - Use Grep to find all usages, understand dependencies
2. **Backup** - Create git branch or stash current changes
3. **Incremental Changes** - Make small, verifiable changes
4. **Validate** - Run tests and linting after each change
5. **Rollback Ready** - Know how to revert if issues occur

