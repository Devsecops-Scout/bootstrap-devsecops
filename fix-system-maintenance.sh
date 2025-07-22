#!/bin/bash
# ------------------------------------------------------------------------
# fix-system-maintenance.sh - Self-healing maintenance for WSL Dev environments
# Author: devsecops_scout
# Last Updated: 2025-07-22
# ------------------------------------------------------------------------

set -euo pipefail
IFS=$'\n\t'

LOGFILE="$HOME/system_maintenance_$(date +%F_%H-%M-%S).log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "🛠️ WSL Dev Fix Maintenance Started: $(date)"

# ------------------------------------------------------------------------
# 🔄 System Update & Cleanup
# ------------------------------------------------------------------------
echo "🔄 Updating APT sources..."
sudo apt update || echo "⚠️ apt update failed"

echo "⬆️ Upgrading system packages..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y || echo "⚠️ apt upgrade failed"

echo "🧹 Performing autoremove and autoclean..."
sudo apt autoremove -y || true
sudo apt autoclean || true

# ------------------------------------------------------------------------
# 🧪 Fix Broken Packages
# ------------------------------------------------------------------------
echo "🧪 Checking for broken packages..."
sudo dpkg --configure -a || echo "⚠️ Failed to reconfigure packages"
sudo apt install -f -y || echo "⚠️ Dependency fix attempt failed"

# ------------------------------------------------------------------------
# 📦 Snap Package Refresh (if snap exists)
# ------------------------------------------------------------------------
if command -v snap &>/dev/null; then
  echo "📦 Refreshing Snap packages..."
  sudo snap refresh || echo "⚠️ Snap refresh skipped or failed"
fi

# ------------------------------------------------------------------------
# 🗂️ Cleanup Temp Files
# ------------------------------------------------------------------------
echo "🗂️ Cleaning stale temp files..."
sudo find /tmp -type f -atime +5 -delete || true
sudo find /var/tmp -type f -atime +5 -delete || true

# ------------------------------------------------------------------------
# 🐳 Docker Group Permissions Fix (common in WSL)
# ------------------------------------------------------------------------
if groups "$USER" | grep -q docker; then
  echo "🐳 Docker group OK"
else
  echo "🐳 Adding $USER to docker group..."
  sudo usermod -aG docker "$USER"
  echo "⚠️ Restart terminal to apply Docker group change"
fi

# ------------------------------------------------------------------------
# 🌀 Oh My Zsh Fixes
# ------------------------------------------------------------------------
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "🌀 Fixing Oh My Zsh plugins/themes..."

  if command -v omz &>/dev/null; then
    omz update || echo "⚠️ Oh My Zsh update failed"
  fi

  for plugin in "$HOME/.oh-my-zsh/custom/plugins/"*/; do
    [[ -d "$plugin/.git" ]] && git -C "$plugin" pull --quiet
  done

  for theme in "$HOME/.oh-my-zsh/custom/themes/"*/; do
    [[ -d "$theme/.git" ]] && git -C "$theme" pull --quiet
  done

  echo "🧹 Clearing stale Zsh comp cache..."
  rm -rf "$HOME/.zcompdump"* || true
else
  echo "⚠️ Oh My Zsh not installed. Skipping shell fixes."
fi

# ------------------------------------------------------------------------
# 🖥️ Final Check
# ------------------------------------------------------------------------
echo "🖥️ Uptime: $(uptime -p)"
echo "📁 Disk Usage:"
df -h --output=source,size,used,avail,pcent,target | grep -E '^Filesystem|^/dev/'

echo "✅ Fix Maintenance Completed: $(date)"
echo "📄 Log saved to: $LOGFILE"
