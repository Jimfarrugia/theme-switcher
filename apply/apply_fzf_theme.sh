#!/usr/bin/env bash

#
# Desc: Apply a theme file from the themes directory by overwriting
#       the current theme file with it.
#
# Note: Unlike the other 'apply' scripts, this one will just skip applying
#       the theme if there is no theme file instead of exiting.
#
# Usage: apply_fzf_theme.sh "theme_name"
#

set -eo pipefail

if pacman -Q fzf &>/dev/null; then

  THEME_NAME="$1" # eg. tokyo_night

  THEMES_DIR="$ZSH_CONFIG_HOME/fzf_themes"
  THEME_FILE="$THEMES_DIR/$THEME_NAME.zsh"

  # Make sure theme name was provided
  if [[ -z $THEME_NAME ]]; then
    echo -e "\e[31m \e[0mfzf theme name argument wasn't provided."
    exit 1
  fi

  # Skip applying this theme if there is no theme file
  if [[ ! -f "$THEME_FILE" ]]; then
    echo -e "\e[31m \e[0mfzf theme '$THEME_NAME' not found... Skipping."
  else
    # Overwrite current theme file with a copy of the new theme's file.
    cp "$THEME_FILE" "$ZSH_CONFIG_HOME/fzf_colors.zsh"
    echo -e "\e[32m✅ \e[0mfzf theme '$THEME_NAME' applied."
  fi

fi
