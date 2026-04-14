# SuperAI GitHub - Complete Implementation Context

## 📋 Project Overview

**Repository:** https://github.com/enact-on/super-ai-github

**Purpose:** A centralized, self-contained AI-powered development assistant that works both locally with Claude Code and on GitHub via Actions. The system uses specialized AI agents, tech-specific skills, and GitHub Actions workflows to provide automated code reviews, security audits, issue triage, and implementation assistance.

## 🎯 Core Philosophy

### Non-Invasive Design
- **Never touches user's `.claude/` directory** - All configuration is self-contained in `.claude-agents/`
- Works alongside existing Claude Code setups without interference
- Submodule-based architecture for easy updates
- Zero configuration required for basic usage

### Universal Provider Support
- Supports standard Anthropic API: `https://api.anthropic.com`
- Supports custom Anthropic-compatible providers (e.g., OpenCode, Zhipu AI)
- Environment variable configuration for both local and GitHub
- No hardcoded provider dependencies

### Smart Tech Detection
- Automatically detects project technology stack
- Installs only relevant agents and skills
- Supports multi-technology projects
- Manual override available with `--all` flag

## 🤖 Agent System

### Agent Architecture

```
User Request
    ↓
Orchestrator (Primary Agent)
    ↓
Technology Detection + Skill Loading
    ↓
Specialist Agent (executes)
    ↓
Results Synthesis
```

### Available Agents (10)

| Agent | File | Role | Temperature | When to Use |
|-------|------|------|-------------|-------------|
| **Orchestrator** | `.claude-agents/agents/orchestrator.md` | Primary coordinator | 0.3 | Complex task delegation |
| **Code Reviewer** | `.claude-agents/agents/code-reviewer.md` | Code quality analysis | 0.1 | PR reviews, best practices |
| **Security Auditor** | `.claude-agents/agents/security-auditor.md` | Security analysis | 0.2 | OWASP/CWE/CVE audits |
| **Implementation** | `.claude-agents/agents/implementation.md` | Code writing | 0.2 | Feature implementation |
| **Frontend Specialist** | `.claude-agents/agents/frontend-specialist.md` | Frontend dev | 0.3 | React, Vue, UI/UX |
| **Backend Specialist** | `.claude-agents/agents/backend-specialist.md` | Backend dev | 0.3 | API, server logic |
| **Database Expert** | `.claude-agents/agents/database-expert.md` | Database work | 0.2 | Schema, queries, migrations |
| **Testing Specialist** | `.claude-agents/agents/testing-specialist.md` | Testing | 0.2 | Unit/integration/E2E |
| **DevOps Specialist** | `.claude-agents/agents/devops-specialist.md` | DevOps/CI/CD | 0.2 | Docker, K8s, pipelines |
| **Documentation Writer** | `.claude-agents/agents/documentation-writer.md` | Documentation | 0.4 | Technical writing |

### Agent Usage

**Local Development:**
```bash
claude-code
"Read the orchestrator.md file and help me review this PR"
"Read the security-auditor.md file and audit this code"
"Read .claude-agents/skills/react/SKILL.md and refactor this component"
```

**GitHub Integration:**
- Automatic PR reviews via `claude-review.yml`
- Weekly security audits via `claude-security.yml`
- Issue triage via `claude-issues.yml`
- Manual commands: `/superai <request>`

## 📚 Skills System

### Available Skills (15)

#### Frontend Skills
- **react** - React, Next.js, TypeScript patterns
- **vue** - Vue.js 3, Nuxt patterns
- **nextjs** - Next.js 14+ App Router, Server Components
- **typescript** - Advanced TypeScript patterns
- **frontend-design** - UI/UX design principles

#### Backend Skills
- **laravel** - Laravel, PHP, Filament patterns
- **nodejs** - Node.js, Express patterns
- **nestjs** - NestJS enterprise patterns
- **python** - FastAPI, Django patterns

#### Infrastructure Skills
- **docker-k8s** - Docker, Kubernetes patterns
- **api-design** - REST, GraphQL, OpenAPI
- **testing** - Jest, Vitest, Playwright patterns

#### Cross-Cutting Skills
- **documentation** - Technical writing standards
- **code-review** - Code review guidelines
- **security-guidance** - Security best practices

### Skill Usage

```bash
# Local development
claude-code
"Read .claude-agents/skills/laravel/SKILL.md and review this Laravel code"
"Read .claude-agents/skills/nextjs/SKILL.md and implement this Server Component"
"Read .claude-agents/skills/docker-k8s/SKILL.md and create a Dockerfile"
```

## 📝 Prompt Templates

### Available Templates (5)

1. **code-review-prompt.md** - Comprehensive code review template
2. **security-audit-prompt.md** - OWASP/CWE/CVE security audit template
3. **implementation-prompt.md** - Feature implementation template
4. **issue-triage-prompt.md** - Issue triage and classification template
5. **refactor-prompt.md** - Code refactoring template

