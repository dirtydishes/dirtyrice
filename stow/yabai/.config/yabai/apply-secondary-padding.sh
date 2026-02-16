#!/usr/bin/env sh

set -eu

if ! command -v yabai >/dev/null 2>&1; then
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

PADDING="${1:-12}"

PRIMARY_DISPLAY="$(yabai -m query --displays | jq -r '.[] | select(.frame.x == 0 and .frame.y == 0) | .index' | head -n 1)"
[ -n "$PRIMARY_DISPLAY" ] || PRIMARY_DISPLAY=1

yabai -m query --spaces \
  | jq -r --argjson primary "$PRIMARY_DISPLAY" '.[] | select(.display != $primary and ."is-native-fullscreen" == false) | .index' \
  | while IFS= read -r space_index; do
      [ -n "$space_index" ] || continue
      yabai -m config --space "$space_index" top_padding "$PADDING"
      yabai -m config --space "$space_index" bottom_padding "$PADDING"
      yabai -m config --space "$space_index" left_padding "$PADDING"
      yabai -m config --space "$space_index" right_padding "$PADDING"
    done
