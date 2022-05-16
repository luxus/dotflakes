# -*- mode: sh -*-
''

  # Check whether a command exists.
  has() {
    type "$1" >/dev/null 2>&1
  }

  # Get the current OS appearance.
  #
  # Returns either "light" or "dark". Defaults to "dark".
  DOTFLAKES_os_appearance () {
    if [ -n "$SSH_CONNECTION" ] && [ -n "$DOTFLAKES_OS_APPEARANCE" ]; then
      echo "%s" "$DOTFLAKES_OS_APPEARANCE"
    elif [ "$(has "dark-mode" && dark-mode status)" = "off" ]; then
      echo "light"
    else
      echo "dark"
    fi
  }


  # Select a color theme based on dark mode status.
  #
  # Accepts either on/dark or off/light. Defaults to a dark theme.
  DOTFLAKES_base16_theme () {
    case $1 in
      on | dark) echo "$BASE16_THEME_DARK" ;;
      off | light) echo "$BASE16_THEME_LIGHT" ;;
      *) echo "$BASE16_THEME_DARK" ;;
    esac
  }


  # Set the OS appearance by attempting to query the current status.
  [ -z "$DOTFLAKES_OS_APPEARANCE" ] && {
    DOTFLAKES_OS_APPEARANCE="$(DOTFLAKES_os_appearance)"
    export DOTFLAKES_OS_APPEARANCE
  }


  # https://github.com/cantino/mcfly#light-mode
  [ "light" = "$DOTFLAKES_OS_APPEARANCE" ] && {
    MCFLY_LIGHT=true
    export MCFLY_LIGHT
  }

  # Set the base16 theme based on OS appearance.
  BASE16_THEME="$(DOTFLAKES_base16_theme "$DOTFLAKES_OS_APPEARANCE")"
  export BASE16_THEME

''
