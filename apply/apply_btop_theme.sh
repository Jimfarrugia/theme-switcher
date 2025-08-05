#!/usr/bin/env bash

#
# Desc: Change the theme definition in the btop config file
#
# Usage: apply_btop_theme.sh "theme_name"
#

set -eo pipefail

THEME_NAME="$1" # eg. tokyo_night

BTOP_CONFIG_DIR="$HOME/.config/btop"
BTOP_CONFIG_FILE="$BTOP_CONFIG_DIR/btop.conf"
THEME_FILE="$BTOP_CONFIG_DIR/themes/$THEME_NAME.theme"

# Make sure theme name was provided
if [[ -z $THEME_NAME ]]; then
  echo -e "\e[31m \e[0mbtop theme name argument wasn't provided."
  exit 1
fi

# Make sure the theme file exists
if [[ ! -f "$THEME_FILE" ]]; then
  echo -e "\e[31m \e[0mbtop theme '$THEME_NAME' not found."
  exit 1
fi

# Make sure the config file exists
if [[ ! -f "$BTOP_CONFIG_FILE" ]]; then
  echo -e "\e[31m \e[0mbtop config file not found."
  exit 1
fi

# Replace the 'color_theme' line in the config file
sed -i "s|^color_theme.*|color_theme = \"$THEME_FILE\"|" "$BTOP_CONFIG_FILE"

echo -e "\e[32m \e[0mbtop theme '$THEME_NAME' applied."
