#!/usr/bin/env bash

#
# Desc: Apply a theme from the themes directory.
#
# Usage: apply_waybar_theme.sh "theme_name"
#

set -eo pipefail

WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
WAYBAR_THEMES_DIR="$WAYBAR_CONFIG_DIR/themes"

CONFIG_TEMPLATE_FILE="$WAYBAR_CONFIG_DIR/config.template.jsonc"
FINAL_CONFIG_FILE="$WAYBAR_CONFIG_DIR/config.jsonc"

THEME_NAME="$1" # eg. tokyo_night
THEME_DIR="$WAYBAR_THEMES_DIR/$THEME_NAME"

# Make sure theme name was provided
if [[ -z $THEME_NAME ]]; then
  echo -e "\e[31m \e[0mWaybar theme name argument wasn't provided."
  exit 1
fi

# Make sure the theme exists
if [[ ! -d "$THEME_DIR" ]]; then
  echo -e "\e[31m \e[0mWaybar theme '$THEME_NAME' not found."
  exit 1
fi

# Make sure required theme files exist
if [[ ! -f "$THEME_DIR/colors.sh" || ! -f "$THEME_DIR/colors.css" ]]; then
  echo -e "\e[31m \e[0mWaybar theme '$THEME_NAME' is missing required files."
  exit 1
fi

# Import theme color variables
source "$THEME_DIR/colors.sh"

# Substitute variables into the template
envsubst <"$CONFIG_TEMPLATE_FILE" >"$FINAL_CONFIG_FILE"

# Overwrite current colors.css file with the theme's colors.css file
cp "$THEME_DIR/colors.css" "$WAYBAR_CONFIG_DIR/colors.css"

# Restart Waybar silently
killall waybar >/dev/null 2>&1 || true
sleep 0.3
(waybar >/dev/null 2>&1 &) &
disown

echo -e "\e[32m \e[0mWaybar theme '$THEME_NAME' applied."