### Template Usage

```bash
claude-code
"Read .claude-agents/prompts/code-review-prompt.md and review this PR"
"Read .claude-agents/prompts/security-audit-prompt.md and audit this code"
```

## 🚀 Installation System

### Submodule-Based Architecture

```bash
# Add to any project
git submodule add https://github.com/enact-on/super-ai-github.git .super-ai-github

# Install from project root (NOT from inside submodule!)
./scripts/install.sh
```

### Smart Tech Detection

**Detection Rules:**
- `package.json` → React, Next.js, Vue, Node.js, TypeScript
- `composer.json` → Laravel, PHP, Filament
- `requirements.txt` → Python, Django, FastAPI
- `next.config.js` → Next.js
- `vite.config.js` → Vite
- `artisan` file → Laravel

**Installation Logic:**
1. Detect parent project's tech stack (even when run from submodule)
2. Install core agents (always installed)
3. Install tech-specific agents based on detection
4. Install relevant skills for detected technologies
5. Copy GitHub workflows
6. Save installation state

### Directory Structure

```
your-project/
├── .claude/                    # User's existing config (NOT touched) ✅
├── .claude-agents/             # SuperAI system (NEW) 🆕
│   ├── agents/                 # Agent definitions (.md files)
│   ├── skills/                 # Tech skills (SKILL.md files)
│   ├── prompts/                # Reusable prompts
│   └── settings.json           # Configuration
├── .github/workflows/          # GitHub Actions 🆕
└── .super-ai-github/           # Submodule reference
```

## 🔧 GitHub Integration

### Required GitHub Secrets

Add these secrets to repositories using SuperAI:

**Required:**
- `ANTHROPIC_API_KEY` - Anthropic API key

**Optional:**
- `ANTHROPIC_BASE_URL` - Custom provider URL (e.g., `https://api.z.ai/api/anthropic`)

### GitHub Actions Workflows

#### 1. claude-review.yml
**Triggers:** PR opened, updated, ready for review
**Purpose:** Automatic code review for all PRs
**Reviews:** Code quality, best practices, potential issues, testing, documentation

#### 2. claude-security.yml
**Triggers:** Weekly (Sundays at midnight UTC) or manual
**Purpose:** Automated security vulnerability scanning
**Checks:** OWASP Top 10, dependency CVEs, exposed secrets, auth issues

#### 3. claude-issues.yml
**Triggers:** Issue opened or edited
**Purpose:** Automatic issue triage and classification
**Features:** Duplicate detection, type classification, priority assessment, label suggestions

#### 4. claude-comment.yml
**Triggers:** Comments with `/superai`, `/sai`, `/claude`
**Purpose:** Manual AI assistance on issues and PRs
**Commands:** `/superai help`, `/superai review`, `/superai explain`

## 🎯 Use Cases

### Local Development

```bash
# Start Claude Code
claude-code

# Delegate tasks to orchestrator
"Read the orchestrator.md file and coordinate a code review for this PR"

# Get specialized help
"Read the frontend-specialist.md file and review this React component"
"Read the security-auditor.md file and audit this Laravel code"

# Use tech-specific skills
"Read .claude-agents/skills/laravel/SKILL.md and improve this Filament resource"
"Read .claude-agents/skills/nextjs/SKILL.md and optimize this Server Component"

# Use prompt templates
"Read .claude-agents/prompts/code-review-prompt.md and review this PR"
"Read .claude-agents/prompts/security-audit-prompt.md and perform security audit"
```

### GitHub Automation

**Automatic (No Manual Trigger):**
- Every PR gets comprehensive code review
- Weekly security audits (Sundays at midnight UTC)
- New issues are automatically triaged
- Tech stack detected for relevant agent selection

**Manual Commands:**
```bash
# On any issue or PR
/superai help
/superai review this code
/superai explain the authentication system
/superai suggest improvements
```

## 🧪 Testing Guide

### Test Repositories

1. **Next.js Blog Starter** (vercel/next.js-blog-starter)
   - Tech: Next.js, React, Markdown
   - Tests: Static blog patterns, Server Components
   - Focus: Next.js 14+ best practices

2. **Filament PHP Demo** (filamentphp/demo)
   - Tech: Laravel, Filament, PHP, Vite
   - Tests: Admin panel patterns, Laravel best practices
   - Focus: Filament resources, security

3. **Lead Agent** (vercel/lead-agent)
   - Tech: Next.js, AI SDK, Workflow DevKit
   - Tests: AI integration, workflow design
   - Focus: Architecture, type safety

### Testing Process

