#!/bin/bash

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
~/.emacs.d/bin/doom install

ln -sf ~/my-config/doom.d ~/.doom.d
~/.emacs.d/bin/doom sync


