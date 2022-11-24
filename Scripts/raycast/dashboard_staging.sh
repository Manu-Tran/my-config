#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Search Dashboard Staging
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./ico/datadog.ico
# @raycast.packageName Web Searches
# @raycast.argument1 { "type": "text", "placeholder": "dashboard" }

open "https://dd.datad0g.com/dashboard/lists?q=${1// /%20}"
