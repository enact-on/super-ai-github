# SuperAI GitHub

> 🤖 Your AI-Powered Development Assistant - Works Locally & On GitHub

SuperAI GitHub provides **10 specialized AI agents**, **tech-specific skills**, and **GitHub Actions workflows** that work seamlessly with Claude Code. Install as a submodule in any repository to get instant AI assistance.

## ✨ Features

- **🤖 10 Specialized Agents** - From code review to security audits
- **📚 Tech-Specific Skills** - React, Next.js, Laravel, Python, Docker, K8s, and more
- **🔧 GitHub Integration** - Automatic PR reviews, security scans, issue triage
- **🎯 Smart Detection** - Auto-detects your tech stack and installs relevant agents
- **📝 Prompt Templates** - Reusable templates for common tasks
- **🔒 Non-Invasive** - Never touches your `.claude/` directory

## 🚀 Quick Start

### For Any Repository

```bash
# 1. Add as submodule
git submodule add https://github.com/enact-on/super-ai-github.git .super-ai-github
cd .super-ai-github

# 2. Run installer
./scripts/install.sh

# 3. Use Claude Code normally
claude-code
```

### What Gets Installed

- **`.claude-agents/`** - All agents and skills (NEVER touches your `.claude/`)
- **`.github/workflows/`** - Automated workflows for GitHub Actions
- **Tech-specific agents** - Based on your project's detected tech stack

## 🤖 Using Agents

### Reference Agent Files

All agents are in `.claude-agents/agents/` as markdown files:

```bash
# Use the orchestrator to delegate tasks
"Read the orchestrator.md file and help me implement this feature"

# Use specific specialists
"Read the security-auditor.md file and audit this code for security issues"
"Read the frontend-specialist.md file and review this React component"
```

### Available Agents

| Agent | Role | Best For |
|-------|------|----------|
| **Orchestrator** | Team lead | Complex task coordination |
| **Code Reviewer** | Quality analysis | PR reviews, code quality |
| **Security Auditor** | Security analysis | Security audits, vulnerability scanning |
| **Implementation** | Code writing | Feature implementation |
| **Frontend Specialist** | React/Vue/UI | Frontend development |
| **Backend Specialist** | API/Server logic | Backend development |
| **Database Expert** | DB design | Database optimization |
| **Testing Specialist** | Test strategies | Test implementation |
| **DevOps Specialist** | Docker/K8s/CI/CD | Infrastructure |
| **Documentation Writer** | Technical docs | Documentation |

## 📚 Using Skills

### Tech-Specific Skills

```bash
# React projects
"Read .claude-agents/skills/react/SKILL.md and apply these patterns"

# Next.js projects
"Read .claude-agents/skills/nextjs/SKILL.md and help with Server Components"

# Testing
"Read .claude-agents/skills/testing/SKILL.md and write tests for this code"
```

## 🚀 GitHub Integration

### Setup

1. **Add GitHub Secret:**
   - Go to repository **Settings** → **Secrets and variables** → **Actions**
   - Add: `ANTHROPIC_API_KEY` (your Anthropic API key)

2. **Push to GitHub:**
   ```bash
   git add .
   git commit -m "Add SuperAI GitHub integration"
   git push
   ```

### What Happens Automatically

- **📋 PR Reviews** - Every PR gets automatic code review
- **🔒 Security Audits** - Weekly security scans (Sundays at midnight UTC)
- **🏷️ Issue Triage** - Automatic issue classification and labeling
- **💬 Manual Commands** - Use `/superai help` on any issue/PR

## 📋 Prompt Templates

### Reusable Prompts

```bash
# Code review
"Read .claude-agents/prompts/code-review-prompt.md and review this PR"

# Security audit
"Read .claude-agents/prompts/security-audit-prompt.md and audit this code"

# Implementation
"Read .claude-agents/prompts/implementation-prompt.md and implement this feature"
```

## 📁 Project Structure

