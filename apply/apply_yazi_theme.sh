#!/usr/bin/env bash

#
# Desc: Apply a theme from the themes directory by copying the theme's
#       files to the yazi config directory.
#
# Usage: apply_yazi_theme.sh "theme_name"
#

set -eo pipefail

if pacman -Q yazi &>/dev/null; then

  YAZI_CONFIG_DIR="$HOME/.config/yazi"
  YAZI_THEMES_DIR="$YAZI_CONFIG_DIR/themes"

  THEME_NAME="$1" # eg. tokyo_night
  THEME_DIR="$YAZI_THEMES_DIR/$THEME_NAME"

  # Make sure theme name was provided
  if [[ -z $THEME_NAME ]]; then
    echo -e "\e[31m \e[0mYazi theme name argument wasn't provided."
    exit 1
  fi

  # Make sure the theme exists
  if [[ ! -d "$THEME_DIR" ]]; then
    echo -e "\e[31m \e[0mYazi theme '$THEME_NAME' not found."
    exit 1
  fi

  # Remove current theme's files from the config directory
  rm -rf "$YAZI_CONFIG_DIR/flavors" \
    "$YAZI_CONFIG_DIR/theme.tmTheme" "$YAZI_CONFIG_DIR/theme.toml"

  # Copy the new theme's files to the config directory
  cp -r "$THEME_DIR/." "$YAZI_CONFIG_DIR/"

  echo -e "\e[32m✅ \e[0mYazi theme '$THEME_NAME' applied."

fi
