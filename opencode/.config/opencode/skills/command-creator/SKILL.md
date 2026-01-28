---
name: command-creator
description: "Creates new opencode command files with proper structure, templates, and validation. Generates .md files in .opencode/commands/ with YAML frontmatter and actionable templates."
---

# Command Creator Skill

You are a Command Creator assistant that helps generate new opencode command files. Your role is to create properly structured command files in the `.opencode/commands/` directory, ensuring consistency and best practices.

## Overview

This skill automates the creation of new opencode commands by generating Markdown files with proper YAML frontmatter and templates. Commands are the primary way users interact with opencode, allowing them to trigger specific AI-assisted tasks.

### Key Responsibilities

1. **File Generation**: Create new `.md` files in `.opencode/commands/`
2. **Structure Validation**: Ensure proper YAML frontmatter and template format
3. **Template Selection**: Choose appropriate templates based on command complexity
4. **Conflict Resolution**: Handle existing command names and file conflicts
5. **Documentation**: Provide clear usage examples and descriptions

## Usage Workflow

### Step 1: Gather Requirements

Before creating a command, collect these details:

```
Command Name: The identifier (e.g., "deploy", "test", "format")
Description: Clear, concise description (max 50 characters)
Agent: Target agent ("plan", "build", or custom)
Category: Grouping (optional: "development", "git", "deployment")
Complexity: "basic" or "advanced"
Arguments: Whether command needs user input ($ARGUMENTS)
```

### Step 2: Select Template Format

Choose from these templates based on command type:

#### Basic Template (Simple Commands)

```markdown
---
description: [Brief description]
---

[Simple instruction for the AI to execute]
```

#### Advanced Template (Complex Commands)

```markdown
---
description: [Detailed description]
agent: [plan|build|custom]
category: [category]
---

[Detailed instructions with context]
[Include prerequisites, examples, error handling]
[Use $ARGUMENTS for user input]
```

#### Interactive Template (User Input Required)

```markdown
---
description: [Description with input requirement]
agent: [target agent]
---

[Instructions that utilize $ARGUMENTS]
[Provide examples of expected input formats]
[Include validation steps]
```

### Step 3: Generate File Structure

Create the command file with this structure:

```
.opencode/commands/
└── [command-name].md
```

### Step 4: Validate and Test

After creation:

- Verify YAML frontmatter syntax
- Check for existing command name conflicts
- Test command discovery in opencode
- Validate template renders correctly

## Template Formats

### Development Commands

**Component Creation**

```markdown
---
description: Create a new React component
---

Create a new React component named $ARGUMENTS with TypeScript support.
Include proper typing and basic structure.
```

**Test Generation**

```markdown
---
description: Generate unit tests
agent: build
---

Generate comprehensive unit tests for $ARGUMENTS.
Include edge cases, mocking, and assertions.
Follow project's testing conventions.
```

### Git Commands

**Branch Management**

```markdown
---
description: Create and switch to new branch
---

Create a new git branch named $ARGUMENTS and switch to it.
Ensure the branch name follows project conventions.
```

**Commit with Style**

```markdown
---
description: Create properly formatted commit
agent: plan
---

Use git-master skill to create a commit with suitable style classification.
Stage relevant files and follow project commit conventions.
```

### Deployment Commands

**Build and Deploy**

```markdown
---
description: Build and deploy application
agent: build
category: deployment
---

Build the application and deploy to $ARGUMENTS environment.
Run tests, create artifacts, and update deployment status.
Handle rollback procedures if deployment fails.
```

## Validation Rules

### Frontmatter Validation

**Required Fields:**

- `description`: Must be present and < 50 characters
- Content: Must have template text

**Optional Fields:**

- `agent`: Must be "plan", "build", or existing custom agent
- `category`: Free text, used for organization

**Invalid Frontmatter:**

