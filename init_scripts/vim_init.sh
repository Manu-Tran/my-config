#!/bin/bash

set -e

# Vimrc initialization
if [[ -e $HOME/.vimrc ]]; then
    if ! cmp -s "$HOME/.vimrc" "$HOME/my-config/vim/vimrc"; then
        if [[ -n $CONFIG_BACKUP_PATH ]]; then
            mv "$HOME/.vimrc" "$CONFIG_BACKUP_PATH"
            echo "Saved old .vimrc to $CONFIG_BACKUP_PATH !"
        fi
    fi
fi
ln -rsf "$HOME/my-config/vim/vimrc" ~/.vimrc


# Vundle download
VUNDLE_PATH=~/.vim/bundle/Vundle.vim

if [ -e $VUNDLE_PATH ]; then
    echo -n "Vundle.vim repository found. Pulling... "
    git -C $VUNDLE_PATH pull
else
    echo -n "Cloning Vundle.vim repository... "
    git clone https://github.com/VundleVim/Vundle.vim.git $VUNDLE_PATH
fi
echo "Done"

# Required to prevent yankring from writing in $HOME
mkdir -p ~/.vim/buffers

# Vundle launch
echo -n "Installing vim plugins... "
vim +PluginInstall +qall
echo "Done"

