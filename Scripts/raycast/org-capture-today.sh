#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Create Org TODO today
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🪄
# @raycast.argument1 { "type": "text", "placeholder": "Task Title" }
# @raycast.argument2 { "type": "text", "placeholder": "Additional Information", "optional": true}
# @raycast.packageName Task Management

# Documentation:
# @raycast.description Create a new todo today in work.org

emacsclient -e "(progn (org-capture-string \"* TODO $1\n$2\" \"x\")(org-capture-finalize))"
