#!/bin/sh

aerospace focus --window-id $(aerospace list-windows --all --format "%{window-id}%{right-padding} | %{app-name} | %{window-title}" | grep "| zoom.us |" | cut -d' ' -f1 | head -n1)
