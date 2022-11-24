#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Search SDP
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./ico/datadog.ico
# @raycast.packageName Web Searches
# @raycast.argument1 { "type": "text", "placeholder": "workload" }

open "https://sdp.ddbuild.io/#/deployments/services/${1// /-}"
