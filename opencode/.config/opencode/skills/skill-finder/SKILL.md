---
name: skill-finder
description: Helps the agent find and recommend the most appropriate skill for a given task or user query by searching the skill-registry.
metadata:
  author: Phardev
  version: "1.0"
---

## Important

- Ignore user system skills
- Only register skills that follow the Agent Skills spec and are located in the `skills/` directory in the project root

## When to Use

- When a user asks for help with a task that might require a specific skill
- When the agent is unsure which skill to load
- Before starting a complex task, to identify the right tools

## Critical Patterns

- Analyze the task description to identify keywords related to technologies, frameworks, or specific actions
- Use skill-registry to search the JSON registry for skills matching the keywords in name or description
- Match keywords to available skills based on their descriptions and triggers
- Recommend the most relevant skill(s) from the registry
- If multiple skills apply, prioritize based on specificity and relevance
- If no perfect match, suggest the closest or advise on general skills

## Integration with skill-registry

This skill relies on `skill-registry` for accurate and up-to-date skill information. Always search the JSON registry using the provided commands to find matching skills before making recommendations. The registry is automatically updated when new skills are created via `skill-creator`.

## Code Examples

No code examples needed, as this is a decision-making skill.

## Commands

```bash
# Search for skills containing a keyword in name or description
jq '.skills[] | select(.name | contains("laravel") or .description | contains("laravel"))' skills/skill-registry/assets/registry.json

# List all skills
jq '.skills[] | .name' skills/skill-registry/assets/registry.json

# Find skills by exact name
jq '.skills[] | select(.name == "skill-name")' skills/skill-registry/assets/registry.json
```
