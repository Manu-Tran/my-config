#!/bin/bash

set -e

echo -n "Configuring polybar... "
# Polybar initialization
if [[ -e $HOME/.config/polybar ]]; then
      if ! diff -rq "$HOME/.config/polybar" "$HOME/my-config/polybar"; then
          if [[ -n $CONFIG_BACKUP_PATH ]]; then
              mv "$HOME/.config/polybar" "$CONFIG_BACKUP_PATH"
              echo "Saved old polybar folder to $CONFIG_BACKUP_PATH !"
          fi
    fi
fi
ln -rsf "$HOME/my-config/polybar" ~/.config/polybar

echo "Done"

