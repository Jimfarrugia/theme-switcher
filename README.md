# Theme Switcher

1. [Themes](#Themes)
2. [Themeable Programs](#Themeable-Programs)
3. [Wallpaper](#Wallpaper)
4. [Shortcut](#shortcut)
5. [Theming Strategies](#Theming-strategies)
    1. [Rofi](#rofi)
    2. [Waybar](#Waybar)
    3. [btop](#btop)
    4. [imv](#imv)
    5. [mpv](#mpv)
    6. [Yazi](#yazi)
    7. [Kitty](#kitty)
    8. [bat](#bat)
    9. [eza](#eza)
    10. [Starship](#starship)
    11. [Hyprland](#hyprland)
    12. [Hyprlock](#hyprlock)
    13. [dunst](#dunst)
    14. [Neovim](#nvim)
    15. [FZF](#fzf)
    16. [GTK](#gtk)
    17. [Firefox](#firefox)

---

## Notes:

### Todo:
- [ ] Modify `eza` 'frosty' theme to use nord color palette. (currently using frosty as a stand-in)

---

## Themes

- [x] Tokyo Night (tokyo_night)
- [x] Dracula (dracula)
- [x] Gruvbox Dark (gruvbox)
- [x] Nordic (nordic)
- [x] Catppuccin Mocha (catppuccin)
- [x] Rose Pine (rose_pine)
- [x] Everforest (everforest)
- [x] Eldritch (eldritch)
- Hot Purple Traffic Light** (new custom palette theme based on btop theme)

- A `.desktop` shortcut should be created in `~/.local/share/applications/` for newly created themes so they appear in the `select_theme` menu.

## Themeable Programs

- [x] nvim
- [x] kitty
- [x] hyprland
- [x] hyprlock
- [x] bat
- [x] eza
- [x] yazi
- [x] btop
- [x] waybar
- [x] dunst
- [x] rofi
- [x] imv
- [x] mpv
- [x] starship
- [x] gtk
- [x] firefox
- [x] tmux
- [ ] fzf

---

### Wallpaper

Theme wallpapers are in `~/Picutres/Wallpaper/themes/`.

There is a directory for each `theme_name` containing wallpapers that fit well with the theme.

---

### Shortcut

There is a `.desktop` file for each theme in `~/.local/share/applications/themes/`.

These are not hidden by default.  They are used to define the list items for the `select_theme` script which lists all available themes in a Rofi dmenu.

---

## Theming Strategies

The sections below document how each application is themed and how the theme switcher applies a new theme.

### Rofi

The Rofi theme is set in `~/.config/rofi/config.rasi` by importing the main theme file (`theme.rasi`).

The main theme file exists solely to import two files:
  - `rofi/themes/base.rasi` which defines styling common between all themes.
  - `rofi/themes/colorschemes/theme_name.rasi` which defines the colors and variable values used in the theme.

- `apply_rofi_theme.sh "theme_name"`
  - change color scheme file import in `~/.config/rofi/theme.rasi`

### Waybar

There is no way to apply different styling to sections of Waybar modules without using inline styling.

Wherever possible, styling is applied with `style.css` and theme specific values are defined in `colors.css` which is imported by `style.css`.

Styling the modules' icons differently from the text is done by wrapping the icons with span tags which have a color attribute.

So we have a template file (`config.template.jsonc`) with variable names in place of the color values.

The script, `apply_waybar_theme.sh` is used to replace the variable names with the actual values and save the result to the final config file (`config.jsonc`).

When adding a new theme, a directory with the name of the theme should be created in the themes directory. The new directory should contain a `colors.sh` file with the color values for inline styling.  The new directory should also contain a `colors.css` file with values for the css variables used in `style.css`.

You can validate a new theme (`colors.sh` file) without running the theme switcher by running:
```sh
validate_template_theme.sh /path/to/template/file /path/to/theme/file
```


- `apply_waybar_theme.sh "theme_name"`
  - source `~/.config/waybar/themes/theme_name/colors.sh`
  - expand variables in template with values from `colors.sh` (using envsubst)
  - save result as `~/.config/waybar/config.jsonc` (overwriting existing)
  - copy `~/.config/waybar/themes/theme_name/colors.css` to `~/.config/waybar/colors.css` (overwriting existing)
  - restart waybar silently

### btop

> [!NOTE]
> Built-in themes are found in `/usr/share/btop/themes/`.

Place theme files in `~/.config/btop/themes/` and define the current theme in `~/.config/btop/btop.conf`.

- `apply_btop_theme.sh "theme_name"`
  - change `color_theme` definition in `~/.config/btop/btop.conf`

### imv

The background color is the only difference between themes.

New themes need to be added to the associative array in `apply_imv_theme.sh`.

- `apply_imv_theme.sh "theme_name"`
  - has an associative array of themes with their background colors
  - replaces the background color in the current config 
    with the selected theme's background color.

### mpv

The background color is the only difference between themes.

New themes need to be added to the associative array in `apply_mpv_theme.sh`.

- `apply_imv_theme.sh "theme_name"`
  - has an associative array of themes with their background colors
  - replaces the background color in the current config 
    with the selected theme's background color.

### Yazi

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

### Kitty

> [!NOTE]
> You can run `kitten themes --dump-theme=yes` to search the built-in themes and save the one you select to the kitty config folder without applying it.

Each theme has a `.conf` file in `~/.config/kitty/themes/`.

The current theme is kept in `~/.config/kitty/theme.conf`.

`apply_kitty_theme.sh "theme_name`
  - overwrite `~/.config/kitty/theme.conf` with the new theme's file

### bat

Theme is defined in the `bat/config` file.

It references the name of a built-in theme or the name of a theme in `bat/themes` (without the file extension).
```
--theme="current-theme"
```

Custom themes can be added to `bat/themes` as a `.tmTheme` (sublime config) file.

Built-in themes can be listed with `bat --list-themes`.

> [!NOTE]
> Built-in themes can be found [here](#https://github.com/sharkdp/bat/tree/master/assets/themes)

After adding a custom theme, you need to run `bat cache --build` to make it available to bat.

> [!NOTE]
> There are built-in themes for dracula, nord and gruvbox-dark.

`apply_bat_theme.sh "theme_name"`
  - run `bat cache --build` to make sure newly added themes are available
  - Copy the new theme's file to overwrite `current-theme.tmTheme`

### eza

[Eza community themes](https://github.com/eza-community/eza-themes) (has most of the themes I want) I downloaded them all.  They're in the config dir.

`apply_eza_theme.sh "theme_name"`
  - overwrite `eza/theme.yml` in the config directory
    with new theme file from the `eze/themes/` directory.

### Starship

Starship's theming is baked into the general configuration. There are no separate theme files.

There is no way to directly import other files or use variables within `starship.toml`.

So we have a template file (`starship.template.toml`) with variable names in place of the color values.

The script, `apply_starship_theme.sh` is used to replace the variable names with the actual values and save the result to the final config file (`starship.toml`).

When adding a new theme, a `theme_name.sh` file should be created in the themes directory. This file should export the variables to be used in the template.

When updating the template or theme, any newly added variables need to be named in uppercase snake_case or they will not be substituted in the final config file.

There is a validation script in the theme-switcher project (`validate_template_theme.sh`) which checks for anything that might cause the final config file not to generate correctly from the template.

You can validate a new theme without running the theme switcher by running:
```sh
validate_template_theme.sh /path/to/template/file /path/to/theme/file
```

- `apply_starship_theme.sh "theme_name"`
  - source placeholder values from `~/.config/starship/themes/theme_name.sh`
  - expand placeholder variables in template with values (using envsubst)
  - save result as `~/.config/starship.toml` (overwriting existing)

### Hyprland

Hyprland and it's sister apps support directly sourcing `.conf` files in their configs.

New themes can be added to the appropriate directory within the `hypr/themes/` directory. (eg. `/hypr/themes/hyprland`)

Hyprland's theme file is sourced into the parent config file just like all the other inclusions.

`apply_hyprland_theme.sh "theme_name"`
  - overwrite `hypr/themes/hyprland/current_theme.conf` in the config directory
    with new theme file from the same directory.

### Hyprlock

Hyprland and it's sister apps support directly sourcing `.conf` files in their configs.

New themes can be added to the appropriate directory within the `hypr/themes/` directory. (eg. `/hypr/themes/hyprlock`)

Hyprland's theme file is sourced into the parent config file just like all the other inclusions.

`apply_hyprlock_theme.sh "theme_name"`
  - overwrite `hypr/themes/hyprlock/current_theme.conf` in the config directory
    with new theme file from the same directory.

### dunst

Zero files are natively imported by dunst.  Everything is supposed to be placed within `dunstrc`.  But many OS' will automatically merge 1 or more files from `~/.config/dunst/dunstrc.d/`. So at the time of writing, I had a `themes.conf` file in that directory which had both of my previous themes with only one that wasn't commented out.

The new strat is to put the new `current_theme.conf` file in `~/.config/dunst/dunstrc.d/` as the only file in that directory.  Themes will be kept in `~/.config/dunst/themes` and when switching themes, the new theme will be moved and renamed to the `dunstrc.d` directory.

Icon paths (or any path) in dunstrc or the theme must be absolute paths. Maybe in future if we want this script to be more portable, we can use a placeholder for the `$HOME` path instead of hardcoding it.

Icon themes are stored in `~/.config/dunst/icons/theme_name` and are referenced from theme files.

When adding a new theme, icons can be recolored with `imagemagick`:
```sh
# 'fill' is the new color
magick input.png -fill "#FFAAAA" -colorize 100% output.png
```

> [!NOTE]
> Most of the icons use the theme's primary accent color but some use the 'warning' and 'error' colors.  Check them first.

> [!IMPORTANT]
> Do not rename the icons, they are referenced by many scripts for custom notifications.

`apply_dunst_theme.sh "theme_name"`
  - overwrite `dunst/dunstrc.d/current_theme.conf` in the config directory
    with new theme file from `dunst/themes`
  - restart dunst service

### nvim

The current theme is defined in the `nvim/lua/plugins/colorscheme.lua` file.

A `themes` directory has been added to the nvim config directory which will store the theme collection.

`apply_nvim_theme.sh "theme_name"`
  - overwrite `nvim/lua/plugins/colorscheme.lua` in the config directory
    with new theme file from `nvim/themes`

### FZF

The colors are edited by setting the `$FZF_DEFAULT_OPTS` environment variable with the colors to be used.

The current theme is defined in the `$ZSH_CONFIG_HOME/fzf_colors.zsh` file which is sourced in `.zshrc`.

A `fzf_themes` directory has been added to the `$ZSH_CONFIG_HOME` directory (where `.zshrc` lives) which will store the theme collection.

`apply_fzf_theme.sh "theme_name"`
  - overwrite `$ZSH_CONFIG_HOME/fzf_colors.zsh` with new theme file from `$ZSH_CONFIG_HOME/fzf_themes/`. 

### GTK

GTK themes are in `~/.local/share/themes`

GTK icons are in `~/.local/share/icons`

`~/.config/gtk-3.0/settings.ini` has theme/icon settings.

The name used by GTK for the theme/icons comes from it's `index.theme` file.  This needs to be edited to match our naming convention when adding a new theme or icon set. The directories for the theme and icon set should match the name (`theme_name`).

The theme name and the icon name should be identical.

`apply_gtk_theme.sh "theme_name"`
  - modify the gtk3 settings file to use the new theme
  - apply changes live via gsettings

###### Custom GTK Themes

Custom GTK themes can be created with `themix`/`oomox theme designer` (available in the AUR).

Copy a preset and edit the colors. Export the theme and implement it the same way you would with any other.

> [!NOTE]
> Don't select "create a dark variant" unless you're theming it for light by default 
> because the background/foreground colors will be flipped if you always prefer dark in gtk settings.

> [!NOTE]
> Pavucontrol (and maybe Firefox?) use GTK4 themes which aren't created by themix.
> The Eldritch theme has a template for a very basic GTK4 theme.  Just copy and edit that.

---

### Firefox

Some of the firefox styling comes from the GTK theme and some is from `~/.mozilla/firefox/PROFILE_DIR/chrome/userChrome.css`

In `userChrome.css`:
  - `accent-color`: active/hovered tab background
  - `tab-text-color`: active tab foreground
  - `light-color`: bookmarks bar foreground
  - `dark-color`: top bar background

Themes are stored in `~/dotfiles/_unstowed/.mozilla/firefox/profile.default-release/chrome/themes`.

Theme files are not stowed so they only exist in the dotfiles directory.

apply_firefox_theme.sh "theme_name"
  - replace the color values in `userChrome.css` with the new theme colors

