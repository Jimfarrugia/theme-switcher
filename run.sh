#!/usr/bin/env bash

# Desc: Applies a theme to all themeable apps. (see scripts in /apply)
#       If not running in a KDE environment:
#         - Calls the wallpaper script with a theme wallpaper.
#         - Saves theme data to ~/.local/share/theme_data
#
# Usage: run.sh "theme_name" "skip_gtk (true|false)"

set -euo pipefail

export SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Make sure theme name was provided
if [[ -z "${1-}" ]]; then
  echo -e "\e[31m \e[0m Theme name argument wasn't provided."
  exit 1
fi

THEME_NAME="$1"
SKIP_GTK="${2:-false}"

# Prettify the theme name
formatted_theme_name="${THEME_NAME//_/ }"
PRETTY_THEME_NAME=""
for word in $formatted_theme_name; do
  capitalized_word="${word^}" # Capitalize the first letter of the word
  PRETTY_THEME_NAME+="$capitalized_word "
done
PRETTY_THEME_NAME="${PRETTY_THEME_NAME%?}" # remove trailing space

echo "Switching theme to $PRETTY_THEME_NAME."

# Apply theme to each application
echo -e "\nApplying $PRETTY_THEME_NAME theme..."
for script in "$SCRIPT_DIR"/apply/apply_*.sh; do
  # Skip GTK script if SKIP_GTK is true
  if [[ "$SKIP_GTK" == "true" && "$(basename "$script")" == "apply_gtk_theme.sh" ]]; then
    echo "Skipping applying GTK theme."
    continue
  fi
  bash "$script" "$THEME_NAME"
done

# (if desktop env is not KDE)
if ! pacman -Q plasma-desktop &>/dev/null; then
  # Set wallpaper
  shopt -s nullglob
  WALLPAPERS=("$HOME/Pictures/Wallpaper/themes/$THEME_NAME"/00*)
  DEFAULT_WALLPAPER="${WALLPAPERS[0]}"
  bash wallpaper "$DEFAULT_WALLPAPER"

  # Save theme data
  echo -e "\nSaving theme data..."
  THEME_DATA_FILE="$HOME/.local/share/theme_data"
  echo "THEME_NAME=$THEME_NAME" >"$THEME_DATA_FILE"
  echo "WALLPAPER=$DEFAULT_WALLPAPER" >>"$THEME_DATA_FILE"
  echo -e "Theme data saved to: $THEME_DATA_FILE"
fi

sleep 1

echo -e "\n\e[33m󱁖 \e[32m Great success!\e[0m Enjoy $PRETTY_THEME_NAME vibes!"
