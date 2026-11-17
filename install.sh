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
[ -f "$DOTFILES_DIR/.tmux.conf" ] && ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

# Neovim (LazyVim) config: ~/.config/nvim -> dotfiles/nvim
# An existing real directory is moved aside, never deleted.
mkdir -p "$HOME/.config"
if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%Y%m%d%H%M%S)"
fi
ln -sfn "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Scripts (dev, tmux-sessionizer) -> ~/.local/bin, which .zshrc puts on PATH
mkdir -p "$HOME/.local/bin"
for f in "$DOTFILES_DIR"/bin/*; do ln -sf "$f" "$HOME/.local/bin/$(basename "$f")"; done

# Project folder used by `dev` and tmux-sessionizer
mkdir -p "$HOME/code"

# SSH: pull in the dotfiles' server config (port forwards etc.).
# Include must come before any Host block, so it's prepended to ~/.ssh/config.
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
touch "$HOME/.ssh/config" && chmod 600 "$HOME/.ssh/config"
INCLUDE_LINE="Include $DOTFILES_DIR/ssh/bsun-server.conf"
if ! grep -qF "$INCLUDE_LINE" "$HOME/.ssh/config"; then
  { echo "$INCLUDE_LINE"; echo; cat "$HOME/.ssh/config"; } > "$HOME/.ssh/config.tmp"
  mv "$HOME/.ssh/config.tmp" "$HOME/.ssh/config" && chmod 600 "$HOME/.ssh/config"
fi

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

# CLI tools (neovim, tmux, ripgrep, ...) from the Brewfile
if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DOTFILES_DIR/Brewfile"
else
  echo "Homebrew not found: install it from https://brew.sh, then re-run ./install.sh"
fi

# tmux plugin manager + plugins (only where tmux is installed)
if command -v tmux >/dev/null 2>&1; then
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" || echo "tpm: open tmux and press prefix I to install plugins"
fi

echo "Done. Run: source ~/.zshrc"
