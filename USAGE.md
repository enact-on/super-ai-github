# SuperAI GitHub - Usage Guide

## 🎯 Quick Start

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

## 🤖 Using Agents Locally

### Start Claude Code

```bash
claude-code
```

### Reference Agent Files

All agents are in `.claude-agents/agents/` as markdown files:

```
.claude-agents/agents/
├── orchestrator.md           # Main coordinator
├── code-reviewer.md          # Code quality
├── security-auditor.md       # Security analysis
├── implementation.md         # Code implementation
├── frontend-specialist.md    # React, Vue, UI/UX
├── backend-specialist.md     # API design, server logic
├── database-expert.md        # Database design
├── testing-specialist.md     # Testing strategies
├── devops-specialist.md      # Docker, K8s, CI/CD
└── documentation-writer.md   # Technical documentation
```

### Example Usage

```bash
# Ask Claude Code to use an agent
"Read the orchestrator.md file and delegate this task to the appropriate specialist"

# Reference specific agent
"Read the security-auditor.md file and perform a security audit on this code"

# Use skills
"Read .claude-agents/skills/react/SKILL.md and help me implement this React component"
```

## 🔧 Using Skills

### Available Skills

```
.claude-agents/skills/
├── react/           # React, Next.js, TypeScript
├── nextjs/          # Next.js 14+ App Router
├── testing/         # Jest, Vitest, Playwright
├── docker-k8s/      # Docker, Kubernetes
├── api-design/      # REST, GraphQL
└── documentation/   # Technical writing
```

### Example Usage

```bash
# For React projects
"Read .claude-agents/skills/react/SKILL.md and apply these patterns to my component"

# For testing
"Read .claude-agents/skills/testing/SKILL.md and help me write tests for this function"

# For Docker
"Read .claude-agents/skills/docker-k8s/SKILL.md and create a Dockerfile for this app"
```

## 🚀 GitHub Integration

### Setup

1. **Add GitHub Secret:**
   - Go to repository Settings → Secrets and variables → Actions
   - Add: `ANTHROPIC_API_KEY` (your Anthropic API key)

2. **Push to GitHub:**
   ```bash
   git add .
   git commit -m "Add SuperAI GitHub integration"
   git push
   ```

### What Happens Automatically

1. **PR Reviews** - Every PR gets automatic code review
2. **Security Audits** - Weekly security scans (Sundays at midnight UTC)
3. **Issue Triage** - Automatic issue classification and labeling
4. **Manual Commands** - Use `/superai help` on any issue/PR

### GitHub Workflows

```
.github/workflows/
├── claude-review.yml      # Automatic PR reviews
├── claude-security.yml    # Weekly security audits
├── claude-issues.yml      # Issue triage
└── claude-comment.yml     # Manual commands
```

## 📋 Prompt Templates

### Available Templates

```
.claude-agents/prompts/
├── code-review-prompt.md       # Code review template
├── security-audit-prompt.md    # Security audit template
├── implementation-prompt.md    # Implementation template
├── issue-triage-prompt.md      # Issue triage template
└── refactor-prompt.md          # Refactoring template
```

### Using Templates

```bash
# Use a prompt template
"Read .claude-agents/prompts/code-review-prompt.md and review my PR using this template"

# Customize a template
"Read .claude-agents/prompts/implementation-prompt.md and implement a user registration feature"
```

## 🎯 Common Use Cases

### 1. Code Review

```bash
# Local
"Read the code-reviewer.md file and review this code"

# GitHub (Automatic)
# Just create a PR, it will be reviewed automatically
```

### 2. Security Audit

```bash
# Local
"Read the security-auditor.md file and audit this code for security issues"

# GitHub (Weekly)
# Runs automatically every Sunday at midnight UTC
```

### 3. Implementation

```bash
# Local
"Read the implementation.md file and implement a REST API endpoint"

# With specific tech stack
"Read .claude-agents/skills/api-design/SKILL.md and the implementation.md file, then create a user CRUD API"
```

### 4. Testing

```bash
# Local
"Read the testing-specialist.md file and .claude-agents/skills/testing/SKILL.md, then write tests for this function"
```

### 5. Documentation

```bash
# Local
"Read the documentation-writer.md file and write API documentation for these endpoints"
```

## 🔍 Tech Stack Detection

The installer automatically detects your tech stack and installs relevant agents:

### Detection Rules

```bash
package.json          → React, Next.js, Vue, Node.js, TypeScript
composer.json         → Laravel, PHP
requirements.txt      → Python, Django, FastAPI
go.mod               → Go
Cargo.toml           → Rust
pom.xml              → Java/Maven
build.gradle         → Java/Gradle
```

### Manual Override

```bash
# Install all agents and skills
./scripts/install.sh --all

# Install specific tech stack
# (Edit the script or manually copy agent files)
```

## 📁 Project Structure After Installation

```
your-project/
├── .claude/                    # Your existing Claude Code config (NOT touched)
├── .claude-agents/             # SuperAI agents and skills (NEW)
│   ├── agents/                 # Agent definitions
│   ├── skills/                 # Tech-specific skills
│   ├── prompts/                # Reusable prompts
│   └── settings.json           # SuperAI configuration
├── .github/workflows/          # GitHub Actions workflows (NEW)
├── .super-ai-github/           # Submodule (if added as submodule)
└── .claude-install.json        # Installation record (NEW)
```

## 🔄 Updating

```bash
# If added as submodule
cd .super-ai-github
git pull origin main
./scripts/install.sh

# Or run update from your project root
cd .super-ai-github
./scripts/update.sh
```

## 🎨 Customization

### Add Custom Agents

1. Create `.claude-agents/agents/my-agent.md`
2. Reference it in Claude Code: "Read my-agent.md and help me with..."

### Add Custom Skills

1. Create `.claude-agents/skills/my-skill/SKILL.md`
2. Reference it: "Read .claude-agents/skills/my-skill/SKILL.md"

### Modify Workflows

Edit `.github/workflows/*.yml` to customize:
- Triggers
- Agent selection
- Output format
- Notifications

## 💡 Tips

1. **Always read the agent file first** - This gives Claude Code context about the agent's role
2. **Use tech-specific skills** - They provide detailed patterns for your stack
3. **Reference prompt templates** - They ensure consistent, thorough responses
4. **Let the orchestrator delegate** - For complex tasks, let it route to the right specialist
5. **Check GitHub Actions logs** - If workflows fail, review the logs for errors

## 🐛 Troubleshooting

### Agents Not Working

```bash
# Check agent files exist
ls -la .claude-agents/agents/

# Verify installation
cat .claude-install.json
```

### GitHub Workflows Not Running

1. Check `ANTHROPIC_API_KEY` secret is set
2. Verify workflow files are in `.github/workflows/`
3. Check Actions tab for error logs

### Tech Stack Detection Issues

```bash
# Install all agents/skills
./scripts/install.sh --all

# Or manually copy specific agents
cp .super-ai-github/.claude-agents/agents/frontend-specialist.md .claude-agents/agents/
```

## 📚 Additional Resources

- **Agent Files**: `.claude-agents/agents/*.md` - Detailed agent instructions
- **Skill Files**: `.claude-agents/skills/*/SKILL.md` - Tech-specific patterns
- **Prompt Templates**: `.claude-agents/prompts/*.md` - Reusable prompts
- **GitHub Setup**: `docs/GITHUB_SETUP.md` - Detailed GitHub integration guide

---

**SuperAI GitHub** - Your AI-powered development assistant 🚀