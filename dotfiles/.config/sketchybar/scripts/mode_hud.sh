#!/usr/bin/env sh

PIDFILE="${TMPDIR:-/tmp}/sketchybar_mode_hud.pid"
MODE_TEXT="${MODE:-}"

if [ -n "$CONFIG_DIR" ] && [ -f "$CONFIG_DIR/colors.sh" ]; then
  # shellcheck disable=SC1090
  source "$CONFIG_DIR/colors.sh"
fi

if [ -z "$MODE_TEXT" ] || [ "$MODE_TEXT" = "null" ]; then
  exit 0
fi

# Cancel any pending hide to prevent flicker.
if [ -f "$PIDFILE" ]; then
  OLD_PID="$(cat "$PIDFILE" 2>/dev/null)"
  case "$OLD_PID" in
    ''|*[!0-9]*) : ;;
    *) kill "$OLD_PID" 2>/dev/null || true ;;
  esac
fi

sketchybar --animate sin 14 --set "$NAME" \
  drawing=on \
  label="$MODE_TEXT" \
  background.color="${ITEM_BG:-0x9924273a}" \
  background.border_color="${LAVENDER:-0xffb4befe}"

(
  sleep 0.85
  sketchybar --animate sin 14 --set "$NAME" \
    drawing=off \
    background.border_color="${CLEAR:-0x00000000}"
) &

printf '%s' "$!" >"$PIDFILE"
