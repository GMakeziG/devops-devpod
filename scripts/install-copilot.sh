#!/usr/bin/env bash
set -euo pipefail

# Make Node.js installed by the Dev Container NVM feature available.
if ! command -v npm >/dev/null 2>&1; then
    NVM_DIR="${NVM_DIR:-/usr/local/share/nvm}"

    if [[ -s "$NVM_DIR/nvm.sh" ]]; then
        # Load NVM in non-interactive shells.
        . "$NVM_DIR/nvm.sh"
    fi
fi

if ! command -v npm >/dev/null 2>&1; then
    echo "ERROR: npm is not installed or unavailable in PATH." >&2
    exit 1
fi

NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]')"

if [ "$NODE_MAJOR" -lt 22 ]; then
  echo "ERROR: Copilot CLI requires Node.js 22 or later."
  exit 1
fi

# Install Copilot into a user-local directory without changing ~/.npmrc.
NPM_PREFIX="$HOME/.local/npm"
mkdir -p "$NPM_PREFIX"

export PATH="$NPM_PREFIX/bin:$PATH"

if ! command -v copilot >/dev/null 2>&1; then
  echo "Installing GitHub Copilot CLI..."
  npm install -g --prefix "$NPM_PREFIX" @github/copilot
fi

copilot --version
