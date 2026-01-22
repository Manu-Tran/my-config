#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Search Google Search
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./ico/google.ico
# @raycast.packageName Web Searches
# @raycast.argument1 { "type": "text", "placeholder": "search" }

open "https://cloudsearch.google.com/cloudsearch/search?q=${1// /%20}"