```bash
# For each repository:
cd test-repo
git submodule add https://github.com/enact-on/super-ai-github.git .super-ai-github
./scripts/install.sh

# Local testing
claude-code
"Read the orchestrator.md file and review this codebase"

# GitHub testing
# Add ANTHROPIC_API_KEY + ANTHROPIC_BASE_URL secrets
# Push and create PR
# Verify automatic reviews work
```

## 🎨 Customization

### Adding Custom Agents

1. Create `.claude-agents/agents/my-agent.md`
2. Add role and expertise details
3. Reference in orchestrator.md

### Adding Custom Skills

1. Create `.claude-agents/skills/my-skill/SKILL.md`
2. Add technology-specific patterns
3. Reference in relevant agents

### Modifying Workflows

Edit `.github/workflows/*.yml` to customize:
- Trigger conditions
- Agent selection
- Output format
- Notifications

## 📊 Technical Implementation

### Configuration Files

**Local (.claude/settings.json):**
```json
{
  "model": "claude-opus-4-6",
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "your-key",
    "ANTHROPIC_BASE_URL": "https://api.anthropic.com",
    "CUSTOM_ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic"
  }
}
```

**GitHub Secrets:**
```
ANTHROPIC_API_KEY=sk-ant-xxxxx
ANTHROPIC_BASE_URL=https://api.anthropic.com (or custom)
```

### File Format

**Agents:** Markdown files with role, expertise, and patterns
**Skills:** Markdown files with technology-specific patterns
**Prompts:** Markdown templates for consistent execution
**Settings:** JSON configuration for repository

## 🔐 Security

### Security Features

1. **Non-invasive design** - Never modifies user's `.claude/` directory
2. **Read-only review agents** - Code reviewers can't modify code
3. **Secret management** - Uses GitHub Actions secrets for API keys
4. **Custom provider support** - Works with any Anthropic-compatible API
5. **Submodule isolation** - Updates managed via git submodules

### Security Audits

Weekly automated security checks cover:
- OWASP Top 10 vulnerabilities
- Dependency CVEs
- Exposed secrets
- Authentication issues
- Input validation
- Configuration security

## 📈 Maintenance

### Updating System

```bash
# Update submodule to latest version
cd .super-ai-github
git pull origin main

# Reinstall to get latest agents/skills
./scripts/install.sh
```

### Version Management

- Main repository uses semantic versioning
- Tagged releases for stability
- Changelog maintained for tracking changes
- Backward compatibility preserved when possible

## 🎯 Success Criteria

### Installation
- [x] Script runs without errors
- [x] Correct tech stack detected
- [x] Appropriate agents installed
- [x] User's `.claude/` untouched
- [x] GitHub workflows added

### Local Usage
- [x] Can reference agent files in Claude Code
- [x] Agents provide relevant, tech-specific advice
- [x] Skills offer detailed patterns
- [x] Prompt templates work consistently

### GitHub Integration
- [x] Workflows trigger on correct events
- [x] AI comments are helpful and accurate
- [x] Security audits run weekly
- [x] Manual commands work properly
- [x] Custom provider support works

## 🚀 Quick Reference

### Installation Commands

```bash
# Add to project
git submodule add https://github.com/enact-on/super-ai-github.git .super-ai-github

# Install (run from project root!)
./scripts/install.sh

# Update
cd .super-ai-github && git pull origin main && ./scripts/install.sh
```

### Local Usage

```bash
claude-code
"Read the orchestrator.md file and help me with..."
```

### GitHub Setup

```bash
# Add secrets
gh secret set ANTHROPIC_API_KEY "sk-ant-xxxxx"
gh secret set ANTHROPIC_BASE_URL "https://api.anthropic.com"

# Test
git push origin main
# Create PR → Automatic review
```

## 📚 Documentation Files

- **README.md** - Project overview and quick start
- **USAGE.md** - Comprehensive usage guide
- **docs/GITHUB_SETUP.md** - Detailed GitHub integration setup
- **docs/TESTING_GUIDE.md** - Testing guide for specific repositories
- **CORRECT_USAGE.md** - Proper installation instructions
- **IMPLEMENTATION_COMPLETE.md** - Complete implementation overview
- **FINAL_UPDATE.md** - Final update summary

## 🎊 Key Achievements

✅ **Complete agent system** (10 specialized agents)
✅ **Comprehensive skills library** (15 tech skills)
✅ **Smart tech stack detection** (auto-detects project stack)
✅ **Non-invasive design** (never touches `.claude/`)
✅ **Universal provider support** (any Anthropic-compatible API)
✅ **GitHub Actions integration** (automated workflows)
✅ **Submodule architecture** (easy updates)
✅ **Comprehensive documentation** (usage guides, testing)
✅ **Production-ready** (tested on multiple repositories)

---

**SuperAI GitHub - Your AI-powered development assistant**

*Last Updated: April 2024*
*Version: 1.0.0*
*License: MIT*