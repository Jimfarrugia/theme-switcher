#!/usr/bin/env bash

#
# Desc: Apply a theme file from the themes directory by overwriting
#       the current theme file with it.
#
# Usage: apply_dunst_theme.sh "theme_name"
#

set -eo pipefail

if pacman -Q dunst &>/dev/null; then

  THEME_NAME="$1" # eg. tokyo_night

  DUNST_CONFIG_DIR="$HOME/.config/dunst"
  THEMES_DIR="$DUNST_CONFIG_DIR/themes"
  THEME_FILE="$THEMES_DIR/$THEME_NAME.conf"

  # Make sure theme name was provided
  if [[ -z $THEME_NAME ]]; then
    echo -e "\e[31m \e[0mDunst theme name argument wasn't provided."
    exit 1
  fi

  # Make sure the theme exists
  if [[ ! -f "$THEME_FILE" ]]; then
    echo -e "\e[31m \e[0mDunst theme '$THEME_NAME' not found."
    exit 1
  fi

  # Overwrite current theme file with a copy of the new theme's file.
  cp "$THEME_FILE" "$DUNST_CONFIG_DIR/dunstrc.d/current_theme.conf"

  # Restart dunst service
  systemctl --user restart dunst

  echo -e "\e[32m✅ \e[0mDunst theme '$THEME_NAME' applied."

fi
