#!/bin/bash

set -e

# Zshrc initialization
ln -rsf "zsh/zshrc" ~/.zshrc
ln -rsf "zsh/zshenv" ~/.zshenv

source ~/.zshenv

# OhMyZsh initialization
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    echo -n "OMZSH repository found. Pulling... "
    git -C "$ZSH" pull
else
    echo "Cloning OMZSH repository... "
    git clone https://github.com/robbyrussell/oh-my-zsh.git "$ZSH"
fi
echo "Done"

#==============================================================================
# Plugins

# Completion initialization
if [ -d "$ZSH/custom/plugins/zsh-syntax-highlighting" ]; then
    echo -n "zsh-syntax-highlighting found. Pulling... "
    git -C "$ZSH/custom/plugins/zsh-syntax-highlighting" pull
else
    echo -n "Cloning zsh-syntax-highlighting repository... "
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH/custom/plugins/zsh-syntax-highlighting"
fi
echo "Done"

# Completion initialization
if [ -d "$ZSH/custom/plugins/zsh-autosuggestions" ]; then
  echo -n "zsh-autosuggestions found. Pulling... "
  git -C "$ZSH/custom/plugins/zsh-autosuggestions" pull
else
  echo -n "Cloning zsh-autosuggestions repository... "
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH/custom/plugins/zsh-autosuggestions"
fi
echo "Done"

# Completion initialization
if [ -d "$ZSH/custom/plugins/zsh-completions" ]; then
  echo -n "zsh-completions found. Pulling... "
  git -C "$ZSH/custom/plugins/zsh-completions" pull
else
  echo -n "Cloning zsh-completions repository... "
  git clone https://github.com/zsh-users/zsh-completions.git "$ZSH/custom/plugins/zsh-completions"
fi
echo "Done"

#==============================================================================
# Themes

# Powerlevel9k initialization
if [ -d "$ZSH/custom/themes/powerlevel10k" ]; then
  echo -n "Powerlevel10k found. Pulling... "
  git -C "$ZSH/custom/themes/powerlevel10k" pull
else
  echo -n "Cloning Powerlevel10k repository... "
  git clone https://github.com/romkatv/powerlevel10k "$ZSH/custom/themes/powerlevel10k"
fi
echo "Done"

echo -n "Changing default shell... "
chsh -s "$(command -v zsh)"
echo "Done"








