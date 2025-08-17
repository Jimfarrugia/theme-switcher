#!/usr/bin/env bash

#
# Desc: Change the color scheme file import in the rofi theme.rasi file
#
# Usage: apply_rofi_theme.sh "theme_name"
#

set -eo pipefail

if pacman -Q rofi &>/dev/null; then

  ROFI_CONFIG_DIR="$HOME/.config/rofi"
  ROFI_THEME_FILE="$ROFI_CONFIG_DIR/theme.rasi"
  COLORSCHEMES_DIR="$ROFI_CONFIG_DIR/themes/colorschemes"

  THEME_NAME="$1" # eg. tokyo_night

  # Make sure theme name was provided
  if [[ -z $THEME_NAME ]]; then
    echo -e "\e[31m \e[0mRofi theme name argument wasn't provided."
    exit 1
  fi

  # Make sure the color scheme file exists
  if [[ ! -f "$COLORSCHEMES_DIR/$THEME_NAME.rasi" ]]; then
    echo -e "\e[31m \e[0mRofi color scheme '$THEME_NAME' not found."
    exit 1
  fi

  # Change the name of the color scheme file to import in theme.rasi
  sed -i "s|\(@import \"themes/colorschemes/\)[^\"]*\(.rasi\"\)|\1$THEME_NAME\2|" "$ROFI_THEME_FILE"

  echo -e "\e[32m✅ \e[0mRofi theme '$THEME_NAME' applied."

fi
