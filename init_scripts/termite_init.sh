#!/bin/bash

set -e

echo -n "Configuring termite... "

mkdir ~/.config/termite       2> /dev/null
ln -rsf "termite/config" ~/.config/termite/config
ln -rsf "compton/compton.conf" ~/.config/compton.conf

echo "Done"

