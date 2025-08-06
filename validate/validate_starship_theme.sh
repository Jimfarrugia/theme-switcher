#!/usr/bin/env bash

#
# Desc: Compares theme file and template to warn if any variables:
#       - Are used in the template but not exported (ignoring commented lines)
#       - Are exported in the theme but never used
#       - Are defined in theme but don't follow naming convention and are used in template
#
# Usage: validate_starship_theme.sh "theme_name"
#

set -euo pipefail

THEME_NAME="$1"
CONFIG_DIR="$HOME/.config/starship"
TEMPLATE_FILE="$CONFIG_DIR/starship.template.toml"
THEME_FILE="$CONFIG_DIR/themes/$THEME_NAME.sh"

# Make sure theme name was provided
if [[ -z $THEME_NAME ]]; then
  echo -e "\e[31m \e[0mStarship theme name argument wasn't provided."
  exit 1
fi

echo "Validating Starship theme: $THEME_NAME"

# Make sure theme file exists
if [[ ! -f "$THEME_FILE" ]]; then
  echo -e "\e[33m❌\e[0m Starship theme file not found: $THEME_FILE"
  exit 1
fi

# Make sure template exists
if [[ ! -f "$TEMPLATE_FILE" ]]; then
  echo -e "\e[33m❌\e[0m Starship config template not found: $TEMPLATE_FILE"
  exit 1
fi

# Extract all placeholders from the template (ignores commented lines)
TEMPLATE_VARS=$(grep -v '^[[:space:]]*#' "$TEMPLATE_FILE" | grep -o '\${[A-Z0-9_]\+}' | tr -d '${}' | sort -u)

# Extract all exported placeholders from the theme file
THEME_EXPORTS=$(grep -oE '^export +[A-Z0-9_]+=' "$THEME_FILE" | sed 's/^export *//' | cut -d= -f1 | sort -u)

# Check for template placeholders missing in theme
echo -e "\e[33m🔍\e[0m Checking for undefined variables used in template..."
MISSING_IN_THEME=0
for var in $TEMPLATE_VARS; do
  if ! echo "$THEME_EXPORTS" | grep -q "^$var$"; then
    echo -e "\e[31m⚠️\e[0m Missing placeholder value in theme: $var"
    ((MISSING_IN_THEME++))
  fi
done

# Check for unused theme exports
echo -e "\e[33m🔍\e[0m Checking for unused variables exported in theme..."
UNUSED_IN_TEMPLATE=0
for var in $THEME_EXPORTS; do
  if ! echo "$TEMPLATE_VARS" | grep -q "^$var$"; then
    echo -e "\e[31m⚠️\e[0m Unused theme export: $var"
    ((UNUSED_IN_TEMPLATE++))
  fi
done

# Check for lowercase or invalid vars used in template
echo -e "\e[33m🔍\e[0m Checking for placeholders that won't be substituted..."
BAD_THEME_VARS=$(grep -oE '^export +[^ =]+' "$THEME_FILE" | sed 's/^export *//' | cut -d= -f1 | grep -vE '^[A-Z_]+$' || true)
INVALID_VARS_USED=0
for var in $BAD_THEME_VARS; do
  if grep -q "\${$var}" "$TEMPLATE_FILE"; then
    echo -e "\e[31m⚠️\e[0m Invalid placeholder used in template: $var"
    ((INVALID_VARS_USED++))
  fi
done
if [[ $INVALID_VARS_USED -gt 0 ]]; then
  echo -e "\e[31m⚠️\e[33m All placeholders need to be uppercase snake_case to be substituted with theme values.\e[0m"
fi

echo -e "\e[32m✅\e[0m Validation complete."

if [[ $MISSING_IN_THEME -eq 0 && $UNUSED_IN_TEMPLATE -eq 0 && $INVALID_VARS_USED -eq 0 ]]; then
  echo -e "\e[32m✅\e[0m All good! No issues found."
else
  echo -e "\e[32m❗\e[0m Fix the warnings above to ensure full consistency."
  exit 1
fi
