#!/usr/bin/env bash

#
# Desc: Change the theme & icon-theme definition in the gtk config file
#
# Usage: apply_gtk_theme.sh "theme_name"
#

if pacman -Q gtk3 &>/dev/null; then

  THEME_NAME="$1"
  THEME_DIR="$HOME/.local/share/themes/$THEME_NAME"
  ICON_DIR="$HOME/.local/share/icons/$THEME_NAME"
  GTK3_CONFIG="$HOME/.config/gtk-3.0/settings.ini"
  GTK4_CONFIG="$HOME/.config/gtk-4.0/settings.ini"

  # Make sure theme name was provided
  if [[ -z $THEME_NAME ]]; then
    echo -e "\e[31m \e[0mGTK theme name argument wasn't provided."
    exit 1
  fi

  # Make sure the theme directory exists
  if [[ ! -d "$THEME_DIR" ]]; then
    echo -e "\e[31m \e[0mGTK theme '$THEME_NAME' not found."
    exit 1
  fi

  # Make sure the icon-theme directory exists
  if [[ ! -d "$ICON_DIR" ]]; then
    echo -e "\e[31m \e[0mGTK icon-theme '$THEME_NAME' not found."
    exit 1
  fi

  # Make sure the theme directory is readable
  if [[ ! -r "$THEME_DIR" ]]; then
    echo -e "\e[31m \e[0mGTK theme '$THEME_NAME' directory exists but is not readable."
    exit 1
  fi

  # Make sure the icon-theme directory is readable
  if [[ ! -r "$ICON_DIR" ]]; then
    echo -e "\e[31m \e[0mGTK icon-theme '$THEME_NAME' directory exists but is not readable."
    exit 1
  fi

  update_or_add_setting() {
    local file="$1"
    local key="$2"
    local value="$3"

    if [[ ! -f "$file" ]]; then
      # Create file with basic [Settings] section and the key
      echo -e "[Settings]\n${key}=${value}" >"$file"
      echo "Created $file with $key=$value"
    else
      if grep -q "^${key}=" "$file"; then
        # Replace existing key
        sed -i "s|^${key}=.*|${key}=${value}|" "$file"
        echo "Updated $key in $file to $value"
      else
        # Add key under [Settings] section
        # Insert after [Settings] line or at start if no section found
        if grep -q "^\[Settings\]" "$file"; then
          sed -i "/^\[Settings\]/a ${key}=${value}" "$file"
        else
          # No [Settings] section, prepend it
          sed -i "1i [Settings]\n${key}=${value}" "$file"
        fi
        echo "Added $key=$value to $file"
      fi
    fi
  }

  # Update gtk-3.0 config
  mkdir -p "$(dirname "$GTK3_CONFIG")"
  update_or_add_setting "$GTK3_CONFIG" "gtk-theme-name" "$THEME_NAME"
  update_or_add_setting "$GTK3_CONFIG" "gtk-icon-theme-name" "$THEME_NAME"

  # Update gtk-4.0 config only if directory exists
  if [[ -d "$(dirname "$GTK4_CONFIG")" ]]; then
    update_or_add_setting "$GTK4_CONFIG" "gtk-theme-name" "$THEME_NAME"
    update_or_add_setting "$GTK4_CONFIG" "gtk-icon-theme-name" "$THEME_NAME"
  else
    echo "Skipping gtk-4.0 config update (directory not found)."
  fi

  # Apply live changes via gsettings
  gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME"
  gsettings set org.gnome.desktop.interface icon-theme "$THEME_NAME"

  echo -e "\e[32m✅ \e[0mGTK theme '$THEME_NAME' applied."

fi
