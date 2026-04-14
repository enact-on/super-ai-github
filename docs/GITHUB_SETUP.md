# GitHub Integration Setup Guide

This guide walks you through setting up SuperAI GitHub with GitHub Actions for automated code reviews, security audits, and issue triage.

## Prerequisites

- GitHub repository
- Claude Code API key (or custom provider key)
- Admin access to repository settings

## Step 1: Install SuperAI in Your Repository

```bash
# Clone or add as submodule
git clone https://github.com/enact-on/super-ai-github.git
cd super-ai-github
./scripts/install.sh
```

This will:
- Create `.claude/` directory with Claude Code configuration
- Create `.claude-agents/` directory with agent definitions
- Add GitHub Actions workflows to `.github/workflows/`
- Set up proper directory structure

## Step 2: Configure GitHub Secrets

Navigate to your repository settings and add the following secrets:

### Required Secrets

**`ANTHROPIC_API_KEY`**
- Your Claude Code API key
- Get it from: https://console.anthropic.com/
- Format: `sk-ant-xxxxx...`

### Optional Secrets

**`CUSTOM_ANTHROPIC_BASE_URL`**
- If using a custom provider (e.g., OpenCode, Zhipu AI)
- Example: `https://api.z.ai/api/anthropic`

### Adding Secrets

1. Go to repository **Settings**
2. Click **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret with its value

## Step 3: Customize Configuration (Optional)

### Edit `.claude/settings.json`

```json
{
  "model": "claude-sonnet-4-6",
  "env": {
    "ANTHROPIC_API_KEY": "your-key-here",
    "ANTHROPIC_BASE_URL": "https://api.anthropic.com",
    "CLAUDE_CODE_CONFIG_DIR": ".claude-agents"
  },
  "permissions": {
    "allow": ["Bash", "Read", "Edit", "Write", "Grep", "Glob", "Agent", "Skill"]
  }
}
```

### Customize Agent Behavior

Edit agent definitions in `.claude-agents/agents/` to customize behavior for your project.

## Step 4: Push to GitHub

```bash
git add .
git commit -m "Add SuperAI GitHub integration"
git push
```

## Step 5: Test the Integration

### Test PR Review

1. Create a new pull request
2. SuperAI will automatically review the PR
3. Check the Actions tab for workflow status
4. Review comments will be posted on the PR

### Test Issue Triage

1. Create a new issue
2. SuperAI will automatically triage it
3. Labels and suggestions will be added

### Test Comment Commands

1. Open an issue or PR
2. Comment with `/superai help`
3. SuperAI will respond with assistance

## Available Workflows

### 1. PR Review (`claude-review.yml`)

**Triggers:** PR opened, updated, or ready for review

**What it does:**
- Analyzes code changes
- Checks code quality
- Identifies potential issues
- Posts review comments

**Customization:**
```yaml
env:
  ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
  ANTHROPIC_BASE_URL: ${{ secrets.CUSTOM_ANTHROPIC_BASE_URL }}
```

### 2. Security Audit (`claude-security.yml`)

**Triggers:** Weekly (Sundays at midnight UTC) or manual

**What it does:**
- Scans for security vulnerabilities
- Checks dependencies for CVEs
- Looks for exposed secrets
- Creates issues for findings

**Customization:**
```yaml
on:
  schedule:
    - cron: '0 0 * * 0'  # Sundays at midnight
  workflow_dispatch:      # Manual trigger
```

### 3. Issue Triage (`claude-issues.yml`)

**Triggers:** Issue opened or edited

**What it does:**
- Searches for duplicate issues
- Classifies issue type
- Suggests labels
- Provides initial response

**Customization:**
- Add custom issue types
- Configure label suggestions
- Add project-specific responses

### 4. Comment Commands (`claude-comment.yml`)

**Triggers:** Comments containing `/superai`, `/sai`, or `/claude`

**What it does:**
- Responds to user requests
- Provides code analysis
- Helps with implementation
- Answers questions

**Available commands:**
- `/superai help` - Get help
- `/superai review this code` - Review specific code
- `/superai explain [function]` - Explain code
- `/superai refactor [code]` - Suggest refactoring

## Troubleshooting

### Workflow Not Running

**Check:**
1. Secrets are properly configured
2. Workflow files are in `.github/workflows/`
3. GitHub Actions are enabled for repository
4. Workflow triggers match your events

### Permission Errors

**Solution:**
1. Go to Settings → Actions → General
2. Enable "Read and write permissions"
3. Save changes

### API Key Issues

**Symptoms:** Authentication errors in workflow logs

**Solution:**
1. Verify API key is correct
2. Check if custom provider URL is accessible
3. Ensure API key has required permissions

### Agent Not Responding

**Symptoms:** Workflow runs but produces no output

**Solution:**
1. Check agent definitions in `.claude-agents/`
2. Verify orchestrator configuration
3. Check workflow logs for errors
4. Ensure proper model selection

## Best Practices

### 1. Start Small
- Test with a single PR first
- Verify workflows work as expected
- Gradually enable more features

### 2. Customize for Your Project
- Adjust agent behavior
- Add project-specific prompts
- Configure tech stack detection

### 3. Monitor Performance
- Check API usage
- Monitor workflow run times
- Review quality of AI responses

### 4. Iterate and Improve
- Gather feedback from team
- Adjust prompts and agents
- Update configurations regularly

## Security Considerations

### API Key Management
- Never commit API keys to repository
- Rotate keys regularly
- Use repository secrets, not environment secrets
- Monitor key usage

### Workflow Permissions
- Grant minimum required permissions
- Review workflow code before enabling
- Use dedicated bot accounts when possible

### Code Access
- Be aware that AI will read your code
- Ensure sensitive code is properly protected
- Review AI output before merging

## Advanced Configuration

### Custom Workflow Triggers

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches: [main, develop]  # Specific branches
  push:
    branches: [main]
  schedule:
    - cron: '0 9 * * 1'  # Weekly on Mondays
```

### Environment-Specific Configuration

```yaml
jobs:
  review:
    runs-on: ubuntu-latest
    environment: production  # Use environment secrets
    steps:
      - uses: actions/checkout@v6
      - name: Run review
        env:
          ANTHROPIC_API_KEY: ${{ secrets.PRODUCTION_API_KEY }}
```

### Matrix Strategy

```yaml
jobs:
  review:
    strategy:
      matrix:
        agent: [code-reviewer, security-auditor]
    steps:
      - name: Run ${{ matrix.agent }}
        run: |
          claude-code agent ${{ matrix.agent }}
```

## Support

For issues and questions:
- GitHub Issues: https://github.com/enact-on/super-ai-github/issues
- Documentation: https://github.com/enact-on/super-ai-github
- Claude Code Docs: https://claude.ai/code/docs

---

**SuperAI GitHub** - Automated AI assistance for your development workflow