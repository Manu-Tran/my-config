WINID=$(yabai -m query --windows | jq '((.[]| select((.app == "zoom.us") and (.title == "Zoom Meeting"))).id)');
if [ -z "$WINID" ]; then
    skhd --key "alt - 0x15"
else
    yabai -m window --focus "$WINID"
fi

