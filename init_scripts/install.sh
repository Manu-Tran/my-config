#!/bin/bash

set -e

export CONFIG_BACKUP_PATH="$HOME/my-config/backup_config"

if [[ ! -e $CONFIG_BACKUP_PATH ]]; then
    mkdir "$CONFIG_BACKUP_PATH"
fi

echo "Running init scripts..."
$HOME/my-config/init_scripts/*_init.sh
echo "Initialization completed ! Please reboot !"
