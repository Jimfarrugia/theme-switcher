#!/usr/bin/env bash

#
# Desc: Apply a theme file from the themes directory by overwriting
#       the current theme file with it.
#
# Usage: apply_hyprland_theme.sh "theme_name"
#

set -eo pipefail

THEME_NAME="$1" # eg. tokyo_night

HYPR_CONFIG_DIR="$HOME/.config/hypr"
THEMES_DIR="$HYPR_CONFIG_DIR/themes/hyprland"
THEME_FILE="$THEMES_DIR/$THEME_NAME.conf"

# Make sure theme name was provided
if [[ -z $THEME_NAME ]]; then
  echo -e "\e[31m \e[0mHyprland theme name argument wasn't provided."
  exit 1
fi

# Make sure the theme exists
if [[ ! -f "$THEME_FILE" ]]; then
  echo -e "\e[31m \e[0mHyprland theme '$THEME_NAME' not found."
  exit 1
fi

# Overwrite current theme file with a copy of the new theme's file.
cp "$THEME_FILE" "$THEMES_DIR/current_theme.conf"

echo -e "\e[32m✅ \e[0mHyprland theme '$THEME_NAME' applied."
