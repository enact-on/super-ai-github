# 🚀 SuperAI GitHub - Correct Usage Instructions

## ⚠️ **IMPORTANT: Don't cd into the submodule!**

### ❌ **WRONG WAY** (What you were doing):
```bash
cd your-project
git submodule add https://github.com/enact-on/super-ai-github.git .super-ai-github
cd .super-ai-github           # ❌ WRONG! Don't cd into submodule
./scripts/install.sh          # Now it detects the wrong directory!
```

### ✅ **CORRECT WAY** (Run from your project root):
```bash
cd your-project
git submodule add https://github.com/enact-on/super-ai-github.git .super-ai-github

# Stay in your project root!
./scripts/install.sh  # ✅ CORRECT! This will auto-detect your tech stack
```

## 🎯 **How It Works Now**

The updated install script is **smart** - it automatically detects when you're inside the submodule and will check your **parent project's** tech stack instead!

## 📋 **Step-by-Step for Your Demo Project**

```bash
# 1. Go to your demo project
cd C:/Users/afsai/Desktop/Files/pilot/nextjs/demo

# 2. Add SuperAI as submodule
git submodule add https://github.com/enact-on/super-ai-github.git .super-ai-github

# 3. Install from your project root (NOT from inside the submodule!)
./scripts/install.sh

# You should now see:
# [INFO] This will install SuperAI agents and skills in .claude-agents/
# [INFO] Your existing .claude/ configuration will NOT be touched.
# [INFO] Detecting technology stack...
# [SUCCESS] Detected technologies:
#   - Next.js
#   - Laravel
#   - React
#   - TypeScript
#   - Node.js
#   - PHP
#   - Vite
```

## 🔍 **Tech Stack Detection**

The script now checks your **parent project** for:

```bash
package.json          → React, Next.js, Vue, Node.js, TypeScript
composer.json         → Laravel, PHP
requirements.txt      → Python, Django, FastAPI
go.mod               → Go
Cargo.toml           → Rust
pom.xml              → Java/Maven
build.gradle         → Java/Gradle
```

## 🎯 **Quick Test**

Try this on your demo project:

```bash
cd C:/Users/afsai/Desktop/Files/pilot/nextjs/demo
git submodule add https://github.com/enact-on/super-ai-github.git .super-ai-github
./scripts/install.sh

# You should see both Next.js and Laravel detected!
```

## 💡 **Pro Tips**

1. **Always run from project root** - never cd into the submodule
2. **The script is smart now** - it auto-detects parent project
3. **Tech detection works** - it finds package.json, composer.json, etc.
4. **Selective installation** - only relevant agents/skills are installed

**Try it now on your demo project and it should work perfectly!** 🚀
