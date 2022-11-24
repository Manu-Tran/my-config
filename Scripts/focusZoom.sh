WINID=$(yabai -m query --windows | jq '((.[]| select((.app == "zoom.us") and (.title == "Zoom"))).id)');
if [ ! -z "$WINID" ]; then
    yabai -m window --focus "$WINID"
fi

sleep 0.2

WINID=$(yabai -m query --windows | jq '((.[]| select((.app == "zoom.us") and (.title == "Zoom Meeting"))).id)');
if [ ! -z "$WINID" ]; then
    yabai -m window --focus "$WINID"
fi

