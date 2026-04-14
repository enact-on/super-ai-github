# Claude Code GitHub Integration \- Requirements Document

## **Purpose: Scale AI Development Assistance Across 100+ Repositories**

**The Problem:**

* Small team managing 40 projects, \~100 repositories  
* Multiple tech stacks (Laravel, Next.js, React Native, Expo)  
* Manual code reviews, implementations, and security audits don't scale  
* Need consistent AI assistance without @mentioning or manual triggering

**The Solution:** Deploy centralized AI agent system where:

* Assign issues/PRs to a bot account → AI automatically implements or reviews  
* Different specialized agents for different tech stacks and tasks  
* One central repository controls all agent behavior across all projects  
* Weekly automated security audits without human intervention

**Business Value:**

1. **Developer Productivity:** Junior/mid developers get AI assistance for routine tasks (bug fixes, tests, refactoring)  
2. **Consistency:** Same code quality standards enforced across all repos via centralized agents  
3. **Security:** Automated weekly vulnerability scans catch issues early  
4. **Maintainability:** Update agent behavior once, affects all 100 repos instantly  
5. **Cost Control:** Custom provider gives unlimited quota vs. per-seat licensing

**Implementation Strategy:**

* Public repo with all agent definitions and workflows  
* Simple `curl | bash` installer detects tech stack and deploys relevant agents  
* Non-destructive patching of existing repos  
* Developers just assign tasks to `@super-ai-agent` and AI handles the rest

**Bottom Line:** Turn AI from a chat tool into an automated team member that scales linearly across all codebases without additional overhead.

## Overview

Deploy Claude Code AI agents across 100+ repositories using custom Anthropic-compatible provider, assignment-based triggers, and centralized agent management. Small team, simple implementation, no enterprise complexity.

## Core Components

### 1\. Central Configuration Repository

**Name:** `ai-agent-config` (public)

**Structure:**

├── agents/

│   ├── common/

│   │   ├── team-lead-orchestrator.json

│   │   ├── code-implementer.json

│   │   ├── code-reviewer.json

│   │   └── security-auditor.json

│   ├── laravel/

│   │   ├── laravel-fullstack-dev.json

│   │   └── laravel-backend-architect.json

│   ├── nextjs/

│   │   ├── nextjs-fullstack-dev.json

│   │   └── nodejs-backend-dev.json

│   └── mobile/

│       ├── react-native-dev.json

│       └── expo-dev.json

├── workflows/

│   ├── ai-agent.yml

│   └── security-audit.yml

├── scripts/

│   ├── install.sh

│   ├── update.sh

│   └── detect-stack.sh

└── README.md

### 2\. Custom Provider Configuration

- **Environment Variables:**  
  - `ANTHROPIC_BASE_URL`: Custom provider endpoint  
  - `ANTHROPIC_AUTH_TOKEN`: Authentication token  
  - `CLAUDE_CODE_CONFIG_DIR`: `.claude-agents`  
- **Secrets:** Stored at GitHub organization level  
- **Model Selection:** Provider decides, not hardcoded in workflows

### 3\. GitHub Bot Account

- **Username:** `super-ai-agent` (or similar)  
- **Purpose:** Assignment target for triggering workflows  
- **Access:** Read access to all target repositories

## Agent Architecture

### Agent Hierarchy

1. **Orchestration Layer**  
     
   - `team-lead-orchestrator`: Analyzes requirements, creates plans, delegates to specialists

   

2. **Technology-Specific Agents**  
     
   - **Laravel:** `laravel-fullstack-dev`, `laravel-backend-architect`  
   - **Next.js/Node:** `nextjs-fullstack-dev`, `nodejs-backend-dev`  
   - **Mobile:** `react-native-dev`, `expo-dev`

   

3. **Role-Based Agents**  
     
   - `code-implementer`: Execute implementation tasks  
   - `code-reviewer`: Review PRs for quality and best practices  
   - `security-auditor`: Security analysis and vulnerability detection

### Agent JSON Structure

{

  "name": "agent-name",

  "description": "Triggers on keywords: keyword1, keyword2, keyword3",

  "instructions": "Detailed behavior and capabilities...",

  "tools": \["Read", "Write", "Edit", "Bash"\],

  "model": "inherit"

}

## Deployment Strategy

### Installation Process

\# In target repository, developer runs:

curl \-sSL https://raw.githubusercontent.com/company/ai-agent-config/main/scripts/install.sh | bash

### Install Script Behavior

1. **Detect tech stack** (`detect-stack.sh`):  
     
   - `composer.json` → Laravel agents  
   - `next.config.js` → Next.js agents  
   - `app.json` with "expo" → Expo agents  
   - `android/` or `ios/` dirs → React Native agents  
   - Multiple detected → install all relevant agents

   

2. **Create directory structure:**  
     
   .claude-agents/  
     
   ├── agents/  
     
   │   ├── team-lead-orchestrator.json  
     
   │   ├── code-implementer.json  
     
   │   ├── code-reviewer.json  
     
   │   ├── security-auditor.json  
     
   │   └── \[tech-specific agents\]  
     
   └── config  
     
