# 🧪 SuperAI GitHub - Testing Guide

## 📋 Test Repositories

Your TL wants you to test the SuperAI agents on these repositories:

1. **Next.js Blog Starter** - Static blog with Next.js + Markdown
2. **Filament PHP Demo** - Laravel admin panel demo
3. **Lead Agent** - AI-powered lead qualification agent (Next.js)

---

## 🚀 Step-by-Step Testing Process

### Step 1: Clone and Setup Each Repository

```bash
# Create testing directory
mkdir ~/super-ai-testing
cd ~/super-ai-testing

# Clone repositories
git clone https://github.com/vercel/next.js-blog-starter.git nextjs-blog
git clone https://github.com/filamentphp/demo.git filament-demo
git clone https://github.com/vercel/lead-agent.git lead-agent

# Add SuperAI as submodule to each
cd nextjs-blog
git submodule add https://github.com/enact-on/super-ai-github.git .super-ai-github
cd .super-ai-github && ./scripts/install.sh

cd ../filament-demo
git submodule add https://github.com/enact-on/super-ai-github.git .super-ai-github
cd .super-ai-github && ./scripts/install.sh

cd ../lead-agent
git submodule add https://github.com/enact-on/super-ai-github.git .super-ai-github
cd .super-ai-github && ./scripts/install.sh
```

### Step 2: Local Testing with Claude Code

#### Test 1: Next.js Blog Starter

```bash
cd ~/super-ai-testing/nextjs-blog
claude-code
```

**Test Commands:**

```bash
# 1. General Code Review
"Read the code-reviewer.md file and review the src/ directory for Next.js best practices"

# 2. React/Next.js Specific Review
"Read .claude-agents/skills/nextjs/SKILL.md and the frontend-specialist.md file, then analyze this Next.js blog for App Router patterns and Server Component usage"

# 3. Performance Analysis
"Read the implementation.md file and suggest performance improvements for the blog's markdown processing"

# 4. Documentation Review
"Read the documentation-writer.md file and review the README.md, suggest improvements"
```

#### Test 2: Filament PHP Demo

```bash
cd ~/super-ai-testing/filament-demo
claude-code
```

**Test Commands:**

```bash
# 1. Laravel Code Review
"Read .claude-agents/skills/laravel/SKILL.md and review the app/ directory for Laravel best practices"

# 2. Filament Specific Review
"Read the backend-specialist.md file and analyze the Filament resources, panels, and configurations"

# 3. Database Analysis
"Read the database-expert.md file and review the migrations and database relationships"

# 4. Security Audit
"Read the security-auditor.md file and audit the admin panel for security vulnerabilities"
```

#### Test 3: Lead Agent (Vercel)

```bash
cd ~/super-ai-testing/lead-agent
claude-code
```

**Test Commands:**

```bash
# 1. Next.js + AI Integration Review
"Read .claude-agents/skills/nextjs/SKILL.md and review the AI SDK integration and Workflow DevKit usage"

# 2. Architecture Analysis
"Read the orchestrator.md file and analyze the agent architecture and workflow design"

# 3. Type Safety Review
"Read .claude-agents/skills/typescript/SKILL.md and review the TypeScript usage and type definitions"

# 4. Testing Review
"Read the testing-specialist.md file and evaluate the test coverage and testing approach"
```

### Step 3: GitHub Integration Testing

For each repository, test the GitHub Actions workflows:

```bash
# Add GitHub Secrets to each repository:
# ANTHROPIC_API_KEY - Your Anthropic API key
# ANTHROPIC_BASE_URL - Your custom provider URL (if using custom provider)

# Push to GitHub
cd ~/super-ai-testing/nextjs-blog
git add .
git commit -m "Add SuperAI GitHub integration"
git push origin main

# Create a test PR
git checkout -b feature/test-super-ai
# Make some changes
git push origin feature/test-super-ai
# Create PR on GitHub → Automatic review should happen
```

### Step 4: Manual GitHub Commands

Test the manual command triggers on GitHub issues/PRs:

```bash
# On any issue or PR, comment:
/superai help
/superai review this code
/superai explain the architecture
/superai suggest improvements
```

---

## 📊 Testing Checklist

### Next.js Blog Starter

**✅ Tech Stack Detection**
- [ ] Detects Next.js from package.json
- [ ] Installs frontend-specialist
- [ ] Installs nextjs skill
- [ ] Installs typescript skill

**✅ Local Testing**
- [ ] Claude Code can read agent files
- [ ] Code review works on Next.js code
- [ ] Performance suggestions provided
- [ ] Next.js best practices followed

**✅ GitHub Integration**
- [ ] PR review workflow triggers
- [ ] AI comments appear on PR
- [ ] Security audit runs weekly
- [ ] Manual commands work

### Filament PHP Demo

**✅ Tech Stack Detection**
- [ ] Detects Laravel from composer.json
- [ ] Detects Filament from composer.json
- [ ] Installs backend-specialist
- [ ] Installs laravel skill

