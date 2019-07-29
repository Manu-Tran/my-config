#!/bin/bash

set -e

echo -n "Initializing i3 & i3blocks... "

mkdir ~/.config/i3       2> /dev/null
mkdir ~/.config/i3blocks 2> /dev/null

ln -rsf "i3/config" ~/.config/i3/config
ln -rsf "i3blocks/config" ~/.config/i3blocks/config

echo "Done"

