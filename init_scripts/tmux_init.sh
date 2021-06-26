#!/bin/bash

set -e

# tmux initialization
ln -rsf "tmux/tmux.conf" ~/.tmux.conf
TMUX_FOLDER="~/.tmux"

# tpm initialization
if [ -f "$TMUX_FOLDER"/plugins/tpm ]; then
    echo -n "TPM repository found. Pulling... "
    git -C "$TMUX_FOLDER"/plugins/tpm pull
else
    echo "Cloning TPM repository... "
    git clone https://github.com/tmux-plugins/tpm "$TMUX_FOLDER"/plugins/tpm
fi
echo "Done"








