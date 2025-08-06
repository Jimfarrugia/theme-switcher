# Theme Switcher

Todo
- dunst
- hyprland
- hyprlock
- lift TN window border color from omarchy
- try omarchy's hyprlock styling
```
general {
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
}
```

`bg transparent`
- dracula `30, 31, 41, 0.7`
- tokyo `26, 27, 38, 0.7`

Thought: if we conditionally change the theme for each package depending 
on whether it's installed or not, this theme switcher could be pretty portable;
even to KDE.

---

## Plan

- Make every config themeable with this system.
- Write parent script to:
  - run validation scripts for configs with templates
  - apply theme to every config
  - change wallpaper to one from theme
  - save name of current theme in $XDG_DATA_HOME
  - (Later) Re-color profile-pic/logo with theme colors using imagemagick.
- Write a command/shortcut to use rofi as a selection ui
  - display shortcuts to run switcher for available themes
  - shortcuts will only be displayed in this window
  - current theme is highlighted (sourced from $XDG_DATA_HOME)
  - after selecting one, theme changes, then
    - show rofi menu for accepting or cycling wallpaper



## Themes

Starting with Tokyo Night and Dracula just to prove the concept but these are the main themes I'd like to have available.

- Tokyo Night (tokyo_night)
- Dracula (dracula)
- Catppuccin Mocha (catppuccin_mocha)
- Nordic (nordic)
- Gruvbox Dark (gruvbox_dark)
- Everforest (everforest)
- Hot Purple Traffic Light** (new custom palette theme based on btop theme)

## Themeable Programs

Checking these off when:
- I can confirm it is themeable with this system
- It is documented in this file
- There are at least 2 themes ready to be applied it

- [ ] nvim
- [x] kitty
- [ ] hyprland
- [ ] hyprlock
- [x] bat
- [x] eza
- [x] yazi
- [x] btop
- [x] waybar
- [ ] dunst
- [x] rofi
- [x] imv
- [x] mpv
- [x] starship
- [ ] gtk
- [ ] firefox
- [ ] git

---

## Rofi

- [x] Tokyo Night
- [x] Dracula

The Rofi theme is set in `~/.config/rofi/config.rasi` by importing the main theme file (`theme.rasi`).

The main theme file exists solely to import two files:
  - `rofi/themes/base.rasi` which defines styling common between all themes.
  - `rofi/themes/colorschemes/theme_name.rasi` which defines the colors and variable values used in the theme.

- `apply_rofi_theme.sh "theme_name"`
  - change color scheme file import in `~/.config/rofi/theme.rasi`

## Waybar

- [x] Tokyo Night
- [x] Dracula

There is no way to apply different styling to sections of Waybar modules without using inline styling.

Wherever possible, styling is applied with `style.css` and theme specific values are defined in `colors.css` which is imported by `style.css`.

Styling the modules' icons differently from the text is done by wrapping the icons with span tags which have a color attribute.

So we have a template file (`config.template.jsonc`) with variable names in place of the color values.

The script, `apply_waybar_theme.sh` is used to replace the variable names with the actual values and save the result to the final config file (`config.jsonc`).

When adding a new theme, a directory with the name of the theme should be created in the themes directory. The new directory should contain a `colors.sh` file with the color values for inline styling.  The new directory should also contain a `colors.css` file with values for the css variables used in `style.css`.

- `apply_waybar_theme.sh "theme_name"`
  - source `~/.config/waybar/themes/theme_name/colors.sh`
  - expand variables in template with values from `colors.sh` (using envsubst)
  - save result as `~/.config/waybar/config.jsonc` (overwriting existing)
  - copy `~/.config/waybar/themes/theme_name/colors.css` to `~/.config/waybar/colors.css` (overwriting existing)
  - restart waybar silently

## btop

- [x] Tokyo Night
- [x] Dracula

Place theme files in `~/.config/btop/themes/` and define the current theme in `~/.config/btop/btop.conf`.

- `apply_btop_theme.sh "theme_name"`
  - change `color_theme` definition in `~/.config/btop/btop.conf`

## imv

- [x] Tokyo Night
- [x] Dracula

