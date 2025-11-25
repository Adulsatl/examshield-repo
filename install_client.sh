#!/bin/bash
# Usage: wget -qO- https://adulsatl.github.io/examshield-repo/install_client.sh | sudo bash

set -e
REPO_URL="https://adulsatl.github.io/examshield-repo" # I updated this based on your logs
KEY_URL="$REPO_URL/examshield.gpg.key"
LIST_FILE="/etc/apt/sources.list.d/examshield.list"

echo "🛡️  Configuring ExamShield Repository..."

# --- FIX: Auto-install dependencies ---
if ! command -v curl &> /dev/null || ! command -v gpg &> /dev/null; then
    echo "🔧 Installing necessary tools (curl, gnupg)..."
    sudo apt-get update
    sudo apt-get install -y curl gnupg
fi
# --------------------------------------

# 1. Download Key (Now safe because curl is installed)
echo "🔑 Downloading security key..."
curl -sS "$KEY_URL" | gpg --dearmor | sudo tee /usr/share/keyrings/examshield-archive-keyring.gpg > /dev/null

# 2. Add Source
echo "deb [signed-by=/usr/share/keyrings/examshield-archive-keyring.gpg] $REPO_URL stable main" | sudo tee "$LIST_FILE"

# 3. Install
echo "📦 Installing ExamShield..."
sudo apt-get update
sudo apt-get install -y examshield

echo "✅ Installation Complete!"