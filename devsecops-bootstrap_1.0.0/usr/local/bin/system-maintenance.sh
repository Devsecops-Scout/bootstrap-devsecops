#!/bin/bash
# WSL Developer Environment Maintenance Script
# Author: devsecops_scout
# Description: System and shell environment maintenance for WSL2/Ubuntu

set -euo pipefail

echo "🛠️ WSL Dev Maintenance Started: $(date)"

echo "🔄 Updating package lists..."
sudo apt update

echo "⬆️ Upgrading installed packages..."
sudo apt upgrade -y

echo "🧹 Removing unused packages and cleaning cache..."
sudo apt autoremove -y
sudo apt autoclean

echo "🔍 Verifying disk usage..."
df -h --output=source,size,used,avail,pcent,target | grep -E '^Filesystem|^/dev/'

echo "📦 Checking Snap packages..."
if command -v snap &>/dev/null; then
    sudo snap refresh
else
    echo "⚠️ Snap not installed or not used in this environment."
fi

echo "🧪 Checking for held or broken packages..."
dpkg --audit || echo "✅ No broken packages."
apt-mark showhold || echo "✅ No held packages."

echo "🗂️ Cleaning up temporary files..."
sudo find /tmp -type f -atime +5 -delete
sudo find /var/tmp -type f -atime +5 -delete

echo "📁 Spotting large files in home (~) directory..."
find "$HOME" -type f -size +100M -exec du -h {} + | sort -hr | head -n 10

### OPTIONAL: ZSH ENVIRONMENT MAINTENANCE
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "🌀 Oh My Zsh detected — updating plugins and themes..."

  echo "📦 Updating Oh My Zsh core..."
  omz update || echo "⚠️ Failed to auto-update Oh My Zsh"

  echo "🔌 Updating custom plugins..."
  ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
  for plugin in "$ZSH_CUSTOM/plugins/"*/; do
    if [ -d "$plugin/.git" ]; then
      echo "➡️ Updating plugin: $(basename "$plugin")"
      git -C "$plugin" pull --quiet
    fi
  done

  echo "🎨 Updating custom themes..."
  for theme in "$ZSH_CUSTOM/themes/"*/; do
    if [ -d "$theme/.git" ]; then
      echo "➡️ Updating theme: $(basename "$theme")"
      git -C "$theme" pull --quiet
    fi
  done

  echo "🧹 Clearing Oh My Zsh cache (if any)..."
  rm -rf "$HOME/.zcompdump"*
  echo "✅ Zsh environment refreshed."
else
  echo "⚠️ Oh My Zsh not found — skipping shell environment steps."
fi

echo "🖥️ System Info Snapshot:"
echo "User: $USER"
echo "Shell: $SHELL"
echo "Uptime: $(uptime -p)"
echo "Kernel: $(uname -r)"

echo "✅ WSL Dev + Zsh Maintenance Complete: $(date)"
