#!/bin/bash
# Usage: ./update_config.sh ".layout.barMode" '"attached"'

KEY="$1"
VALUE="$2"
CONFIG="$HOME/.config/myshell/config.json"
TMP=$(mktemp)

jq "$KEY = $VALUE" "$CONFIG" > "$TMP" && mv "$TMP" "$CONFIG"
