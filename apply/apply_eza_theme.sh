#!/usr/bin/env bash

#
# Desc: Apply a theme file from the themes directory by overwriting
#       the current theme file with it.
#
# Usage: apply_eza_theme.sh "theme_name"
#

set -eo pipefail

EZA_CONFIG_DIR="$HOME/.config/eza"

THEME_NAME="$1" # eg. tokyo_night
THEME_FILE="$EZA_CONFIG_DIR/themes/$THEME_NAME.yml"

# Make sure theme name was provided
if [[ -z $THEME_NAME ]]; then
  echo -e "\e[31m \e[0meza theme name argument wasn't provided."
  exit 1
fi

# Make sure the theme exists
if [[ ! -f "$THEME_FILE" ]]; then
  echo -e "\e[31m \e[0meza theme '$THEME_NAME' not found."
  exit 1
fi

# Overwrite current theme file with a copy of the new theme's file.
cp "$THEME_FILE" "$EZA_CONFIG_DIR/theme.yml"

echo -e "\e[32m✅ \e[0meza theme '$THEME_NAME' applied."
