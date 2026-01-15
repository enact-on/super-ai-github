#!/bin/bash
#
# SuperAI GitHub - Installer Script
# This script installs the SuperAI OpenCode configuration into your project.
#
# Usage: ./scripts/install.sh [options]
# Options:
#   -y, --yes      Auto-confirm all prompts
#   -v, --verbose  Enable verbose output
#   -h, --help     Show this help message
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
        *)
            log_error "Unknown option: $1"
            show_help
            ;;
    esac
done

# Welcome message
echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}         SuperAI GitHub - OpenCode Installer           ${BLUE}║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
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
log_info "Detecting technology stack..."
if [ -f "$SCRIPT_DIR/detect-tech-stack.sh" ]; then
    source "$SCRIPT_DIR/detect-tech-stack.sh"
    detect_tech_stack
else
    log_warning "Tech stack detection script not found. Skipping..."
    TECH_STACK=()
fi

# Display detected tech stack
if [ ${#TECH_STACK[@]} -gt 0 ]; then
    log_success "Detected technologies:"
    for tech in "${TECH_STACK[@]}"; do
        echo "  - $tech"
    done
    echo ""
fi

# Confirm installation
if [ "$AUTO_CONFIRM" = false ]; then
    echo "This will install the following:"
    echo "  - OpenCode agents to: .opencode/agent/"
    echo "  - OpenCode skills to: .opencode/skill/"
    echo "  - GitHub workflows to: .github/workflows/"
    echo ""
    read -p "Continue? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        log_info "Installation cancelled."
        exit 0
    fi
fi

# Create directories
log_info "Creating directories..."
mkdir -p "$PROJECT_ROOT/.opencode/agent"
mkdir -p "$PROJECT_ROOT/.opencode/skill"
mkdir -p "$PROJECT_ROOT/.opencode/command"
mkdir -p "$PROJECT_ROOT/.github/workflows"

# Copy files function
copy_files() {
    local src="$1"
    local dst="$2"
    local desc="$3"

    log_info "Copying $desc..."

    if [ -d "$src" ]; then
        # Copy directory contents
        cp -r "$src"/* "$dst/" 2>/dev/null || true
        log_success "Copied $desc"
    elif [ -f "$src" ]; then
        # Copy single file
        cp "$src" "$dst/"
        log_success "Copied $desc"
    else
        log_warning "Source not found: $src"
    fi
}

# Copy OpenCode configuration
copy_files "$REPO_ROOT/.opencode/opencode.json" "$PROJECT_ROOT/.opencode" "OpenCode configuration"

# Copy agents
copy_files "$REPO_ROOT/.opencode/agent" "$PROJECT_ROOT/.opencode/agent" "OpenCode agents"

# Copy skills (all of them)
copy_files "$REPO_ROOT/.opencode/skill" "$PROJECT_ROOT/.opencode/skill" "OpenCode skills"

# Copy commands if any
if [ -d "$REPO_ROOT/.opencode/command" ] && [ "$(ls -A $REPO_ROOT/.opencode/command)" ]; then
    copy_files "$REPO_ROOT/.opencode/command" "$PROJECT_ROOT/.opencode/command" "OpenCode commands"
fi

# Copy GitHub workflows
copy_files "$REPO_ROOT/.github/workflows" "$PROJECT_ROOT/.github/workflows" "GitHub workflows"

# Save installation state
log_info "Saving installation state..."
cat > "$PROJECT_ROOT/.super-ai-install.json" << EOF
{
  "version": "1.0.0",
  "installed_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "tech_stack": $(printf '%s\n' "${TECH_STACK[@]}" | jq -R . | jq -s .),
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
echo "SuperAI has been installed in your project!"
echo ""
echo "Next steps:"
echo "  1. Run: opencode"
echo "  2. Check available agents: /agents"
echo "  3. Try the orchestrator: Ask it to review some code"
echo ""
echo "For GitHub integration:"
echo "  1. Set ANTHROPIC_API_KEY in your repository secrets"
echo "  2. Push to GitHub"
echo "  3. Open a PR to see SuperAI in action"
echo ""
log_info "For updates, run: ./scripts/update.sh"
echo ""
