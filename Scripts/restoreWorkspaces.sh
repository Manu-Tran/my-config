#!/bin/bash

set -x

move_windows(){
    local space=$1
    shift
    local arr=("$@")
        for window in "${arr[@]}" ;
        do
            yabai -m window $window --space $space &
        done
}

YABAI_QUERY=$(yabai -m query --windows)

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.title | contains("Jira")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 8 $WINDOW_SEL &
fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.app | contains("Telegram")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 5 $WINDOW_SEL &
fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.title | contains("Terminal")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 11 $WINDOW_SEL &
fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.app | contains("Alacritty")) | select (.title != "AlacrittyScratchpad") | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 11 $WINDOW_SEL &
fi

# WINDOW_SEL=
# WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.app | contains("Emacs")) | select (.title != "EmacsScratchpad")| .id')
# if [[ ! -z $WINDOW_SEL ]]; then
#     move_windows 6 $WINDOW_SEL &
# fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.app | contains("IntelliJ IDEA")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 6 $WINDOW_SEL &
fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.app | contains("IntelliJ IDEA")) | select (.title | contains("Run - logs-backend-1")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 11 $WINDOW_SEL &
fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.app | contains("PyCharm")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 6 $WINDOW_SEL &
fi

# WINDOW_SEL=
# WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.title | contains(".org")) | .id')
# if [[ ! -z $WINDOW_SEL ]]; then
#     move_windows 8 $WINDOW_SEL
# fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.app | contains("Spotify")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 2 $WINDOW_SEL &
fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.app | contains("Google Calendar")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 3 $WINDOW_SEL &
fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.app | contains("Slack")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 4 $WINDOW_SEL &
fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.title | contains("Datadog Mail")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 13 $WINDOW_SEL &
fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.title | contains("Monitoring")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 7 $WINDOW_SEL &
fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.title | contains("Navigator")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 9 $WINDOW_SEL &
fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.title | contains("Aux")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 10 $WINDOW_SEL &
fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.title | contains("– Manu")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 12 $WINDOW_SEL &
fi

WINDOW_SEL=
WINDOW_SEL=$(echo $YABAI_QUERY | jq '.[] | select (.app | contains("Emacs")) | select (.title | contains("OrgWindow")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    move_windows 8 $WINDOW_SEL &
fi




osascript -e 'display notification "Script Run Sucessfully" with title "Restore Workspace"'
