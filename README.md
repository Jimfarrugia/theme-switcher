# Theme Switcher

Todo
- yazi script
- kitty
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

## Script

- (Later) Re-color profile-pic/logo with theme colors using imagemagick.

- change wallpaper to one from `~/Pictures/Wallpaper/themes/theme_name/`
- execute/source `apply_rofi_theme.sh "theme_name"`
- ^ repeat for all 'apply' scripts

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
- [ ] kitty
- [ ] hyprland
- [ ] hyprlock
- [ ] bat
- [ ] eza
- [ ] yazi
- [x] btop
- [x] waybar
- [ ] dunst
- [x] rofi
- [x] imv
- [x] mpv
- [ ] starship
- [ ] gtk
- [ ] fastfetch
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

Theme switcher script should execute `apply_rofi_theme.sh "theme_name"`.

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

Theme switcher script should execute `apply_waybar_theme.sh "theme_name"`.

## btop

- [x] Tokyo Night
- [x] Dracula

Place theme files in `~/.config/btop/themes/` and define the current theme in `~/.config/btop/btop.conf`.

- `apply_btop_theme.sh "theme_name"`
  - change `color_theme` definition in `~/.config/btop/btop.conf`

Theme switcher script should execute `apply_btop_theme.sh "theme_name"`

## imv

- [x] Tokyo Night
- [x] Dracula

The background color is the only difference between themes.

New themes need to be added to the associative array in `apply_imv_theme.sh`.

- `apply_imv_theme.sh "theme_name"`
  - has an associative array of themes with their background colors
  - replaces the background color in the current config 
    with the selected theme's background color.

Theme switcher script should execute `apply_imv_theme.sh "theme_name"`

## mpv

- [x] Tokyo Night
- [x] Dracula

The background color is the only difference between themes.

New themes need to be added to the associative array in `apply_mpv_theme.sh`.

- `apply_imv_theme.sh "theme_name"`
  - has an associative array of themes with their background colors
  - replaces the background color in the current config 
    with the selected theme's background color.

Theme switcher script should execute `apply_imv_theme.sh "theme_name"`

## Yazi

Dracula (maybe more?) uses a 'flavor' file to configure the theme 
whereas Tokyo Night uses the theme.toml file directly.

Probably a good idea to create a themes directory in yazi's config directory.

Have a directory in `themes` for each theme.

Each theme's directory will contain all the files needed to apply and use it.

Our 'apply' script will copy the contents of the theme directory to the yazi config directory.

What we want to end up with is:
`yazi/theme.toml` defines current theme or points to flavor
`yazi/theme.tmTheme` (sublime config file) for syntax highlighting
(if applicable) `yazi/flavors/theme_name.yazi` defines theme

seems like flavor defined themes just use a couple lines in `theme.toml` to point to the flavor.

[Flavors documentation](https://yazi-rs.github.io/docs/flavors/overview/)

apply script:
  - validate theme_name
  - `rm -rf flavors` to remove it if it exists
  - `rm -rf theme.tmTheme` ^
  - `rm -rf theme.toml` ^
  - copy `yazi/themes/theme_name/*` to `yazi/`

## Kitty

