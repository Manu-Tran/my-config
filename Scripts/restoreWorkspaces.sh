#!/bin/bash

set -x

WINDOW_SEL=
WINDOW_SEL=$(yabai -m query --windows |jq '.[] | select (.title | contains("Jira")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    yabai -m window $WINDOW_SEL --space 8
fi

WINDOW_SEL=
WINDOW_SEL=$(yabai -m query --windows |jq '.[] | select (.app | contains("Telegram")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    yabai -m window $WINDOW_SEL --space 5
fi

WINDOW_SEL=
WINDOW_SEL=$(yabai -m query --windows |jq '.[] | select (.title | contains("Space7")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    yabai -m window $WINDOW_SEL --space 7
fi

WINDOW_SEL=
WINDOW_SEL=$(yabai -m query --windows |jq '.[] | select (.title | contains("Space9")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    yabai -m window $WINDOW_SEL --space 9
fi

WINDOW_SEL=
WINDOW_SEL=$(yabai -m query --windows |jq '.[] | select (.title | contains("Space10")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    yabai -m window $WINDOW_SEL --space 10
fi

WINDOW_SEL=
WINDOW_SEL=$(yabai -m query --windows |jq '.[] | select (.title | contains("Space11")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    yabai -m window $WINDOW_SEL --space 11
fi

WINDOW_SEL=
WINDOW_SEL=$(yabai -m query --windows |jq '.[] | select (.app | contains("Emacs")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    yabai -m window $WINDOW_SEL --space 6
fi

WINDOW_SEL=
WINDOW_SEL=$(yabai -m query --windows |jq '.[] | select (.title | contains(".org")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    yabai -m window $WINDOW_SEL --space 8
fi

WINDOW_SEL=
WINDOW_SEL=$(yabai -m query --windows |jq '.[] | select (.app | contains("Spotify")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    yabai -m window $WINDOW_SEL --space 2
fi

WINDOW_SEL=
WINDOW_SEL=$(yabai -m query --windows |jq '.[] | select (.title | contains("Datadog - Calendar")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    yabai -m window $WINDOW_SEL --space 3
fi

WINDOW_SEL=
WINDOW_SEL=$(yabai -m query --windows |jq '.[] | select (.app | contains("Slack")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    yabai -m window $WINDOW_SEL --space 4
fi

WINDOW_SEL=
WINDOW_SEL=$(yabai -m query --windows |jq '.[] | select (.title | contains("Datadog Mail")) | .id')
if [[ ! -z $WINDOW_SEL ]]; then
    yabai -m window $WINDOW_SEL --space 13
fi



