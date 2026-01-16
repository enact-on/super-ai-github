# SuperAI GitHub

> Centralized OpenCode configuration for organization-wide AI development

SuperAI GitHub provides standardized **OpenCode agents**, **skills**, and **GitHub workflows** for development teams. It enables 40+ developers across multiple technology stacks to use consistent AI coding standards while maintaining their personal OpenCode setups.

## Features

- **10 Role-based Agents** - Orchestrator delegates to specialized subagents (code reviewer, security auditor, testing specialist, DevOps specialist, etc.)
- **18 Technology Skills** - Reusable patterns for React, Vue, Next.js, Laravel, Node.js, Python, Docker/K8s, and more
- **GitHub Integration** - Automatic PR reviews, scheduled security scans, issue triage, comment-based triggers
- **MCP Integrations** - Context7, Sequential Thinking, Memory, and more
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
    ├── @code-reviewer        → Code quality analysis (read-only)
    ├── @security-auditor     → Security analysis with CWE/CVE (read-only)
    ├── @implementation       → Code implementation
    ├── @frontend-specialist  → React, Vue, UI/UX
    ├── @backend-specialist   → API design, server logic
    ├── @database-expert      → Schema, queries, migrations
    ├── @testing-specialist   → Unit/Integration/E2E tests
    ├── @devops-specialist    → Docker, K8s, CI/CD
    └── @documentation-writer → README, API docs, guides
```

This matrix approach avoids combinatorial explosion (e.g., `security-react`, `security-laravel`) while allowing specialized expertise.

## Project Structure

```
super-ai-github/
├── .opencode/                   # OpenCode configuration
│   ├── opencode.json           # Main config with agents, MCP, tools
│   ├── agent/                  # 10 Role-based agents
│   │   ├── orchestrator.md
│   │   ├── code-reviewer.md
│   │   ├── security-auditor.md
│   │   ├── implementation.md
│   │   ├── frontend-specialist.md
│   │   ├── backend-specialist.md
│   │   ├── database-expert.md
│   │   ├── testing-specialist.md
│   │   ├── devops-specialist.md
│   │   └── documentation-writer.md
│   └── skill/                  # 18 Technology-specific skills
│       ├── react/              # React, Next.js, TypeScript
│       ├── vue/                # Vue.js, Nuxt
│       ├── nextjs/             # Next.js 14+ App Router
│       ├── laravel/            # Laravel, PHP
│       ├── nodejs/             # Node.js, Express
│       ├── nestjs/             # NestJS framework
│       ├── python/             # Python, FastAPI, Django
│       ├── typescript/         # TypeScript patterns
│       ├── testing/            # Jest, Vitest, PHPUnit, pytest
│       ├── docker-k8s/         # Docker, Kubernetes
│       ├── api-design/         # REST, GraphQL, OpenAPI
│       ├── documentation/      # Documentation standards
│       ├── frontend-design/    # UI/UX patterns (bundled)
│       ├── code-review/        # Code review (bundled)
│       └── security-guidance/  # Security best practices (bundled)
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

| Agent | Role | Temperature | Tools |
|-------|------|-------------|-------|
| `orchestrator` | Team lead, delegates tasks | 0.3 | Full access |
| `code-reviewer` | Code quality review | 0.1 | Read-only |
| `security-auditor` | Security analysis (CWE/CVE) | 0.2 | Read-only |
| `implementation` | Code implementation | 0.2 | Full access |
| `frontend-specialist` | Frontend development | 0.3 | Full access |
| `backend-specialist` | Backend development | 0.3 | Full access |
| `database-expert` | Database design | 0.2 | Read + limited bash |
| `testing-specialist` | Testing (unit/integration/E2E) | 0.2 | Full access |
| `devops-specialist` | Docker, K8s, CI/CD | 0.2 | Full access |
| `documentation-writer` | Documentation | 0.4 | Read/Write (no bash) |

## Available Skills

### Frontend
| Skill | Technology | When to Use |
|-------|------------|-------------|
| `react` | React, Next.js, TypeScript | React ecosystem projects |
| `vue` | Vue.js 3, Nuxt | Vue ecosystem projects |
| `nextjs` | Next.js 14+ App Router | Server Components, Server Actions |
| `typescript` | TypeScript | Advanced type patterns |

