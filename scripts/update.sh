#!/bin/bash
#
# SuperAI GitHub - Update Script
# Updates the SuperAI configuration to the latest version.
#
# Usage: ./scripts/update.sh [options]
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(pwd)"

# Logging
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}              SuperAI GitHub - Updater                 ${BLUE}║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if installed
if [ ! -f "$PROJECT_ROOT/.super-ai-install.json" ]; then
    log_error "SuperAI is not installed in this project."
    log_info "Run './scripts/install.sh' first."
    exit 1
fi

# Pull latest changes if in a git repository
if [ -d "$REPO_ROOT/.git" ]; then
    log_info "Pulling latest changes from SuperAI repository..."
    cd "$REPO_ROOT"
    git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || {
        log_warning "Could not pull from git. Continuing with local files..."
    }
    cd "$PROJECT_ROOT"
fi

# Re-run installer with auto-confirm
log_info "Reinstalling SuperAI configuration..."
exec "$SCRIPT_DIR/install.sh" --yes
