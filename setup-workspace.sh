#!/bin/bash

cd my-config
sudo xargs -a packages.txt sudo apt-get install
./init_script/vim_init.sh
./init_script/zsh_init.sh
./init_script/emacs_init.sh
./init_script/tmux_init.sh
setup-workspace

