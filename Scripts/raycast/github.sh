#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Search Repo
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./ico/github.ico
# @raycast.packageName Web Searches
# @raycast.argument1 { "type": "text", "placeholder": "repo" }

open "https://github.com/DataDog/${1// /%20}"