```
your-project/
├── .claude/                    # Your existing config (NOT touched) ✅
├── .claude-agents/             # SuperAI agents and skills (NEW) 🆕
│   ├── agents/                 # 10 specialized agents
│   ├── skills/                 # Tech-specific skills
│   ├── prompts/                # Reusable prompts
│   └── settings.json           # Configuration
├── .github/workflows/          # Automated workflows (NEW) 🆕
└── .super-ai-github/           # Submodule reference
```

## 🎯 Usage Examples

### Local Development

```bash
# Start Claude Code
claude-code

# Ask it to use agents
"Read the orchestrator.md file and coordinate a code review for this PR"
"Read the testing-specialist.md file and write tests for this function"
"Read .claude-agents/skills/react/SKILL.md and refactor this component"
```

### GitHub Integration

```bash
# Automatic (just create PR)
git checkout -b feature-branch
# Make changes
git push origin feature-branch
# Create PR on GitHub → Automatic review happens

# Manual (on any issue/PR)
/superai help
/superai review this code
/superai explain the authentication logic
```

## 🔍 Tech Stack Detection

The installer automatically detects your tech stack:

```bash
package.json          → React, Next.js, Vue, Node.js, TypeScript
composer.json         → Laravel, PHP
requirements.txt      → Python, Django, FastAPI
go.mod               → Go
```

### Manual Override

```bash
# Install all agents and skills
./scripts/install.sh --all
```

## 🔄 Updating

```bash
cd .super-ai-github
git pull origin main
./scripts/install.sh
```

## 📖 Documentation

- **[USAGE.md](USAGE.md)** - Comprehensive usage guide
- **[docs/GITHUB_SETUP.md](docs/GITHUB_SETUP.md)** - Detailed GitHub setup
- **[MIGRATION_SUMMARY.md](MIGRATION_SUMMARY.md)** - Migration overview

## 🛠️ How It Works

### Local Development

1. **Install** - Run the installer script
2. **Reference** - Point Claude Code to agent/skill files
3. **Execute** - Agents provide specialized assistance

### GitHub Integration

1. **Install** - Run the installer script
2. **Push** - Push to GitHub with `ANTHROPIC_API_KEY` secret
3. **Automate** - Workflows run automatically on PRs, issues, schedules

## 🎨 Customization

### Add Custom Agents

```bash
# Create your own agent
echo "# My Custom Agent

Custom instructions here..." > .claude-agents/agents/my-agent.md
```

### Add Custom Skills

```bash
# Create your own skill
mkdir -p .claude-agents/skills/my-skill
echo "# My Skill

Custom patterns here..." > .claude-agents/skills/my-skill/SKILL.md
```

## 📊 Agent Architecture

```
User Request
    ↓
Orchestrator (coordinates)
    ↓
Technology Detection + Skill Loading
    ↓
Specialist Agent (executes)
    ↓
Code Reviewer | Security | Implementation | etc.
    ↓
Results (quality assistance)
```

## 🌟 Benefits

### For Developers
- **Instant AI Assistance** - No setup required, just reference agent files
- **Specialized Expertise** - Each agent focuses on their domain
- **Consistent Quality** - Same standards across all projects
- **Learning Opportunity** - Get feedback from AI specialists

### For Teams
- **Scalable Code Review** - Handle 100+ repositories easily
- **Automated Security** - Regular vulnerability scans
- **Standardized Processes** - Same review criteria everywhere
- **Reduced Manual Work** - Automate routine tasks

### For Organizations
- **Cost Effective** - One API key, unlimited usage
- **Easy Onboarding** - Simple install for new repos
- **Flexible Deployment** - Works with any tech stack
- **Centralized Updates** - Update once, affect all repos

## 🛡️ Security

- **Never touches `.claude/`** - Your local config is safe
- **API Key in GitHub Secrets** - Secure credential storage
- **Read-only agents** - Review agents can't modify code
- **Standard Anthropic API** - No custom providers required

## 🤝 Contributing

Contributions welcome! See `docs/CONTRIBUTING.md` for guidelines.

## 📄 License

MIT License - See LICENSE file for details

---

**SuperAI GitHub** - Your AI-powered development assistant 🚀

*Part of the SuperAI ecosystem - Centralized AI development for teams*

## Features

