#!/bin/bash
# ------------------------------------------------------------------------
# WSL DevSecOps Bootstrap Script - Modular & Mission-Ready
# Author: devsecops_scout
# Last Updated: 2025-07-10
# ------------------------------------------------------------------------

set -euo pipefail
LOG_FILE="/tmp/bootstrap-devsecops.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "🛠️ Starting DevSecOps Workstation Bootstrap: $(date)"

# ------------------------------------------------------------------------
# 🔄 System Update
# ------------------------------------------------------------------------
echo "🔄 Updating package lists and upgrading..."
sudo apt-get update && sudo apt-get upgrade -y

# ------------------------------------------------------------------------
# 🐳 Docker Setup
# ------------------------------------------------------------------------
echo "🐳 Installing Docker..."
if ! command -v docker &>/dev/null; then
  sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
else
  echo "✅ Docker already installed."
fi

# ------------------------------------------------------------------------
# 🛠️ Kubernetes Tools (modular installer)
# ------------------------------------------------------------------------
echo "🔧 Setting up Kubernetes tools..."
source ./k8s-tools.sh || echo "⚠️ Skipped: k8s-tools.sh not found."

# ------------------------------------------------------------------------
# 🐚 ZSH + Oh My Zsh Setup
# ------------------------------------------------------------------------
echo "🐚 Installing ZSH + Oh My Zsh..."
if ! command -v zsh &>/dev/null; then
  sudo apt-get install -y zsh
  chsh -s $(which zsh)
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo "✅ Oh My Zsh installed."
fi

# Plugins & themes (optional customization)

# ------------------------------------------------------------------------
# ✅ Finalization
# ------------------------------------------------------------------------
echo "✅ Bootstrap completed: $(date)"
echo "📄 Log saved to: $LOG_FILE"
