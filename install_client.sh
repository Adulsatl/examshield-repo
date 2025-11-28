#!/bin/bash
# Usage: wget -qO- https://adulsatl.github.io/examshield-repo/install_client.sh | sudo bash
set -e

# --- CONFIGURATION ---
REPO_URL="https://adulsatl.github.io/examshield-repo"
KEY_URL="$REPO_URL/examshield.gpg.key"
LIST_FILE="/etc/apt/sources.list.d/examshield.list"

echo "🛡️  Setup ExamShield v4.1..."

# 1. Cleanup old lists to prevent conflicts
if [ -f "$LIST_FILE" ]; then
    sudo rm -f "$LIST_FILE"
fi

# 2. Install Dependencies (Safe Mode)
# We use '|| true' so the script doesn't crash if apt update fails due to college/office firewalls
echo "🔧 Checking dependencies..."
sudo apt-get update -y || true 
sudo apt-get install -y curl gnupg || true

# 3. Trust the GPG Key
echo "🔑 Downloading security key..."
curl -sS "$KEY_URL" | sudo apt-key add -

# 4. Add Repository Source
echo "📦 Adding repository..."
echo "deb [arch=all] $REPO_URL stable main" | sudo tee "$LIST_FILE"

# 5. Install ExamShield
echo "⬇️  Installing Package..."
# Update ONLY our specific list file to avoid wasting time/errors on other repos
sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/examshield.list" \
                    -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"

sudo apt-get install -y examshield

echo "✅ Installation Complete! Run 'examshield' to start."