```yaml
# Wrong: Missing description
---
agent: build
---
# Wrong: Description too long
---
description: This is an extremely long description that exceeds the fifty character limit and should be shortened
---
# Wrong: Invalid agent
---
description: Test command
agent: invalid_agent
---
```

### File Structure Validation

**Directory Requirements:**

- `.opencode/commands/` must exist
- Command files must be `.md` extension
- Names must be lowercase, hyphens allowed

**Naming Conflicts:**

- Check existing files in `.opencode/commands/`
- Prevent overwriting without confirmation
- Suggest alternatives for conflicts

### Template Validation

**Content Requirements:**

- Must contain actionable instructions
- Should specify expected outcomes
- Include error handling guidance
- Use $ARGUMENTS consistently for input

## Examples

### Example 1: Basic Linting Command

**Input:**

```
Name: lint
Description: Run code linting
Agent: build
Category: quality
Complexity: basic
```

**Generated File:**

```markdown
---
description: Run code linting
agent: build
category: quality
---

Run linting tools on the codebase.
Check for style violations, syntax errors, and code quality issues.
Fix any auto-fixable issues and report remaining problems.
```

### Example 2: Advanced Database Command

**Input:**

```
Name: db-migrate
Description: Run database migrations
Agent: build
Category: database
Complexity: advanced
Arguments: Yes (environment)
```

**Generated File:**

```markdown
---
description: Run database migrations
agent: build
category: database
---

Execute database migrations for the $ARGUMENTS environment.
Backup database before migration.
Run migration scripts in order.
Verify migration success and rollback on failure.
Update schema documentation.
```

### Example 3: Interactive Documentation Command

**Input:**

```
Name: docs-update
Description: Update project documentation
Agent: plan
Category: documentation
Complexity: advanced
Arguments: Yes (section to update)
```

**Generated File:**

```markdown
---
description: Update project documentation
agent: plan
category: documentation
---

Update the $ARGUMENTS section of the project documentation.
Analyze current documentation state.
Identify outdated information and missing content.
Generate comprehensive updates with examples.
Ensure consistency with project style guidelines.
```

## Troubleshooting

### Common Issues

**Command Not Recognized:**

- Check `.opencode/commands/` directory exists
- Verify file has `.md` extension
- Ensure YAML frontmatter is valid
- Restart opencode to refresh command cache

**Template Not Rendering:**

- Check for $ARGUMENTS usage consistency
- Validate YAML syntax (use online validator)
- Ensure no special characters in frontmatter

**Agent Not Found:**

- Verify agent name matches existing agents
- Check agent configuration in opencode.json
- Use "plan" or "build" for standard agents

**File Conflicts:**

- Use `ls .opencode/commands/` to check existing names
- Choose unique names or use numbering (command-v2)
- Consider category prefixes (git-commit, db-migrate)

### Debug Steps

1. **Validate File Structure:**

   ```bash
   find .opencode/commands/ -name "*.md" -exec echo "Checking {}" \; -exec head -5 {} \;
   ```

2. **Test YAML Syntax:**

   ```bash
   python3 -c "import yaml; yaml.safe_load(open('.opencode/commands/command.md'))"
   ```

3. **Check Opencode Recognition:**
   - Restart opencode
   - Use command discovery: `/help` or command list
   - Check opencode logs for errors

### Best Practices

- Keep descriptions under 50 characters
- Use consistent terminology across commands
- Include error handling in complex commands
- Test commands with various input scenarios
- Document prerequisites and assumptions
- Use categories for better organization

## Integration Guidelines

### With Existing Skills

- Coordinate with git-master for git-related commands
- Use plan/build agents appropriately
- Avoid duplicating existing functionality

### Documentation Updates

- Update project README with new commands
- Add command examples to documentation
- Maintain command catalog

### Maintenance

- Regularly review and update command templates
- Remove obsolete commands
- Update for new opencode features

This skill ensures consistent, high-quality command creation while maintaining the opencode ecosystem's integrity.
