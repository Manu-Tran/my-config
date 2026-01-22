#!/usr/bin/env bash

set -euox pipefail


APP_NAME="$1"
# if [ $# -gt 0 ]; then
#     APP_NAME="$1"
# else
#     hide_all
#     exit 0
# fi

echo $#
if [ $# -gt 1 ]; then
    WINDOW_NAME="$2"
else
    WINDOW_NAME=""
fi
echo $(date +%s%N | cut -b1-13)
CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)

get_window_id() {
    if [ $# -gt 1 ]; then
        a=$2
    else
        a=""
    fi
    aerospace list-windows --all --format "%{window-id}%{right-padding} | %{app-name} | %{window-title}" | grep "| $1 |" | grep "$a" | cut -d' ' -f1 | head -n1
}

focus_app() {
    app_window_id=$1
    aerospace move-node-to-workspace "$CURRENT_WORKSPACE" --window-id "$app_window_id"
    aerospace focus --window-id "$app_window_id"
    hs -c "centerWindow()"
}

is_app_closed() {
    app_window_id=$1
    ! aerospace list-windows --all --format '%{window-id}' | grep -q "$app_window_id"
}

move_app_to_scratchpad() {
    app_window_id=$1
    aerospace move-node-to-workspace .scratchpad --window-id "$app_window_id"
}

# hide_all() {
#     for window in ["Obsidian", "alacritty Scratchpad", "Emacs Scratchpad", "KeePassXC"]; do
#         move_app_to_scratch_pad window
#     done
# }

main() {
    echo $(date +%s%N | cut -b1-13)
    app_id=$(get_window_id $APP_NAME $WINDOW_NAME)
    if is_app_closed $app_id; then
        echo $(date +%s%N | cut -b1-13)
        open -a "$APP_NAME"
        sleep 0.5
    elif aerospace list-windows --workspace "$CURRENT_WORKSPACE" --format "%{window-id}" | grep -q $app_id; then
    echo $(date +%s%N | cut -b1-13)
        move_app_to_scratchpad $app_id
    echo $(date +%s%N | cut -b1-13)
    else
    echo $(date +%s%N | cut -b1-13)
        focus_app $app_id
    echo $(date +%s%N | cut -b1-13)
    fi
}
main