### Backend
| Skill | Technology | When to Use |
|-------|------------|-------------|
| `nodejs` | Node.js, Express | Node.js server development |
| `nestjs` | NestJS framework | Enterprise Node.js APIs |
| `laravel` | Laravel, PHP | Laravel PHP projects |
| `python` | Python, FastAPI, Django | Python backend development |

### Infrastructure
| Skill | Technology | When to Use |
|-------|------------|-------------|
| `docker-k8s` | Docker, Kubernetes | Containerization, orchestration |
| `api-design` | REST, GraphQL, OpenAPI | API design patterns |
| `testing` | Jest, Vitest, PHPUnit, pytest | Testing strategies |

### Cross-Cutting
| Skill | Technology | When to Use |
|-------|------------|-------------|
| `documentation` | Documentation standards | Writing documentation |
| `frontend-design` | UI/UX best practices | Frontend design decisions |
| `code-review` | Code review patterns | Code reviews |
| `security-guidance` | Security best practices | Security considerations |

## MCP Integrations

| MCP Server | Status | Description |
|------------|--------|-------------|
| `context7` | Enabled | Library documentation and code context |

**Context7 MCP** provides up-to-date documentation for popular libraries and frameworks. When you ask about React, Next.js, or other frameworks, it fetches the latest docs automatically.

> **Note**: Only verified free public remote MCPs are included. To add more MCPs, update `opencode.json` and ensure they are publicly accessible.

## GitHub Workflows

### Automatic PR Review

Every PR is automatically reviewed by SuperAI when opened or updated. The review analyzes:
- **Code Quality** - Readability, maintainability, consistency
- **Potential Issues** - Edge cases, null checks, resource leaks, performance
- **Testing** - Coverage, edge cases, test quality
- **Documentation** - Comments, API changes, breaking changes
- **Linked Issues** - Verifies PR addresses linked issues

### Security Audit (Weekly)

Runs every Monday at 9am UTC, checking for:
- **OWASP Top 10** vulnerabilities with CWE references
- **Dependency vulnerabilities** with CVE references
- **Exposed secrets** - API keys, passwords, tokens
- **Authentication/authorization** issues
- Creates GitHub issues for critical/high findings

### Issue Triage

New issues are automatically triaged with:
- **Duplicate Detection** - Searches for related issues
- Issue classification (bug, feature, question, performance)
- Priority assessment (critical, high, medium, low)
- Suggested GitHub labels
- Initial response for common issues

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

**Confidence Legend:**
- 🟢 High confidence: Strong match found
- 🟡 Medium confidence: Likely match
- 🔴 Low confidence: Please verify before approving

## Delegation Decision Tree

The orchestrator uses this decision tree for task routing:

```
User Request
    │
    ├─ REVIEW task?
    │   ├─ Code review → @code-reviewer
    │   ├─ Security review → @security-auditor
    │   └─ Architecture review → @backend + @frontend specialists
    │
    ├─ IMPLEMENTATION task?
    │   ├─ Frontend code → @frontend-specialist (+ react/vue skill)
    │   ├─ Backend code → @backend-specialist (+ nodejs/laravel/python skill)
    │   ├─ Database work → @database-expert
    │   ├─ Full feature → @implementation (coordinate specialists)
    │   └─ Tests → @testing-specialist (+ testing skill)
    │
    ├─ DEVOPS task?
    │   ├─ Docker/K8s → @devops-specialist (+ docker-k8s skill)
    │   ├─ CI/CD → @devops-specialist
    │   └─ Deployment → @devops-specialist
    │
    └─ DOCUMENTATION task?
        └─ Any docs → @documentation-writer (+ documentation skill)
```

## Updating

To update to the latest version:

```bash
cd .super-ai-source
./scripts/update.sh
```

## Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines on adding agents and skills.

### Adding a New Agent

1. Create `agent/my-agent.md` with YAML frontmatter:
   ```yaml
   ---
   description: Clear description of the agent's role
   mode: subagent
   temperature: 0.2
   tools:
     write: true/false
     edit: true/false
     bash: true/false
   ---
   ```

2. Add agent to `opencode.json` under the `agent` key

3. Update orchestrator.md to include the new agent

### Adding a New Skill

1. Create `skill/my-skill/SKILL.md` with YAML frontmatter:
   ```yaml
   ---
   name: my-skill
   description: When to use this skill
   license: MIT
   compatibility: opencode
   ---
   ```

2. Include comprehensive patterns, examples, and best practices

3. Update orchestrator.md to include the new skill

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
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE Database](https://cwe.mitre.org/)
