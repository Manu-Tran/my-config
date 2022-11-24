#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Search on Confluence
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./ico/confluence.ico
# @raycast.packageName Web Searches
# @raycast.argument1 { "type": "text", "placeholder": "search" }

open "https://datadoghq.atlassian.net/wiki/search?text=${1// /%20}"
