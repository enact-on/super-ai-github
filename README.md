# SuperAI GitHub

> Centralized OpenCode configuration for organization-wide AI development

SuperAI GitHub provides standardized **OpenCode agents**, **skills**, and **GitHub workflows** for development teams. It enables 40+ developers across multiple technology stacks to use consistent AI coding standards while maintaining their personal OpenCode setups.

## Features

- **Role-based Agents** - Orchestrator delegates to specialized subagents (code reviewer, security auditor, implementation specialist, etc.)
- **Technology Skills** - Reusable patterns for React, Vue, Laravel, Node.js, and more
- **GitHub Integration** - Automatic PR reviews, scheduled security scans, comment-based triggers
- **Zero Configuration** - Uses standard `.opencode/` directory, no environment variables needed

## Quick Start

### For Developers

1. **Add as a submodule** to your project:
   ```bash
   git submodule add https://github.com/your-org/super-ai-github.git .super-ai-source
   cd .super-ai-source
   ./scripts/install.sh
   ```

2. **Use locally**:
   ```bash
   cd /path/to/your/project
   opencode
   ```

3. **Check available agents**: Type `/agents` in OpenCode

### For GitHub Integration

1. Add `ZHIPU_API_KEY` to your repository secrets
2. Push to GitHub
3. Open a PR to see SuperAI review automatically

## Architecture

### Agents as Roles, Skills as Technologies

```
orchestrator (Primary)
    ├── @code-reviewer      → Loads tech skill (react, laravel, etc.)
    ├── @security-auditor   → Loads tech skill
    ├── @implementation     → Loads tech skill
    ├── @frontend-specialist → Loads frontend skills
    ├── @backend-specialist  → Loads backend skills
    └── @database-expert    → Loads database skills
```

This matrix approach avoids combinatorial explosion (e.g., `security-react`, `security-laravel`) while allowing specialized expertise.

## Project Structure

```
super-ai-github/
├── .opencode/                   # OpenCode configuration
│   ├── opencode.json           # Main config
│   ├── agent/                  # Role-based agents
│   │   ├── orchestrator.md     # Primary orchestrator
│   │   ├── code-reviewer.md
│   │   ├── security-auditor.md
│   │   ├── implementation.md
│   │   ├── frontend-specialist.md
│   │   ├── backend-specialist.md
│   │   └── database-expert.md
│   └── skill/                  # Technology-specific skills
│       ├── react/              # React, Next.js, TypeScript
│       ├── vue/                # Vue.js, Nuxt
│       ├── laravel/            # Laravel, PHP
│       ├── nodejs/             # Node.js, Express
│       ├── testing/            # Jest, Vitest, PHPUnit
│       ├── documentation/      # Docs standards
│       ├── frontend-design/    # Bundled from Anthropic
│       ├── code-review/        # Bundled from Anthropic
│       └── security-guidance/  # Bundled from Anthropic
├── scripts/
│   ├── install.sh              # Main installer
│   ├── detect-tech-stack.sh    # Tech detection
│   └── update.sh               # Update to latest
└── .github/workflows/
    ├── opencode-review.yml     # PR review (all PRs)
    ├── opencode-security.yml   # Weekly security scan
    ├── opencode-issues.yml     # Issue triage
    ├── opencode-comment.yml    # /superai command
    └── meeting-ai.yml          # Meeting transcript processing
```

## Available Agents

| Agent | Role | Model | Temperature | Tools |
|-------|------|-------|-------------|-------|
| `orchestrator` | Team lead, delegates tasks | GLM-4.7 | 0.3 | Full access |
| `code-reviewer` | Code quality review | GLM-4.7 | 0.1 | Read-only |
| `security-auditor` | Security analysis | GLM-4.7 | 0.2 | Read-only |
| `implementation` | Code implementation | GLM-4.7 | 0.2 | Full access |
| `frontend-specialist` | Frontend development | GLM-4.7 | 0.3 | Full access |
| `backend-specialist` | Backend development | GLM-4.7 | 0.3 | Full access |
| `database-expert` | Database design | GLM-4.7 | 0.2 | Read + limited bash |

