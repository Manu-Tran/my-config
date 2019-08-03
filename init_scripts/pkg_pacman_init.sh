#!/bin/bash

set -e

read -p "Do you want to install the package ? (y/N) : " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing packages..."
    sudo pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort pkglist.txt))
fi
