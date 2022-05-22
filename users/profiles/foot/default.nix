{
  config,
  lib,
  options,
  pkgs,
  inputs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  inherit (inputs) base16-kitty nix-colors;

in {
   programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Iosevka Nerd Font Mono:style=Medium:size=13";
        font-bold = "Iosevka Nerd Font Mono:style=Bold:size=13";
        font-italic = "Iosevka Nerd Font Mono:style=Italic:size=13";
        font-bold-italic = "Iosevka Nerd Font Mono:style=Bold Italic:size=13";
        dpi-aware = "yes";
        locked-title = "no";
        pad = "20x20";
      };

      scrollback.lines = 10000;

      url = {
        launch = "xdg-open \${url}";
      };

      cursor = {
        style = "block";
        color = "${config.colorscheme.colors.base00} ${config.colorscheme.colors.base05}";
        blink = "no";
      };

      mouse = {
        hide-when-typing = "no";
      };

      colors = {
        alpha = 1.0;
        background = "${config.colorscheme.colors.base00}";
        foreground = "${config.colorscheme.colors.base05}";

        regular0 = "${config.colorscheme.colors.base00}"; # black/bg
        regular1 = "${config.colorscheme.colors.base08}"; # red
        regular2 = "${config.colorscheme.colors.base0B}"; # green
        regular3 = "${config.colorscheme.colors.base0A}"; # yellow
        regular4 = "${config.colorscheme.colors.base0D}"; # blue
        regular5 = "${config.colorscheme.colors.base0E}"; # magenta
        regular6 = "${config.colorscheme.colors.base0C}"; # cyan
        regular7 = "${config.colorscheme.colors.base05}"; # white/fg

        bright0 = "${config.colorscheme.colors.base03}"; # bright black
        bright1 = "${config.colorscheme.colors.base09}"; # bright red
        bright2 = "${config.colorscheme.colors.base01}"; # bright green/lbg
        bright3 = "${config.colorscheme.colors.base02}"; # bright yellow
        bright4 = "${config.colorscheme.colors.base04}"; # bright blue
        bright5 = "${config.colorscheme.colors.base06}"; # bright magenta
        bright6 = "${config.colorscheme.colors.base0F}"; # bright cyan
        bright7 = "${config.colorscheme.colors.base07}"; # bright white

        selection-foreground = "${config.colorscheme.colors.base00}";
        selection-background = "${config.colorscheme.colors.base05}";
        urls = "${config.colorscheme.colors.base0D}";
        scrollback-indicator = "${config.colorscheme.colors.base00} ${config.colorscheme.colors.base0D}";
        };

        csd = {
          preferred = "server";
        };
      };
    };

}
