---
name: arqueologia
description: Investigate the life of a file - its dependencies, consumers, and place in the system. Analyzes upstream dependencies, downstream consumers, indirect connections (tests, config, docs), and conceptual location in the architecture.
license: Apache-2.0
metadata:
  author: opencode
  version: "1.0"
---

# Arqueología de Código

Investigate a file as a living artifact within the system.

## When to Use

Use this skill when you need to:
- Understand what a file depends on (upstream)
- Discover what depends on a file (downstream)
- Find indirect connections (tests, config, docs, patterns)
- Understand where a file "lives" conceptually in the system
- Trace the life of a module through the codebase

## Investigation Process

### 1. Locate and Understand the Artifact

First, find and read the target file:

```
1. Locate the file in the repository
2. Read its contents to understand purpose and exports
3. Identify its primary responsibility
```

**Use**: `glob` to find the file, `read` to understand it.

### 2. Upstream Investigation (what this needs)

Search for direct dependencies the file requires:

**Import patterns by language:**

| Language | Patterns |
|----------|----------|
| JavaScript/TypeScript | `import`, `require`, `from ... import` |
| Python | `import`, `from ... import` |
| Go | `import` |
| Rust | `use` |
| Fish | `source` |
| Lua | `require` |
| C/C++ | `#include` |
| Shell | `source`, `.` |

**Actions:**
1. Grep for import patterns in the file
2. Map each imported module to its file location
3. Distinguish external packages vs internal modules
4. Briefly note what each dependency provides

**Use**: `grep` with appropriate patterns, `read` for dependency files.

### 3. Downstream Investigation (what needs this)

Find all files that import/require the target file:

**Search strategies:**

```
# By module name (most common)
grep -r "import.*module_name" --include="*.js"
grep -r "from.*module_name" --include="*.ts"
grep -r "require.*module_name" --include="*.js"

# By file path
grep -r "path/to/module" --include="*"

# By exported names (functions, classes)
grep -r "function_name" --include="*.ts"
grep -r "ClassName" --include="*.ts"
```

**Actions:**
1. Grep for the module name, function names, class names
2. Note HOW each consumer uses it
3. Identify direct vs indirect consumers

**Use**: `grep` with the module's name and key exports.

### 4. Indirect Connections

Look beyond direct imports for hidden relationships:

**Categories of indirect connections:**

| Category | What to Search |
|----------|----------------|
| **Tests** | Test files that reference this module |
| **Configuration** | Config files that enable/disable or reference it |
| **Documentation** | README, docs, comments mentioning it |
| **Naming patterns** | Similar file names or directory structures |
| **Logs/Errors** | String literals, error messages defined here used elsewhere |
| **Types/Interfaces** | TypeScript types used in other files |

**Search patterns:**

```
# Test files
grep -r "module_name" --include="*.test.*" --include="*.spec.*"
grep -r "module_name" --include="*test*.py" --include="*_test.py"

# Configuration
grep -r "module_name" --include="*.json" --include="*.yaml" --include="*.yml"
grep -r "module_name" --include="config.*" --include="*.config.*"

# Documentation
grep -r "module_name" --include="*.md" --include="*.rst"
```

**Use**: `grep` with different file patterns.

### 5. Conceptual Location

Determine where this file "lives" in the system:

**Questions to answer:**

1. What layer/domain does it belong to?
   - Presentation (UI, views, controllers)
   - Business (services, logic, domain)
   - Data (models, repositories, database)
   - Infrastructure (config, utils, helpers)

2. Is it a central module or peripheral?
   - Central: Many files depend on it
   - Peripheral: Few or no dependencies on it

3. Does it have a clear single responsibility?
   - Yes: Can describe in one sentence
   - No: May indicate multiple concerns

4. What would break if this file were removed?
   - List all consumers that would fail
   - Identify cascade effects

## Output Format

Present findings as a structured archaeological report:

```
🏛️ ARCHAEOLOGICAL FINDINGS: [filename]

📍 LOCATION: [path]
Layer: [presentation/business/data/infrastructure/util]

📦 WHAT IT CONTAINS
Exports: [functions, classes, constants, types]
Purpose: [one sentence description]

⬅️ UPSTREAM (needs these to function)
├── [dependency] from [path] - [what it provides]
└── [dependency] from [path] - [what it provides]

➡️ DOWNSTREAM (these need it)
├── [consumer] at [path] - [how/why it uses it]
└── [consumer] at [path] - [how/why it uses it]

🔗 INDIRECT CONNECTIONS
├── Tests: [test files that reference it]
├── Config: [config entries that affect it]
├── Docs: [documentation mentions]
└── Patterns: [naming conventions, related files]

🏛️ PLACE IN THE SYSTEM
[Where does this file conceptually belong? What's its role in the architecture?]

🔍 THE FILE'S STORY
[How does this file interact with the system? What happens if it changes?]
```

## Execution Notes

- Focus on understanding, not exhaustive listing
- Follow the trail even when connections are indirect
- Prioritize the most meaningful relationships
- If no direct dependencies exist, investigate WHY:
  - Is it an entry point?
  - Is it a utility that's imported dynamically?
  - Is it standalone/configuration?
- Use tree/glob/read progressively, not all at once

## Integration with Other Skills

### With git-master

- Use `git log -- path/to/file` for historical context
- Use `git blame path/to/file` for line-by-line history
- Use `git log -S "function_name"` to find when something was added

### With safe-refactor

- Before refactoring, understand dependencies
- Identify risky changes (many consumers)
- Find test coverage for safety
