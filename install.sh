#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Symlink dotfiles
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
[ -f "$DOTFILES_DIR/.gitconfig" ] && ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
[ -f "$DOTFILES_DIR/.vimrc" ] && ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"

# Symlink custom OMZ plugins/themes
rm -rf "$HOME/.oh-my-zsh/custom"
ln -sf "$DOTFILES_DIR/oh-my-zsh-custom" "$HOME/.oh-my-zsh/custom"

# Clone common plugins if referenced in .zshrc but missing
if grep -q "zsh-autosuggestions" "$HOME/.zshrc" && [ ! -d "$DOTFILES_DIR/oh-my-zsh-custom/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$DOTFILES_DIR/oh-my-zsh-custom/plugins/zsh-autosuggestions"
fi
if grep -q "zsh-syntax-highlighting" "$HOME/.zshrc" && [ ! -d "$DOTFILES_DIR/oh-my-zsh-custom/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$DOTFILES_DIR/oh-my-zsh-custom/plugins/zsh-syntax-highlighting"
fi

echo "Done. Run: source ~/.zshrc"
