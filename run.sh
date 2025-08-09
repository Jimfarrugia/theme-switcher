#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Make sure theme name was provided
if [[ -z "${1-}" ]]; then
  echo -e "\e[31m \e[0m Theme name argument wasn't provided."
  exit 1
fi

THEME_NAME="$1"

# Prettify the theme name
formatted_theme_name="${THEME_NAME//_/ }"
PRETTY_THEME_NAME=""
for word in $formatted_theme_name; do
  capitalized_word="${word^}" # Capitalize the first letter of the word
  PRETTY_THEME_NAME+="$capitalized_word "
done
PRETTY_THEME_NAME="${PRETTY_THEME_NAME%?}" # remove trailing space

echo "Switching theme to $PRETTY_THEME_NAME."

# Validate waybar theme
echo -e "\nValidating Waybar theme..."
WAYBAR_TEMPLATE_FILE="$HOME/.config/waybar/config.template.jsonc"
WAYBAR_THEME_FILE="$HOME/.config/waybar/themes/$THEME_NAME/colors.sh"
bash "$SCRIPT_DIR/validate_template_theme.sh" "$WAYBAR_TEMPLATE_FILE" "$WAYBAR_THEME_FILE"

# Validate starship theme
echo -e "\nValidating Starship theme..."
STARSHIP_TEMPLATE_FILE="$HOME/.config/starship/starship.template.toml"
STARSHIP_THEME_FILE="$HOME/.config/starship/themes/$THEME_NAME.sh"
bash "$SCRIPT_DIR/validate_template_theme.sh" "$STARSHIP_TEMPLATE_FILE" "$STARSHIP_THEME_FILE"