## Available Skills

| Skill | Technology | When to Use |
|-------|------------|-------------|
| `react` | React, Next.js, TypeScript | React projects |
| `vue` | Vue.js, Nuxt | Vue projects |
| `laravel` | Laravel, PHP | Laravel projects |
| `nodejs` | Node.js, Express | Node.js projects |
| `testing` | Jest, Vitest, PHPUnit | Testing strategies |
| `documentation` | Documentation standards | Writing docs |
| `frontend-design` | UI/UX best practices | Frontend design |
| `code-review` | Code review patterns | Code reviews |
| `security-guidance` | Security best practices | Security checks |

## GitHub Workflows

### Automatic PR Review

Every PR is automatically reviewed by SuperAI when opened or updated. The review analyzes:
- **Code Quality** - Readability, maintainability, consistency
- **Potential Issues** - Edge cases, null checks, resource leaks, performance
- **Testing** - Coverage, edge cases, test quality
- **Documentation** - Comments, API changes, breaking changes
- **Linked Issues** - Verifies PR addresses linked issues

### Issue Triage

New issues are automatically triaged with:
- **Duplicate Detection** - Searches for related issues before responding
- Issue classification (bug, feature, question, performance)
- Priority assessment (critical, high, medium, low)
- Suggested GitHub labels
- Initial response for common issues

### Weekly Security Scan

Runs every Monday at 9am UTC, checking for:
- OWASP Top 10 vulnerabilities
- Dependency vulnerabilities
- Exposed secrets
- Authentication/authorization issues

### Comment Commands

Trigger SuperAI manually on issues/PRs:
- `/superai <your request>`
- `/sai <your request>`

### Meeting AI

Intelligent meeting transcript processing with smart task/people matching:

**Usage:**
1. `/meeting-ai paste <transcript>` - Paste meeting minutes/transcript
2. AI extracts actions and shows table with confidence levels
3. `/meeting-ai feedback <comments>` - Provide feedback to revise proposals
4. `/meeting-ai approve` - Execute all approved actions

**Smart Features:**
- **Task Matching** - Semantic search to find right issues/PRs
- **People Detection** - Uses CODEOWNERS, contributor history, team membership
- **Custom Fields** - Labels, milestones, projects, assignees

**Supported Actions:**
| Action | Description |
|--------|-------------|
| `close_issue` | Close completed issues |
| `reopen_issue` | Reopen issues needing more work |
| `add_comment` | Add meeting context to issues |
| `update_labels` | Change issue labels |
| `set_milestone` | Update milestones |
| `create_issue` | Create new issues from discussion |
| `assign_user` | Assign/reassign issues |
| `request_review` | Request PR reviews |
| `merge_pr` | Merge approved PRs |
| `close_pr` | Close PRs |

**Table Output:**
```
| # | Action | Target | Confidence | People | Details | Reasoning |
|---|--------|--------|------------|--------|---------|-----------|
| action-1 | add_comment | #123 | 🟢 high | @john | Add test results... | Discussion revealed... |
```

**Legend:**
- 🟢 High confidence: Strong match found
- 🟡 Medium confidence: Likely match
- 🔴 Low confidence: Please verify before approving

## Updating

To update to the latest version:

```bash
cd .super-ai-source
./scripts/update.sh
```

## Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines on adding agents and skills.

## Requirements

- [OpenCode](https://opencode.ai/) v0.1.x or higher
- Node.js 18+ (for installer scripts)
- Bash shell (Linux/macOS/WSL)

## License

MIT

---

**Sources**:
- [OpenCode Documentation](https://opencode.ai/docs/)
- [Claude Plugins Registry](https://claude-plugins.dev/)
- [OpenCode Multi-Agent Setup Guide](https://amirteymoori.com/opencode-multi-agent-setup-specialized-ai-coding-agents/)
