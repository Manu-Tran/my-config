WINID=$(yabai -m query --windows | jq '((.[]| select(.app == "Spotify")).id)');
if [ -z "$WINID" ]; then
    /Applications/Spotify.app/Contents/MacOS/Spotify
else
    yabai -m window --focus "$WINID"
fi

