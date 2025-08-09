#!/usr/bin/env bash

#
# Requires: perl
#
# Desc: Modify the firefox css file with color values from
#       the new theme.
#
# Usage: apply_firefox_theme.sh "theme_name"
#

set -eo pipefail

THEME_NAME="$1" # eg. tokyo_night
DOTFILES_FIREFOX_CONFIG="$HOME/dotfiles/_unstowed/.mozilla/firefox/profile.default-release"
THEME_FILE="$DOTFILES_FIREFOX_CONFIG/chrome/themes/$THEME_NAME.css"

FIREFOX_DIR="$HOME/.mozilla/firefox"
FIREFOX_PROFILE_DIR=$(find "$FIREFOX_DIR" -maxdepth 1 -type d -name "*.default-release" | head -n 1)
FIREFOX_CSS_FILE="$FIREFOX_PROFILE_DIR/chrome/userChrome.css"

# Make sure theme name was provided
if [[ -z $THEME_NAME ]]; then
  echo -e "\e[31m \e[0mFirefox theme name argument wasn't provided."
  exit 1
fi

# Make sure the theme exists
if [[ ! -f "$THEME_FILE" ]]; then
  echo -e "\e[31m \e[0mFirefox theme '$THEME_NAME' not found."
  exit 1
fi

# Make sure Firefox is not running
if pgrep -x firefox >/dev/null; then
  echo -e "\e[31m \e[0mFirefox is currently running. Please close it first."
  exit 1
fi

# Make sure Perl is installed
if ! command -v perl >/dev/null; then
  echo -e "\e[31m \e[0mPerl is not installed. Please install it first."
  exit 1
fi

# Make sure firefox css directory exists
mkdir -p "$FIREFOX_PROFILE_DIR/chrome"

# Copy custom firefox css file
new_file="$DOTFILES_FIREFOX_CONFIG/chrome/new_userChrome.css"
cp "$DOTFILES_FIREFOX_CONFIG/chrome/userChrome.css" "$new_file"

# Replace the first `:root { ... }` section in $new_file
# Use Perl for multi-line and first-match replacement
perl -0777 -pe '
    my $theme = do { local(@ARGV, $/) = ("'"$THEME_FILE"'"); <> };
    s/:root\s*\{.*?\}/$theme/s;
' "$new_file" >"$FIREFOX_CSS_FILE"

# Cleanup
rm -rf "$new_file"

echo -e "\e[32m✅ \e[0mFirefox theme '$THEME_NAME' applied."