The background color is the only difference between themes.

New themes need to be added to the associative array in `apply_imv_theme.sh`.

- `apply_imv_theme.sh "theme_name"`
  - has an associative array of themes with their background colors
  - replaces the background color in the current config 
    with the selected theme's background color.

## mpv

- [x] Tokyo Night
- [x] Dracula

The background color is the only difference between themes.

New themes need to be added to the associative array in `apply_mpv_theme.sh`.

- `apply_imv_theme.sh "theme_name"`
  - has an associative array of themes with their background colors
  - replaces the background color in the current config 
    with the selected theme's background color.

## Yazi

- [x] Tokyo Night
- [x] Dracula

There are multiple methods for theming Yazi.

So we have a `themes` directory in the Yazi config directory
which has a subdirectory for each theme.

Each theme's contains all the files needed to apply and use it.

When a theme is applied, the current theme's files are removed from the Yazi config directory's root level and the contents of the new theme's folder are copied there to become the new current theme.

Each theme consists of:
- `theme.toml` defines current theme or points to flavor
- `theme.tmTheme` (sublime config file) for syntax highlighting
- `flavors/theme_name.yazi` (if applicable) defines theme
  - `flavor.toml` main theme file
  - `tmtheme.xml` syntax highlighting

[Flavors documentation](https://yazi-rs.github.io/docs/flavors/overview/)

`apply_yazi_theme.sh "theme_name"`
  - `rm -rf flavors` to remove it if it exists
  - `rm -rf theme.tmTheme` ^
  - `rm -rf theme.toml` ^
  - copy `yazi/themes/theme_name/*` to `yazi/`

## Kitty

- [x] Tokyo Night
- [x] Dracula

Each theme has a `.conf` file in `~/.config/kitty/themes/`.

The current theme is kept in `~/.config/kitty/theme.conf`.

`apply_kitty_theme.sh "theme_name`
  - overwrite `~/.config/kitty/theme.conf` with the new theme's file

## bat

- [x] Tokyo Night
- [x] Dracula

Theme is defined in the `bat/config` file.

It references the name of a built-in theme or the name of a theme in `bat/themes` (without the file extension).
```
--theme="current-theme"
```

Custom themes can be added to `bat/themes` as a `.tmTheme` (sublime config) file.

Built-in themes can be listed with `bat --list-themes`.

After adding a custom theme, you need to run `bat cache --build` to make it available to bat.

> [!NOTE] There are built-in themes for dracula, nord and gruvbox-dark.

`apply_bat_theme.sh "theme_name"`
  - run `bat cache --build` to make sure newly added themes are available
  - Copy the new theme's file to overwrite `current-theme.tmTheme`

## eza

- [x] Tokyo Night
- [x] Dracula

[Eza community themes](https://github.com/eza-community/eza-themes) (has most of the themes I want) I downloaded them all.  They're in the config dir.

> [!NOTE] 'frosty' looks like it would fit well as a stand-in for Nord.

`apply_eza_theme.sh "theme_name"`
  - overwrite `eza/theme.yml` in the config directory
    with new theme file from the `eze/themes/` directory.

## Starship

- [x] Tokyo Night
- [x] Dracula

Starship's theming is baked into the general configuration. There are no separate theme files.

There is no way to directly import other files or use variables within `starship.toml`.

So we have a template file (`starship.template.toml`) with variable names in place of the color values.

The script, `apply_starship_theme.sh` is used to replace the variable names with the actual values and save the result to the final config file (`starship.toml`).

When adding a new theme, a `theme_name.sh` file should be created in the themes directory. This file should export the variables to be used in the template.

When updating the template or theme, any newly added variables need to be named in uppercase snake_case or they will not be substituted in the final config file.

There is a validation script in the theme-switcher project (`validate_starship_theme.sh`) which checks for anything that might cause the final config file not to generate correctly from the template.

- `apply_starship_theme.sh "theme_name"`
  - source placeholder values from `~/.config/starship/themes/theme_name.sh`
  - expand placeholder variables in template with values (using envsubst)
  - save result as `~/.config/starship.toml` (overwriting existing)
