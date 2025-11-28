#!/bin/bash
# Usage: wget -qO- https://adulsatl.github.io/examshield-repo/install_client.sh | sudo bash
set -e

# --- CONFIGURATION ---
REPO_URL="https://adulsatl.github.io/examshield-repo"
KEY_URL="$REPO_URL/examshield.gpg.key"
LIST_FILE="/etc/apt/sources.list.d/examshield.list"
KEYRING_PATH="/usr/share/keyrings/examshield-archive-keyring.gpg"

echo "🛡️  Setup ExamShield v4.1..."

# 1. Cleanup old lists to prevent conflicts
if [ -f "$LIST_FILE" ]; then
    sudo rm -f "$LIST_FILE"
fi
if [ -f "$KEYRING_PATH" ]; then
    sudo rm -f "$KEYRING_PATH"
fi

# 2. Install Dependencies (Safe Mode)
echo "🔧 Checking dependencies..."
sudo apt-get update -y || true 
sudo apt-get install -y curl gnupg || true

# 3. Trust the GPG Key
echo "🔑 Downloading security key..."
curl -sS "$KEY_URL" | gpg --dearmor | sudo tee "$KEYRING_PATH" > /dev/null

# 4. Add Repository Source
# FIXED: Changed [arch=all] to [arch=amd64,i386] to match repo structure
echo "📦 Adding repository..."
echo "deb [arch=amd64,i386 signed-by=$KEYRING_PATH] $REPO_URL stable main" | sudo tee "$LIST_FILE"

# 5. Install ExamShield
echo "⬇️  Installing Package..."
sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/examshield.list" \
                    -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"

sudo apt-get install -y examshield

echo "✅ Installation Complete! Run 'examshield' to start."