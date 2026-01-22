TEMP=$(yabai -m query --windows)

set -xo

WINID=$(echo $TEMP | jq 'map(select((.app == "zoom.us") and (.title == "Zoom Meeting")) | .id) | first');
if [ ! "$WINID" == "null" ]; then
    echo 1
    yabai -m window --focus "$WINID"
    exit
fi


WINID=$(echo $TEMP | jq 'map(select((.app == "zoom.us") and (.title == "Zoom")) | .id) | first');
if [ ! "$WINID" == "null" ]; then
    echo 2
    yabai -m window --focus "$WINID"
    exit
fi

WINID=$(echo $TEMP | jq 'map(select((.app == "zoom.us") and (.title == "Zoom Webinar")) | .id) | first');
if [ ! "$WINID" == "null" ]; then
    echo 3
    yabai -m window --focus "$WINID"
    exit
fi

WINID=$(echo $TEMP | jq 'map(select(.app == "zoom.us") | .id) | first');
if [ ! "$WINID" == "null" ]; then
    echo 4
    yabai -m window --focus "$WINID"
    exit
fi