3. **Patch GitHub workflows** (non-destructive):  
     
   - Check if `.github/workflows/` exists, create if not  
   - Add `ai-agent.yml` if not present  
   - Add `security-audit.yml` if not present  
   - Never overwrite existing files

   

4. **Create update script:**  
     
   - Add `update-ai-agents.sh` to repo root  
   - Allows easy updates from central repo

### Update Mechanism

\# Developers run to update agents:

./update-ai-agents.sh

\# Or automated weekly check via GitHub Actions

## GitHub Workflows

### 1\. AI Agent Workflow (`.github/workflows/ai-agent.yml`)

**Triggers:**

on:

  issues:

    types: \[assigned\]

  pull\_request:

    types: \[review\_requested\]

**Conditional Execution:**

if: |

  github.actor \!= 'claude\[bot\]' && (

    (github.event.issue && github.event.issue.assignee.login \== 'super-ai-agent') ||

    (github.event.pull\_request && contains(github.event.pull\_request.requested\_reviewers.\*.login, 'super-ai-agent'))

  )

**Environment:**

env:

  ANTHROPIC\_BASE\_URL: ${{ secrets.CUSTOM\_ANTHROPIC\_BASE\_URL }}

  ANTHROPIC\_AUTH\_TOKEN: ${{ secrets.CUSTOM\_ANTHROPIC\_TOKEN }}

  CLAUDE\_CODE\_CONFIG\_DIR: ${{ github.workspace }}/.claude-agents

**Configuration:**

- **Timeout:** 30 minutes  
- **Permissions:** `contents: write`, `pull-requests: write`, `issues: write`, `id-token: write`, `actions: read`  
- **Self-trigger prevention:** Check `github.actor != 'claude[bot]'`

### 2\. Security Audit Workflow (`.github/workflows/security-audit.yml`)

**Schedule:** Weekly on Sundays

on:

  schedule:

    \- cron: '0 0 \* \* 0'  \# Every Sunday at midnight UTC

  workflow\_dispatch:  \# Manual trigger option

**Behavior:**

1. Creates issue: "Weekly Security Audit \- \[Date\]"  
2. Assigns to `super-ai-agent`  
3. Agent runs security-auditor analysis  
4. Posts findings as issue comments

## Technical Implementation

### Tech Stack Detection Logic

\# detect-stack.sh returns comma-separated: laravel,nextjs,reactnative,expo

if \[ \-f "composer.json" \]; then STACK="$STACK,laravel"; fi

if \[ \-f "next.config.js" \]; then STACK="$STACK,nextjs"; fi

if \[ \-f "app.json" \] && grep \-q "expo" app.json; then STACK="$STACK,expo"; fi

if \[ \-d "android" \] || \[ \-d "ios" \]; then STACK="$STACK,reactnative"; fi

### Agent Selection

Claude Code automatically selects agents based on:

1. Keywords in agent `description` field  
2. Issue/PR content analysis  
3. Codebase context  
4. Explicit user mention of agent name in issue

### Orchestration Flow

1. Issue assigned to `@super-ai-agent` → Workflow triggers  
2. Main Claude analyzes issue and available agents  
3. `team-lead-orchestrator` creates implementation plan (if complex)  
4. Delegates to tech-specific agent (e.g., `laravel-fullstack-dev`)  
5. `code-implementer` executes changes  
6. Creates PR with changes  
7. PR review requested from `@super-ai-agent`  
8. `code-reviewer` \+ `security-auditor` analyze PR  
9. Post review comments

## Maintenance

### Updating Central Repository

1. Make changes to `ai-agent-config` repo  
2. Tag with version: `v1.1.0`  
3. Notify team via Slack/email  
4. Developers run `./update-ai-agents.sh` when ready

### Emergency Updates

For critical fixes, manually update 3-5 pilot repos first, verify, then notify all teams.

## Out of Scope

The following are **not** part of this implementation:

- CLAUDE.md files (developer-created, repo-specific)  
- Cost tracking/dashboards  
- Analytics/metrics collection  
- Audit logs  
- Automated rollback mechanisms  
- Integration with JIRA/Slack/monitoring tools  
- Fallback to direct Anthropic API  
- Model selection logic (provider handles this)

## Success Criteria

- ✓ Issues/PRs assigned to `@super-ai-agent` trigger workflows  
- ✓ Custom provider receives all API calls  
- ✓ Correct agents selected based on tech stack  
- ✓ Agents create valid PRs following repo patterns  
- ✓ Security audits run weekly without intervention  
- ✓ New repos can be onboarded in \< 5 minutes  
- ✓ Updates propagate to all repos via simple script

## Implementation Deliverables

1. `ai-agent-config` repository with complete structure  
2. Install script (`install.sh`) with tech stack detection  
3. Update script (`update.sh`)  
4. Two workflow templates (ai-agent, security-audit)  
5. 10+ agent JSON definitions (common \+ tech-specific)  
6. README.md with setup instructions  
7. Example CLAUDE.md templates (for developer reference)

The repo should be visible only not modify it 