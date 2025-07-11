
#!/bin/bash

echo "🔧 Setting up dotfiles..."

# Backup existing
mkdir -p ~/.dotfiles_backup
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.dotfiles_backup/

# Symlink dotfiles
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.aliases ~/.aliases

# Optionally install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "✅ Dotfiles setup complete. Please restart your shell or run: source ~/.zshrc"
