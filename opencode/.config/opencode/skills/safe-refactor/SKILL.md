---
name: safe-refactor
description: >
  Performs safe code refactoring with comprehensive safety measures.
  Trigger: When user asks to refactor code safely, rename functions, or restructure code.
license: Apache-2.0
metadata:
  author: opencode
  version: "1.0"
allowed-tools: Read, Edit, Glob, Grep, Bash, Task
---

## When to Use

Perform safe refactoring when:

- Renaming functions, variables, or classes
- Restructuring code for better organization
- Optimizing performance-critical sections
- Improving code readability and maintainability
- Extracting methods or classes
- Consolidating duplicate code

## Critical Patterns

### Safety First Approach

**ALWAYS** follow this sequence:

1. **Analyze** - Understand current code and dependencies
2. **Backup** - Create git branch or stash current changes
3. **Incremental Changes** - Make small, verifiable changes
4. **Rollback Ready** - Know how to revert if issues occur

### Code Analysis Requirements

Before refactoring:

- Use Grep to find all usages of the target code
- Use Read to understand current implementation
- Identify dependencies and side effects
- Check for complex logic that needs careful handling

### Change Management

- **Atomic Changes**: Each refactoring should be a single, focused change
- **Test After Each Step**: Never batch changes without validation
- **Documentation Updates**: Update comments and docs as you refactor
- **Interface Preservation**: Maintain public APIs unless explicitly changing them

## Refactoring Types

### Function/Method Refactoring

```typescript
// Before
function oldFunction(param1, param2) {
  // complex logic
}

// After (safe rename)
function newFunctionName(param1, param2) {
  // same complex logic
}
```

### Variable Renaming

```typescript
// Before
const usr = getUser();

// After
const user = getUser();
```

### Code Extraction

```typescript
// Extract method safely
function processData(data) {
  // Before: inline logic
  const result = data.map((item) => item.value * 2);
  return result.filter((val) => val > 10);
}

// After: extracted function
function calculateValues(data) {
  return data.map((item) => item.value * 2);
}

function filterHighValues(values) {
  return values.filter((val) => val > 10);
}

function processData(data) {
  const result = calculateValues(data);
  return filterHighValues(result);
}
```

## Validation Commands

### Pre-Refactor Checks

```bash
# Run tests before starting
npm test

# Check linting
npm run lint

# Type checking
npm run typecheck
```

### Post-Refactor Validation

```bash
# Run all validation steps
npm test && npm run lint && npm run typecheck

# Check for breaking changes
git diff --name-only
```

## Rollback Procedures

### Git-Based Rollback

```bash
# If on feature branch
git reset --hard HEAD~1  # Undo last commit
git checkout main        # Switch back
git branch -D feature-branch

# If working directory changes
git stash                # Save changes
# ... test rollback ...
git stash pop            # Restore if safe
```

### Manual Rollback

- Keep original files backed up
- Have git history to reference
- Know which files were changed
- Test rollback thoroughly

## Error Handling

### Common Issues

**Tests Failing After Refactor:**

- Check if function signatures changed
- Verify all call sites updated
- Look for missing dependencies

**Linting Errors:**

- Fix import statements
- Update variable references
- Check for unused code

**Type Errors:**

- Update type definitions
- Fix interface changes
- Verify generic type usage

### Recovery Steps

1. **Stop and Assess**: Don't make more changes
2. **Revert Changes**: Use git to undo problematic changes
3. **Test Revert**: Ensure rollback works
4. **Retry Smaller**: Break down into smaller changes
5. **Get Help**: Ask for code review if stuck

## Best Practices

- **Start Small**: Refactor one function at a time
- **Use IDE Tools**: Leverage rename refactoring features
- **Commit Often**: Each successful change gets committed
- **Document Changes**: Update comments and READMEs
- **Peer Review**: Have someone verify complex refactors
- **Measure Impact**: Ensure performance doesn't degrade

## Integration with Tools

### With Git-Master Skill

Use git-master for version control operations:

- Creating feature branches
- Committing atomic changes
- Managing merge conflicts

### With Testing Frameworks

Coordinate with testing tools:

- Run unit tests for affected code
- Update integration tests
- Add regression tests for complex changes

This skill ensures refactoring is performed safely with minimal risk of introducing bugs or breaking functionality.

