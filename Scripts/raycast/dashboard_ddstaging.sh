#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Search DDStaging Dashboard
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./ico/datadog.ico
# @raycast.packageName Web Searches
# @raycast.argument1 { "type": "text", "placeholder": "dashboard" }

res=$(grep $(echo "$1" | sed 's/ /.*/') dashboard_ddstaging.ini | head -n 1 | sed 's|.*= "https://\(.*\)"|\1|')
if [[ -z $res ]]; then
    open "https://ddstaging.datadoghq.com/dashboard/lists?q=${1// /%20}"
else
    open "https://$res"
    exit 0
fi
