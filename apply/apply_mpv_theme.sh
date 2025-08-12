#!/usr/bin/env bash

#
# Desc: Change the background color of the mpv window
#
# Usage: apply_imv_theme.sh "theme_name"
#

set -eo pipefail

MPV_CONFIG_FILE="$HOME/.config/mpv/mpv.conf"

THEME_NAME="$1" # eg. tokyo_night

# Add new themes here (value is the theme's background color)
declare -A themes
themes["tokyo_night"]="#1A1B26"
themes["dracula"]="#282A36"
themes["gruvbox"]="#282828"
themes["nord"]="#2E3440"
themes["catppuccin"]="#1E1E2E"
themes["rose_pine"]="#191724"
themes["everforest"]="#272E33"

# Make sure theme name was provided
if [[ -z $THEME_NAME ]]; then
  echo -e "\e[31m \e[0mmpv theme name argument wasn't provided."
  exit 1
fi

# Check if a key of $THEME_NAME exists in the array
if [[ -z "${themes[$THEME_NAME]+_}" ]]; then
  echo -e "\e[31m \e[0mmpv theme '$THEME_NAME' not found."
  exit 1
fi

# Make sure the config file exists
if [[ ! -f "$MPV_CONFIG_FILE" ]]; then
  echo -e "\e[31m \e[0mmpv config file not found."
  exit 1
fi

# Get the new background color from the theme
new_background="${themes[$THEME_NAME]}"

# Replace the 'background' line in the config file
sed -i "s/^background-color.*/background-color=\"$new_background\"/" "$MPV_CONFIG_FILE"

echo -e "\e[32m✅ \e[0mmpv theme '$THEME_NAME' applied."