- **10 Role-based Agents** - Orchestrator delegates to specialized agents (code reviewer, security auditor, testing specialist, DevOps specialist, etc.)
- **18 Technology Skills** - Reusable patterns for React, Vue, Next.js, Laravel, Node.js, Python, Docker/K8s, and more
- **GitHub Integration** - Automatic PR reviews, scheduled security scans, issue triage, comment-based triggers
- **Claude Code Native** - Uses standard Claude Code configuration and workflows
- **Zero Configuration** - Uses standard `.claude/` directory structure
- **Custom Provider Support** - Works with custom Anthropic-compatible providers

## Quick Start

### For Developers

1. **Clone or add as submodule** to your project:
   ```bash
   # Option 1: Clone directly
   git clone https://github.com/enact-on/super-ai-github.git
   cd super-ai-github
   ./scripts/install.sh

   # Option 2: Add as submodule
   git submodule add https://github.com/enact-on/super-ai-github.git .super-ai-source
   cd .super-ai-source
   ./scripts/install.sh
   ```

2. **Use locally**:
   ```bash
   cd /path/to/your/project
   claude-code
   ```

3. **Check available agents**: Type `/agents` in Claude Code

### For GitHub Integration

1. Add `ANTHROPIC_API_KEY` to your repository secrets
2. Add `CUSTOM_ANTHROPIC_BASE_URL` if using a custom provider
3. Push to GitHub
4. Open a PR to see SuperAI review automatically

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
├── .claude/                     # Claude Code configuration
│   └── settings.json           # Main Claude Code settings
├── .claude-agents/              # Agent definitions
│   ├── agents/                 # 10 Role-based agents
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
│   ├── skills/                 # Technology-specific skills
│   └── prompts/                # Reusable prompt templates
├── scripts/
│   ├── install.sh              # Main installer
│   ├── detect-tech-stack.sh    # Tech detection
│   └── update.sh               # Update to latest
└── .github/workflows/
    ├── claude-review.yml       # PR review (all PRs)
    ├── claude-security.yml     # Weekly security scan
    ├── claude-issues.yml       # Issue triage
    └── claude-comment.yml      # /superai command
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

## GitHub Workflows

### Automatic PR Review

Every PR is automatically reviewed by SuperAI when opened or updated. The review analyzes:
- **Code Quality** - Readability, maintainability, consistency
- **Potential Issues** - Edge cases, null checks, resource leaks, performance
- **Testing** - Coverage, edge cases, test quality
- **Documentation** - Comments, API changes, breaking changes
- **Linked Issues** - Verifies PR addresses linked issues

### Security Audit (Weekly)

Runs every Sunday at midnight UTC, checking for:
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
- `/claude <your request>`

## Requirements

- [Claude Code](https://claude.ai/code) v1.0 or higher
- Node.js 18+ (for installer scripts)
- Bash shell (Linux/macOS/WSL)
- GitHub account (for GitHub integration)

## License

MIT

---

**SuperAI GitHub** - Centralized Claude Code configuration for organization-wide AI development

## Updating

To update to the latest version:

```bash
cd .super-ai-source
./scripts/update.sh
```

## Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines on adding agents and skills.

### Adding a New Agent

1. Create `.claude-agents/agents/my-agent.md` with proper structure
2. Include clear description of the agent's role and expertise
3. Update orchestrator.md to include the new agent in delegation logic

### Adding a New Skill

1. Create `.claude-agents/skills/my-skill/SKILL.md`
2. Include comprehensive patterns, examples, and best practices
3. Update orchestrator.md to include the new skill

## Environment Variables

- `ANTHROPIC_API_KEY` - Your Anthropic API key (or custom provider key)
- `CUSTOM_ANTHROPIC_BASE_URL` - Optional: Custom provider base URL
- `CLAUDE_CODE_CONFIG_DIR` - Defaults to `.claude-agents`

## GitHub Secrets Required

For GitHub integration, add these secrets to your repository:

- `ANTHROPIC_API_KEY` - Required: API key for Claude Code
- `CUSTOM_ANTHROPIC_BASE_URL` - Optional: Custom provider URL
