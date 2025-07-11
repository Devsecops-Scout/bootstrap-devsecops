#!/bin/bash
# Dotfiles Setup Script for ZSH and DevSecOps Customization
# Author: devsecops_scout
# Last Updated: 2025-07-10

set -euo pipefail

echo "🎯 Setting up personalized dotfiles..."

# ------------------------------------------------------------------------
# Define dotfiles location (can be cloned from repo or local)
# ------------------------------------------------------------------------
DOTFILES_DIR="$HOME/.dotfiles"
mkdir -p "$DOTFILES_DIR"

# Example .zshrc
cat > "$DOTFILES_DIR/.zshrc" << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(git docker kubectl zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Aliases
alias k='kubectl'
alias kns='kubectl config set-context --current --namespace'
alias kc='kubectl config current-context'

# PATH
export PATH="$HOME/bin:/usr/local/bin:$PATH"
EOF

# ------------------------------------------------------------------------
# Symlink to home directory
# ------------------------------------------------------------------------
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Optional: Install useful ZSH plugins
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# ------------------------------------------------------------------------
# Finalize
# ------------------------------------------------------------------------
echo "✅ Dotfiles installed. Open new terminal or run: source ~/.zshrc"
