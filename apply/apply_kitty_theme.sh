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
# Use an array to safely capture all kitty PIDs from pgrep.
# Avoids word-splitting/globbing issues and passes shellcheck cleanly.
mapfile -t kitty_pids < <(pgrep kitty)
if ((${#kitty_pids[@]} > 0)); then
  kill -SIGUSR1 "${kitty_pids[@]}"
fi

echo -e "\e[32m✅ \e[0mKitty theme '$THEME_NAME' applied."
