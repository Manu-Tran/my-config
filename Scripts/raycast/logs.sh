#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Search service logs
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./ico/datadog.ico
# @raycast.packageName Web Searches
# @raycast.argument1 { "type": "text", "placeholder": "search" }

search=${1// /%2D}
if [[ $search == "rr" ]]; then
    search="logs%2Drum%2Dreducer"
fi

if [[ $search == "rvr" ]]; then
    search="logs%2Drum%2Dview%2Dreducer"
fi

if [[ $search == "rmr" ]]; then
    search="rum%2Dmetrics%2Dreducer"
fi

if [[ $search == "sr" ]]; then
    search="sketch%2Dreducer"
fi

open "https://app.datadoghq.com/logs?query=service%3A$search"
