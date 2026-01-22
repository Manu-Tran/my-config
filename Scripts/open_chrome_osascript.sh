index=$(yabai -m query --spaces --space | jq .index)
echo $index
WINDOW_NAME="Others"
if [[ $index == "7" ]]; then
    WINDOW_NAME="Monitoring"
else if [[ $index == "9" ]]; then
    WINDOW_NAME="Navigator"
else if [[ $index == "10" ]]; then
    WINDOW_NAME="Auxiliary"
else if [[ $index == "12" ]]; then
    WINDOW_NAME="Perso"
fi fi fi fi
open -na 'Google Chrome' --args --window-name="$WINDOW_NAME" --new-window --profile-directory=Default
sleep 2
~/bin/restoreWorkspaces.sh
# osascript -e 'tell application "Google Chrome" to make new window with properties { name:"'$WINDOW_NAME'" }' && ~/bin/restoreWorkspaces.sh



