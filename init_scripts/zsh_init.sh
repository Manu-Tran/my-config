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

# Powerlevel9k initialization
if [ -d "$ZSH/custom/themes/powerlevel9k" ]; then
    echo -n "Powerlevel9k found. Pulling... "
    git -C "$ZSH/custom/themes/powerlevel9k" pull
else
    echo -n "Cloning Powerlevel9k repository... "
    git clone https://github.com/bhilburn/powerlevel9k.git "$ZSH/custom/themes/powerlevel9k"
fi
echo "Done"

echo -n "Changing default shell... "
chsh -s "$(command -v zsh)"
echo "Done"








