#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Search Repo PR
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./ico/github.ico
# @raycast.packageName Web Searches
# @raycast.argument1 { "type": "text", "placeholder": "branch" }
# @raycast.argument2 { "type": "text", "placeholder": "repo", "optional": true }

if [ -z "$2" ]; then
    open "https://github.com/search?type=pullrequests&auto_enroll=true&q=org%3ADataDog+head%3A${1// /%20}"
else
    open "https://github.com/search?type=pullrequests&auto_enroll=true&q=org%3ADataDog+repo:DataDog/${2// /%20}+head%3A${1// /%20}"
fi

