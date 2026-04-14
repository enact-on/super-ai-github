#!/bin/bash
#
# SuperAI GitHub - Submodule Installer Script
# This script installs the SuperAI agents and skills as a submodule.
# It NEVER touches the user's .claude directory - everything goes in .claude-agents
#
# Usage: ./scripts/install.sh [options]
# Options:
#   -y, --yes       Auto-confirm all prompts
#   -v, --verbose   Enable verbose output
#   -h, --help      Show this help message
#   --all           Install all agents and skills (no tech detection)
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(pwd)"

# Options
AUTO_CONFIRM=false
VERBOSE=false
INSTALL_ALL=false

# Help message
show_help() {
    grep '^#' "$SCRIPT_DIR/install.sh" | sed 's/^#/ /' | sed 's/ $//'
    exit 0
}

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verbose logging
log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${BLUE}[VERBOSE]${NC} $1"
    fi
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -y|--yes)
            AUTO_CONFIRM=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            set -x
            shift
            ;;
        -h|--help)
            show_help
            ;;
        --all)
            INSTALL_ALL=true
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            ;;
    esac
done

# Welcome message
echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}       SuperAI GitHub - Submodule Installer            ${BLUE}║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
log_info "This will install SuperAI agents and skills in .claude-agents/"
log_info "Your existing .claude/ configuration will NOT be touched."
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    log_warning "Not in a git repository. Some features may not work properly."
    if [ "$AUTO_CONFIRM" = false ]; then
        read -p "Continue anyway? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Installation cancelled."
            exit 0
        fi
    fi
fi

# Source the tech stack detection script
DETECTED_STACK=()
if [ "$INSTALL_ALL" = false ] && [ -f "$SCRIPT_DIR/detect-tech-stack.sh" ]; then
    log_info "Detecting technology stack..."
    source "$SCRIPT_DIR/detect-tech-stack.sh"
    detect_tech_stack "$PROJECT_ROOT"
    DETECTED_STACK=("${TECH_STACK[@]}")
fi

