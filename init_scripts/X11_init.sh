#!/bin/bash

set -e

echo -n "Customizing X11kb..."

cp /usr/share/X11/xkb/symbols/fr X11/fr_backp
ln -rsf "X11/fr" /usr/share/X11/xkb/symbols/fr

echo "Done"

