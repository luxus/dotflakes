{
  config,
  lib,
  pkgs,
  ...
}: {
  lib.dotflakes.userPath = "${config.xdg.configHome}/dotflakes";
  lib.dotflakes.whoami = rec {
    firstName = "Kai";
    lastName = "Loehnert";
    fullName = "${firstName} ${lastName}";
    email = "luxuspur@gmail.com";
    githubUserName = "luxus";
    pgpPublicKey = "0x135EEDD0F71934F3";
  };

  home.sessionVariables.DOTFLAKES_DIR = config.lib.dotflakes.userPath;

  home.packages = with pkgs; [
    ## === Sysadmin ===

    du-dust # Like du but more intuitive.
    lnav # Log file navigator
    procs # A modern replacement for ps.

    ## === Utilities ===
    btop
    bat # A cat(1) clone with wings.
    tealdeer # A very fast implementation of tldr in Rust.
    grex # Generate regexps from user-provided test cases.
    httpie # Modern, user-friendly command-line HTTP client for the API era.

    ## === Formatters ===

    treefmt # One CLI to format the code tree
  ];

  programs.bat = {
    enable = true;
    config = {
      theme = "base16-256";
      map-syntax = [
        ".*ignore:Git Ignore"
        ".gitconfig.local:Git Config"
        "**/mx*:Bourne Again Shell (bash)"
        "**/completions/_*:Bourne Again Shell (bash)"
        ".vimrc.local:VimL"
        "vimrc:VimL"
      ];
    };
  };
  programs.bottom.enable = true;
  # programs.nix-index.enable = true;
}