# Display detected tech stack
if [ ${#DETECTED_STACK[@]} -gt 0 ]; then
    log_success "Detected technologies:"
    for tech in "${DETECTED_STACK[@]}"; do
        echo "  - $tech"
    done
    echo ""
elif [ "$INSTALL_ALL" = false ]; then
    log_warning "No specific technologies detected. Will install core agents only."
    echo ""
fi

# Confirm installation
if [ "$AUTO_CONFIRM" = false ]; then
    echo "This will install:"
    echo "  - SuperAI agents to: .claude-agents/agents/"
    echo "  - SuperAI skills to: .claude-agents/skills/"
    echo "  - GitHub workflows to: .github/workflows/"
    echo "  - Prompt templates to: .claude-agents/prompts/"
    echo ""
    echo "📍 Important:"
    echo "  - Your .claude/ directory will NOT be touched"
    echo "  - Everything is installed in .claude-agents/"
    echo "  - Works with your existing Claude Code setup"
    echo ""
    if [ ${#DETECTED_STACK[@]} -gt 0 ]; then
        echo "Tech-specific agents will be installed for:"
        printf '  - %s\n' "${DETECTED_STACK[@]}"
        echo ""
    fi
    read -p "Continue? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        log_info "Installation cancelled."
        exit 0
    fi
fi

# Create directories
log_info "Creating directories..."
mkdir -p "$PROJECT_ROOT/.claude-agents/agents"
mkdir -p "$PROJECT_ROOT/.claude-agents/skills"
mkdir -p "$PROJECT_ROOT/.claude-agents/prompts"
mkdir -p "$PROJECT_ROOT/.github/workflows"

# Copy core agents (always installed)
log_info "Installing core agents..."
CORE_AGENTS=("orchestrator.md" "code-reviewer.md" "security-auditor.md" "implementation.md" "documentation-writer.md")

for agent in "${CORE_AGENTS[@]}"; do
    if [ -f "$REPO_ROOT/.claude-agents/agents/$agent" ]; then
        cp "$REPO_ROOT/.claude-agents/agents/$agent" "$PROJECT_ROOT/.claude-agents/agents/"
        log_verbose "Installed agent: $agent"
    fi
done

log_success "Core agents installed."

# Function to check if tech stack needs specific agent
needs_agent() {
    local tech=$1
    for detected in "${DETECTED_STACK[@]}"; do
        if [[ "$detected" =~ ${tech} ]]; then
            return 0
        fi
    done
    return 1
}

# Install tech-specific agents based on detected stack
log_info "Installing tech-specific agents..."

# Frontend technologies
if needs_agent "react" || needs_agent "nextjs" || needs_agent "typescript" || [ "$INSTALL_ALL" = true ]; then
    if [ -f "$REPO_ROOT/.claude-agents/agents/frontend-specialist.md" ]; then
        cp "$REPO_ROOT/.claude-agents/agents/frontend-specialist.md" "$PROJECT_ROOT/.claude-agents/agents/"
        log_verbose "Installed frontend-specialist"
    fi
fi

# Backend technologies
if needs_agent "nodejs" || needs_agent "nestjs" || needs_agent "python" || needs_agent "laravel" || [ "$INSTALL_ALL" = true ]; then
    if [ -f "$REPO_ROOT/.claude-agents/agents/backend-specialist.md" ]; then
        cp "$REPO_ROOT/.claude-agents/agents/backend-specialist.md" "$PROJECT_ROOT/.claude-agents/agents/"
        log_verbose "Installed backend-specialist"
    fi
fi

# Database technologies
if needs_agent "postgresql" || needs_agent "mysql" || needs_agent "mongodb" || [ "$INSTALL_ALL" = true ]; then
    if [ -f "$REPO_ROOT/.claude-agents/agents/database-expert.md" ]; then
        cp "$REPO_ROOT/.claude-agents/agents/database-expert.md" "$PROJECT_ROOT/.claude-agents/agents/"
        log_verbose "Installed database-expert"
    fi
fi

# Testing frameworks
if needs_agent "jest" || needs_agent "vitest" || needs_agent "pytest" || [ "$INSTALL_ALL" = true ]; then
    if [ -f "$REPO_ROOT/.claude-agents/agents/testing-specialist.md" ]; then
        cp "$REPO_ROOT/.claude-agents/agents/testing-specialist.md" "$PROJECT_ROOT/.claude-agents/agents/"
        log_verbose "Installed testing-specialist"
    fi
fi

# DevOps technologies
if needs_agent "docker" || needs_agent "kubernetes" || [ "$INSTALL_ALL" = true ]; then
    if [ -f "$REPO_ROOT/.claude-agents/agents/devops-specialist.md" ]; then
        cp "$REPO_ROOT/.claude-agents/agents/devops-specialist.md" "$PROJECT_ROOT/.claude-agents/agents/"
        log_verbose "Installed devops-specialist"
    fi
fi

log_success "Tech-specific agents installed."

# Install skills based on detected tech stack
log_info "Installing skills..."

if [ -d "$REPO_ROOT/.claude-agents/skills" ]; then
    if [ "$INSTALL_ALL" = true ]; then
        # Install all skills
        cp -r "$REPO_ROOT/.claude-agents/skills"/* "$PROJECT_ROOT/.claude-agents/skills/"
        log_verbose "Installed all skills"
    else
        # Install skills based on detected tech stack
        for skill_dir in "$REPO_ROOT/.claude-agents/skills"/*; do
            if [ -d "$skill_dir" ]; then
                skill_name=$(basename "$skill_dir")
                # Install core skills always
                if [[ "$skill_name" =~ (documentation|frontend-design|code-review|security-guidance|api-design) ]]; then
                    cp -r "$skill_dir" "$PROJECT_ROOT/.claude-agents/skills/"
                    log_verbose "Installed core skill: $skill_name"
                # Install tech-specific skills if detected
                elif needs_agent "$skill_name"; then
                    cp -r "$skill_dir" "$PROJECT_ROOT/.claude-agents/skills/"
                    log_verbose "Installed tech skill: $skill_name"
                fi
            fi
        done
    fi
fi

log_success "Skills installed."

# Copy prompt templates
if [ -d "$REPO_ROOT/.claude-agents/prompts" ] && [ "$(ls -A $REPO_ROOT/.claude-agents/prompts)" ]; then
    log_info "Installing prompt templates..."
    cp -r "$REPO_ROOT/.claude-agents/prompts"/* "$PROJECT_ROOT/.claude-agents/prompts/"
    log_success "Prompt templates installed."
fi

# Copy settings file
if [ -f "$REPO_ROOT/.claude-agents/settings.json" ]; then
    log_info "Installing settings file..."
    cp "$REPO_ROOT/.claude-agents/settings.json" "$PROJECT_ROOT/.claude-agents/"
    log_success "Settings file installed."
fi

# Copy GitHub workflows
if [ -d "$REPO_ROOT/.github/workflows" ]; then
    log_info "Installing GitHub workflows..."
    for workflow in "$REPO_ROOT/.github/workflows"/*.yml; do
        if [ -f "$workflow" ]; then
            cp "$workflow" "$PROJECT_ROOT/.github/workflows/"
            log_verbose "Installed workflow: $(basename "$workflow")"
        fi
    done
    log_success "GitHub workflows installed."
fi

# Save installation state
log_info "Saving installation state..."
cat > "$PROJECT_ROOT/.claude-install.json" << EOF
{
  "version": "1.0.0",
  "installed_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "install_mode": "submodule",
  "tech_stack": $(printf '%s\n' "${DETECTED_STACK[@]}" | jq -R . | jq -s . 2>/dev/null || echo '[]'),
  "install_all": $INSTALL_ALL,
  "repo_root": "$REPO_ROOT"
}
EOF

log_success "Installation state saved."

# Final summary
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}                  Installation Complete!                 ${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "SuperAI agents and skills have been installed in .claude-agents/"
echo ""
echo "Your .claude/ configuration was NOT touched."
echo ""
echo "Next steps:"
echo ""
echo "📍 Local Development:"
echo "  1. Use Claude Code normally: claude-code"
echo "  2. Agents are in: .claude-agents/agents/"
echo "  3. Skills are in: .claude-agents/skills/"
echo "  4. Refer to agent .md files for instructions"
echo ""
echo "📍 GitHub Integration:"
echo "  1. Add ANTHROPIC_API_KEY to your repository secrets"
echo "  2. Commit and push to GitHub"
echo "  3. GitHub Actions will use the agents automatically"
echo ""
echo "📍 Agent Usage:"
echo "  • Orchestrator: Delegates tasks to specialists"
echo "  • Code Reviewer: Reviews code quality"
echo "  • Security Auditor: Security analysis"
echo "  • Implementation: Writes code"
echo "  • And 6 more specialized agents!"
echo ""
echo "📍 To Update:"
echo "  cd .super-ai-github  # or your submodule path"
echo "  git pull origin main"
echo "  ./scripts/install.sh"
echo ""
log_success "For help, refer to the agent .md files in .claude-agents/agents/"
echo ""