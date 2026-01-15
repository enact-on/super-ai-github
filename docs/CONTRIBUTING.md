# Contributing to SuperAI GitHub

Thank you for contributing! This guide covers how to add agents and skills to SuperAI GitHub.

## Overview

SuperAI GitHub uses OpenCode's plugin system:
- **Agents** are defined in `.opencode/agent/*.md` (markdown with YAML frontmatter)
- **Skills** are defined in `.opencode/skill/<name>/SKILL.md` (markdown with YAML frontmatter)

## Adding an Agent

### Agent Types

- **Primary agents** (`mode: primary`) - Main assistants you interact with directly (Tab to switch)
- **Subagents** (`mode: subagent`) - Specialized assistants invoked by `@mention` or automatically

### Agent Template

Create a new file in `.opencode/agent/`:

```markdown
---
description: Brief description of what this agent does
mode: subagent
model: anthropic/claude-sonnet-4-5
temperature: 0.2
tools:
  write: true
  edit: true
  bash: false
permission:
  edit: ask
---

# Agent Name

Detailed description of the agent's role and expertise.

## What I Do

- Specific capability 1
- Specific capability 2
- Specific capability 3

## When to Use Me

Use this agent when you need to...
```

### Agent Frontmatter Options

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `description` | string | Yes | Brief description for autocomplete |
| `mode` | string | No | `primary` or `subagent` (default: `all`) |
| `model` | string | No | Model to use (e.g., `anthropic/claude-sonnet-4-5`) |
| `temperature` | number | No | 0.0-1.0, lower = more focused |
| `tools` | object | No | Enable/disable tools |
| `permission` | object | No | Set permission levels (allow/deny/ask) |

### Best Practices

1. **Keep descriptions clear** - Help users understand when to use this agent
2. **Set appropriate temperature**:
   - `0.0-0.2` for code analysis, reviews
   - `0.3-0.5` for general development
   - `0.6-1.0` for creative/brainstorming tasks
3. **Restrict tools appropriately**:
   - Review agents: `write: false, edit: false`
   - Implementation agents: full access
   - Research agents: `bash: false`

## Adding a Skill

### Skill Template

Create a directory `.opencode/skill/<skill-name>/` with `SKILL.md` inside:

```markdown
---
name: skill-name
description: Clear description of when to use this skill
license: MIT
compatibility: opencode
---

# Skill Name

Detailed instructions for this technology or approach.

## What I Know

- Technology-specific pattern 1
- Technology-specific pattern 2
- Common pitfalls and solutions

## Best Practices

1. Practice 1
2. Practice 2
3. Practice 3

## Common Patterns

### Pattern 1

```typescript
// Example code
```

### Pattern 2

```php
// Example code
```

## When to Use Me

Use this skill when working with [technology] projects.
```

### Skill Frontmatter Options

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | 1-64 characters, lowercase alphanumeric with hyphens |
| `description` | string | Yes | 1-1024 characters, specific enough for selection |
| `license` | string | No | License identifier |
| `compatibility` | string | No | `opencode`, `claude`, or `all` |
| `metadata` | object | No | Custom string-to-string map |

### Skill Naming Rules

The `name` must:
- Be 1-64 characters
- Be lowercase alphanumeric with single hyphen separators
- Not start or end with `-`
- Not contain consecutive `--`
- Match the directory name

Valid: `react`, `laravel`, `node-js`, `vue-3`
Invalid: `React`, `laravel--php`, `-react`, `react-`

## Testing Your Changes

1. **Locally**:
   ```bash
   opencode
   # Type /agents to see your new agent
   # Type /skills or check available skills in TUI
   ```

2. **Test invocation**:
   ```
   @your-agent-name test message
   ```

3. **Test skill loading** (as an agent with skill access):
   ```
   Use the skill-name skill to...
   ```

## Submitting Changes

1. Fork the repository
2. Create a feature branch
3. Add your agent or skill
4. Test thoroughly
5. Submit a pull request

## Code Style

- Use **present tense** in descriptions ("Reviews code" not "Reviewed code")
- Be **specific** about capabilities
- Include **examples** where helpful
- Follow **Markdown** formatting conventions

## Questions?

Open an issue or start a discussion for any questions about contributing.
