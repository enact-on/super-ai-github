#!/bin/bash
#
# SuperAI GitHub - Tech Stack Detection Script
# Detects the technology stack used in the current project.
#
# This script is meant to be sourced, not executed directly.
#

# Array to hold detected technologies
TECH_STACK=()

# Function to detect tech stack
detect_tech_stack() {
    local project_root="$1"

    if [ -z "$project_root" ]; then
        project_root="$(pwd)"
    fi

    # Detect Frontend Frameworks
    if [ -f "$project_root/package.json" ]; then
        if grep -q '"react"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("React")
        fi
        if grep -q '"vue"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Vue")
        fi
        if grep -q '"@angular"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Angular")
        fi
        if grep -q '"svelte"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Svelte")
        fi
        if grep -q '"next"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Next.js")
        fi
        if grep -q '"nuxt"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Nuxt")
        fi
        if grep -q '"@vitejs"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Vite")
        fi
        if grep -q '"webpack"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Webpack")
        fi
        if grep -q '"typescript"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("TypeScript")
        fi

        # Detect testing frameworks
        if grep -q '"jest"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Jest")
        fi
        if grep -q '"vitest"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Vitest")
        fi
        if grep -q '"@testing-library"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Testing Library")
        fi
        if grep -q '"cypress"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Cypress")
        fi
        if grep -q '"playwright"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Playwright")
        fi

        # Detect build tools
        if grep -q '"esbuild"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("esbuild")
        fi
        if grep -q '"rollup"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Rollup")
        fi
        if grep -q '"parcel"' "$project_root/package.json" 2>/dev/null; then
            TECH_STACK+=("Parcel")
        fi

        # Default JavaScript detection
        TECH_STACK+=("JavaScript/Node.js")
    fi

    # Detect Backend Frameworks (PHP)
    if [ -f "$project_root/composer.json" ]; then
        if grep -q '"laravel"' "$project_root/composer.json" 2>/dev/null; then
            TECH_STACK+=("Laravel")
        fi
        if grep -q '"symfony"' "$project_root/composer.json" 2>/dev/null; then
            TECH_STACK+=("Symfony")
        fi
        if grep -q '"wordpress"' "$project_root/composer.json" 2>/dev/null; then
            TECH_STACK+=("WordPress")
        fi

        # Detect PHP testing
        if grep -q '"phpunit"' "$project_root/composer.json" 2>/dev/null; then
            TECH_STACK+=("PHPUnit")
        fi

        TECH_STACK+=("PHP")
    fi

    # Detect Python
    if [ -f "$project_root/requirements.txt" ] || [ -f "$project_root/pyproject.toml" ] || [ -f "$project_root/setup.py" ]; then
        if [ -f "$project_root/requirements.txt" ]; then
            if grep -q 'django' "$project_root/requirements.txt" 2>/dev/null; then
                TECH_STACK+=("Django")
            fi
            if grep -q 'flask' "$project_root/requirements.txt" 2>/dev/null; then
                TECH_STACK+=("Flask")
            fi
            if grep -q 'fastapi' "$project_root/requirements.txt" 2>/dev/null; then
                TECH_STACK+=("FastAPI")
            fi
        fi
        TECH_STACK+=("Python")
    fi

    # Detect Ruby
    if [ -f "$project_root/Gemfile" ]; then
        if grep -q 'rails' "$project_root/Gemfile" 2>/dev/null; then
            TECH_STACK+=("Rails")
        fi
        if grep -q 'sinatra' "$project_root/Gemfile" 2>/dev/null; then
            TECH_STACK+=("Sinatra")
        fi
        TECH_STACK+=("Ruby")
    fi

    # Detect Go
    if [ -f "$project_root/go.mod" ]; then
        TECH_STACK+=("Go")
    fi

    # Detect Rust
    if [ -f "$project_root/Cargo.toml" ]; then
        TECH_STACK+=("Rust")
    fi

    # Detect Java/Kotlin
    if [ -f "$project_root/pom.xml" ] || [ -f "$project_root/build.gradle" ] || [ -f "$project_root/build.gradle.kts" ]; then
        if [ -f "$project_root/build.gradle" ] || [ -f "$project_root/build.gradle.kts" ]; then
            TECH_STACK+=("Gradle")
        fi
        if [ -f "$project_root/pom.xml" ]; then
            TECH_STACK+=("Maven")
        fi
        TECH_STACK+=("Java/Kotlin")
    fi

    # Remove duplicates
    IFS=$'\n' TECH_STACK=($(sort -u <<< "${TECH_STACK[*]}"))
    unset IFS
}

# Export for use in other scripts
export -f detect_tech_stack
