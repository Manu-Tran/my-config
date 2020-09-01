#!/bin/bash

set -e

KEEPASS_DIR=~/Documents/KeePass
KEEPASS_REMOTE_DIR=GDrive:/PassVault

syncCloudVerification(){
  if [[ ! $(rclone md5sum $KEEPASS_REMOTE_DIR | cut -f1 -d' ') == $(md5sum "$KEEPASS_DIR"/ManuPass.kdbx | cut -f1 -d ' ') ]]; then
    echo "Change detected ! Cloning..."
    rclone sync "$KEEPASS_REMOTE_DIR"/ManuPass.kdbx "$KEEPASS_DIR"/remote
    echo "Merging..."
    keepassxc-cli merge -s "$KEEPASS_DIR"/ManuPass.kdbx "$KEEPASS_DIR"/remote/ManuPass.kdbx
    echo "Cleaning..."
    rm -rf "$KEEPASS_DIR"/remote
    echo "Sync with cloud..."
    rclone sync "$KEEPASS_DIR"/ManuPass.kdbx "$KEEPASS_REMOTE_DIR"
    echo "Done !"
  else
    echo "Nothing to do !"
  fi
}

pullCloud(){
  if [[ ! $(rclone md5sum $KEEPASS_REMOTE_DIR | cut -f1 -d' ') == $(md5sum "$KEEPASS_DIR"/remote/ManuPass.kdbx | cut -f1 -d ' ') ]]; then
    echo "Change detected ! Cloning..."
    rclone sync "$KEEPASS_REMOTE_DIR"/ManuPass.kdbx "$KEEPASS_DIR"/remote
  else
    echo $(date --rfc-3339=seconds) "Nothing to do !"
  fi
}

pushCloud(){
  if  [[ $(rclone md5sum $KEEPASS_REMOTE_DIR | cut -f1 -d' ') == $(md5sum "$KEEPASS_DIR"/remote/ManuPass.kdbx | cut -f1 -d ' ') ]]; then
    cp "$KEEPASS_DIR"/ManuPass.kdbx "$KEEPASS_DIR"/remote/ManuPass.kdbx
    rclone sync "$KEEPASS_DIR"/remote/ManuPass.kdbx "$KEEPASS_REMOTE_DIR"
    echo $(date --rfc-3339=seconds) "Synced with the cloud !"
  else
    $(pullCloud)
    notify-send "Keepass conflict detected" "Manual merge is required";
  fi
}

while true; do
  inotifywait -e OPEN -e DELETE_SELF "$KEEPASS_DIR"/ManuPass.kdbx |
    while read file action; do
      echo $(date --rfc-3339=seconds) "$action detected !"
      if [[ "$action" == "OPEN" ]]; then
        pullCloud;
      fi
      if [[ "$action" == "DELETE_SELF" ]]; then
        pushCloud;
      fi
    done
done

