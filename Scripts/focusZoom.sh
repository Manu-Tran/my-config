WINID=$(yabai -m query --windows | jq '((.[]| select(.app == "zoom.us")).id)');
if [ -z "$WINID" ]; then
    /Applications/zoom.us.app/Contents/MacOS/zoom.us
    skhd --key "alt - 0x15"
else
    yabai -m window --focus "$WINID"
fi

