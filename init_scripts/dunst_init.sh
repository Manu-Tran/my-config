#!/bin/bash

set -e

echo -n "Configuring dunst... "
# Dunstrc initialization
if [[ -e $HOME/.config/dunst ]]; then
  if [[ -e $HOME/.config/dunst/dunstrc ]]; then
      if ! cmp -s "$HOME/.config/dunstrc" "$HOME/my-config/dunst/dunstrc"; then
          if [[ -n $CONFIG_BACKUP_PATH ]]; then
              mv "$HOME/.config/dunst/dunstrc" "$CONFIG_BACKUP_PATH"
              echo "Saved old dunstrc to $CONFIG_BACKUP_PATH !"
          fi
      fi
    fi
fi
ln -rsf "$HOME/my-config/dunst/dunstrc" ~/.config/dunst/dunstrc

echo "Done"

