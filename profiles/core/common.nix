{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (config.lib) dotfield;
in {
  imports = [./cachix.nix];

  lib.dotfield = {
    srcPath = toString ../../.;
    fsPath = "/persist/home/luxus/Source/dotflakes";
  };

  nix = {
    package = pkgs.nix;
    gc.automatic = true;
    settings = {
      sandbox = lib.mkDefault (!pkgs.stdenv.hostPlatform.isDarwin);
      allowed-users = ["*"];
      trusted-users = ["root" "@wheel" "@luxus"];
    };
    linkInputs = true;
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    # }}
  };

  time.timeZone = "Europe/Zurich";

  environment.variables = {
    DOTFIELD_DIR = dotfield.fsPath;
    EDITOR = "vim";
    KERNEL_NAME =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "darwin"
      else "linux";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    ZDOTDIR = "$HOME/.config/zsh";

    # Although it points to a commonly-used path for user-owned executables,
    # $XDG_BIN_HOME is a non-standard environment variable. It is not part of
    # the XDG Base Directory Specification.
    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    XDG_BIN_HOME = "$HOME/.local/bin";
  };

  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  # Enable completions for system packages.
  environment.pathsToLink = ["/share/zsh"];

  home.sessionPath = ["${XDG_BIN_HOME}/emacs/bin" "$PATH"];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  programs.fish.enable = lib.mkDefault false;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  environment.systemPackages = with pkgs; [
    # TODO: add this via gitignore.nix or something to avoid IFD
    (writeScriptBin "dotfield"
      (builtins.readFile "${dotfield.srcPath}/bin/dotfield"))

    ## === Essentials ===

    bashInteractive
    bat
    binutils
    cacert
    coreutils
    curl
    dua
    dnsutils
    exa
    fd
    findutils
    gawk
    git
    gnumake
    gnupg
    gnused
    gnutar
    grc
    helix
    jq
    less
    moreutils
    nmap
    openssh
    openssl
    ripgrep
    rsync
    screen
    tmux
    vim
    wget
    whois

    ## === File Helpers ===
    file
    glow # markdown cli renderer (by charmbracelet)
    mediainfo
    unzip

    ## === Nix Helpers ===

    # FIXME: most of these should be removed for servers / non-dev machines

    alejandra # The Uncompromising Nix Code Formatter
    cachix
    fup-repl
    manix # nix documentation search
    nix-diff # Explain why two Nix derivations differ
    nix-tree # Interactively browse dependency graphs of Nix derivations.
    nvfetcher-bin # Generate nix sources expression for the latest version of packages
  ];
}
