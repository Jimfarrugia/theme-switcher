#!/usr/bin/env bash

#
# Desc: Apply a theme file from the themes directory by overwriting
#       the current theme file with it.
#
# Usage: apply_kitty_theme.sh "theme_name"
#

set -eo pipefail

KITTY_CONFIG_DIR="$HOME/.config/kitty"

THEME_NAME="$1" # eg. tokyo_night
THEME_FILE="$KITTY_CONFIG_DIR/themes/$THEME_NAME.conf"

# Make sure theme name was provided
if [[ -z $THEME_NAME ]]; then
  echo -e "\e[31m \e[0mKitty theme name argument wasn't provided."
  exit 1
fi

# Make sure the theme exists
if [[ ! -f "$THEME_FILE" ]]; then
  echo -e "\e[31m \e[0mKitty theme '$THEME_NAME' not found."
  exit 1
fi

# Overwrite current theme file with a copy of the new theme's file.
cp "$THEME_FILE" "$KITTY_CONFIG_DIR/theme.conf"

# Reload kitty config
# (also handle case where kitty is not running so `kill` doesn't throw an error)
kitty_pids=$(pgrep kitty)
if [[ -n "$kitty_pids" ]]; then
  kill -SIGUSR1 $kitty_pids
fi

echo -e "\e[32m \e[0mKitty theme '$THEME_NAME' applied."