**✅ Local Testing**
- [ ] Claude Code reviews PHP code
- [ ] Laravel patterns identified
- [ ] Filament resources analyzed
- [ ] Security audit performed

**✅ GitHub Integration**
- [ ] PHP code reviews work
- [ ] Laravel-specific feedback
- [ ] Database analysis provided
- [ ] Admin panel security checked

### Lead Agent

**✅ Tech Stack Detection**
- [ ] Detects Next.js + AI SDK
- [ ] Installs frontend-specialist
- [ ] Installs nextjs skill
- [ ] Installs typescript skill

**✅ Local Testing**
- [ ] AI integration reviewed
- [ ] Workflow analysis performed
- [ ] Type safety evaluated
- [ ] Testing assessed

**✅ GitHub Integration**
- [ ] Complex architecture reviewed
- [ ] AI patterns evaluated
- [ ] Test coverage analyzed
- [ ] Integration quality assessed

---

## 🎯 Specific Test Scenarios

### Scenario 1: Code Review

```bash
# Test on Next.js Blog
"Read the code-reviewer.md file and review app/page.tsx for Next.js App Router patterns"

# Test on Filament Demo
"Read the code-reviewer.md file and review app/Filament/Resources/UserResource.php"

# Test on Lead Agent
"Read the code-reviewer.md file and review app/api/agent/route.ts"
```

### Scenario 2: Security Audit

```bash
# Test on all repositories
"Read the security-auditor.md file and perform a comprehensive security audit of this repository"

# Check for OWASP Top 10
"Read .claude-agents/prompts/security-audit-prompt.md and audit this code for vulnerabilities"
```

### Scenario 3: Feature Implementation

```bash
# Test implementation capability
"Read the implementation.md file and implement a new feature: add dark mode support to the blog"

# Test with specific tech stack
"Read .claude-agents/skills/react/SKILL.md and the implementation.md file, then add a search component to the blog"
```

### Scenario 4: Documentation

```bash
# Test documentation generation
"Read the documentation-writer.md file and create API documentation for the Filament admin panel"

# Test README improvements
"Read the documentation-writer.md file and improve the README.md with better setup instructions"
```

---

## 📈 Expected Results

### What Should Happen

**1. Installation**
- Scripts run without errors
- Correct agents installed for each tech stack
- GitHub workflows added successfully

**2. Local Usage**
- Claude Code can read agent files
- Agents provide relevant, tech-specific advice
- Skills offer detailed patterns and best practices
- Prompt templates work consistently

**3. GitHub Integration**
- Workflows trigger on PRs/issues
- AI comments are helpful and accurate
- Security audits run weekly
- Manual commands respond appropriately

**4. Cross-Repository Testing**
- Each repo gets appropriate specialized agents
- Tech stack detection works correctly
- Mixed tech stacks handled properly

### Success Criteria

✅ **Installation**: All 3 repositories install without errors
✅ **Tech Detection**: Correct agents/skills installed for each stack
✅ **Local Usage**: Claude Code provides useful assistance
✅ **GitHub Actions**: Workflows run and provide valuable feedback
✅ **Manual Commands**: `/superai` commands work on issues/PRs
✅ **Code Quality**: Reviews identify real issues and improvements
✅ **Security**: Security audits find vulnerabilities
✅ **Performance**: Performance suggestions are practical

---

## 🐛 Troubleshooting

### Installation Issues

```bash
# If install fails
cd .super-ai-github
git pull origin main
./scripts/install.sh --all  # Install all agents

# If tech detection fails
# Manually copy specific agents
cp .super-ai-github/.claude-agents/agents/frontend-specialist.md .claude-agents/agents/
```

### Claude Code Issues

```bash
# If agents not found
ls -la .claude-agents/agents/

# If skills not loading
ls -la .claude-agents/skills/

# Reinstall
cd .super-ai-github
./scripts/install.sh
```

### GitHub Workflow Issues

```bash
# Check secrets are set
gh secret list

# Check workflow files
ls -la .github/workflows/

# Test workflow manually
gh workflow run claude-review.yml
```

---

## 📝 Test Report Template

After testing, create a report like this:

```markdown
# SuperAI Testing Report - [Repository Name]

## Installation
- [ ] Install script ran successfully
- [ ] Correct agents installed
- [ ] Tech stack detected correctly

## Local Testing
- [ ] Code review worked
- [ ] Tech-specific advice was relevant
- [ ] Skills provided helpful patterns
- [ ] Implementation assistance worked

## GitHub Integration
- [ ] PR review workflow triggered
- [ ] AI comments were helpful
- [ ] Security audit ran
- [ ] Manual commands worked

## Issues Found
[List any issues encountered]

## Recommendations
[Suggestions for improvement]

## Overall Assessment
[Pass/Fail with comments]
```

---

**Ready to test! Start with any repository and let me know the results.** 🚀

*SuperAI GitHub - Your AI-powered development assistant*