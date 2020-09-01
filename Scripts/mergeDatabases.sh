#!/bin/bash

set -e

KEEPASS_DIR=~/Documents/KeePass
KEEPASS_REMOTE_DIR=GDrive:/PassVault

syncCloudVerification(){
    echo "Change detected ! Cloning..."
    rclone sync "$KEEPASS_REMOTE_DIR"/ManuPass.kdbx "$KEEPASS_DIR"/remote
    echo "Merging..."
    keepassxc-cli merge -s "$KEEPASS_DIR"/ManuPass.kdbx "$KEEPASS_DIR"/remote/ManuPass.kdbx
    echo "Sync with cloud..."
    rclone sync "$KEEPASS_DIR"/ManuPass.kdbx "$KEEPASS_REMOTE_DIR"
    echo "Done !"
}
