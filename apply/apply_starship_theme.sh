#!/usr/bin/env bash

#
# Desc: Apply a theme from the themes directory.
#
# Usage: apply_starship_theme.sh "theme_name"
#

if pacman -Q starship &>/dev/null; then

  STARSHIP_CONFIG_DIR="$HOME/.config/starship"

  THEME_NAME="$1"
  THEME_FILE="$STARSHIP_CONFIG_DIR/themes/$THEME_NAME.sh"

  CONFIG_TEMPLATE_FILE="$STARSHIP_CONFIG_DIR/starship.template.toml"
  FINAL_CONFIG_FILE="$STARSHIP_CONFIG_DIR/starship.toml"

  # Make sure theme name was provided
  if [[ -z $THEME_NAME ]]; then
    echo -e "\e[31m \e[0mStarship theme name argument wasn't provided."
    exit 1
  fi

  if [[ ! -f "$THEME_FILE" ]]; then
    echo -e "\e[31m \e[0mStarship theme not found: $THEME_FILE"
    exit 1
  fi

  # Validate starship theme
  echo -e "\nValidating Starship theme..."
  bash "$SCRIPT_DIR/validate_template_theme.sh" "$CONFIG_TEMPLATE_FILE" "$THEME_FILE"

  # Source and export all theme variables
  source "$THEME_FILE"

  # Extract all UPPERCASE snake_case environment variable names
  PLACEHOLDERS=$(compgen -v | grep -E '^[A-Z_]+$' | tr '\n' ' ')

  # Use envsubst to substitute only those variables
  envsubst "$(
    for var in $PLACEHOLDERS; do
      printf "\${%s} " "$var"
    done
  )" <"$CONFIG_TEMPLATE_FILE" >"$FINAL_CONFIG_FILE"

  echo -e "\e[32m✅ \e[0mStarship theme '$THEME_NAME' applied."

fi
