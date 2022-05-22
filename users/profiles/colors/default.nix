{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  # Note that `builtins.getEnv` will only return an empty string unless running
  # an impure build. For that reason, a fallback value is necessary.
  envTheme = builtins.getEnv "DOTFLAKES_THEME";
  theme =
    if envTheme != ""
    then envTheme
    else "dracula";
in {
  colorscheme = inputs.nix-colors.colorSchemes.${theme};

  home.sessionVariables = {
    BASE16_THEME_DARK = "black-metal-khold";
    BASE16_THEME_LIGHT = "grayscale-light";
  };

  home.packages = with pkgs; [
    (writeScriptBin "toggle-dark-mode" (builtins.readFile ./toggle-dark-mode))
  ];
}
