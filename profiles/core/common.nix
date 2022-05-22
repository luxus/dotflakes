{ config
, lib
, pkgs
, inputs
, ...
}:
let
  inherit (pkgs.lib.our) dotflakesPath;
in
{
  imports = [ ./cachix.nix ];

  nix = {
    package = pkgs.nix;
    gc.automatic = true;
    useSandbox = lib.mkDefault (!pkgs.stdenv.hostPlatform.isDarwin);
    allowedUsers = [ "*" ];
    trustedUsers = [ "root" "@wheel" ];
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';

    # FUP Options {{
    # https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/166d6ebd9f0de03afc98060ac92cba9c71cfe550/lib/options.nix
    linkInputs = true;
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    # }}
  };

  time.timeZone = "Europe/Zurich";

  environment.variables = {
    DOTFLAKES_DIR = lib.mkDefault "/persist/dotflakes";

    # If `$DOTFLAKES_HOSTNAME` matches `$HOSTNAME`, then we can assume the
    # system has been successfully provisioned with Nix. Otherwise,
    # `$DOTFLAKES_HOSTNAME` should remain an empty string.
    DOTFLAKES_HOSTNAME = config.networking.hostName;

    EDITOR = "lvim";
    HOSTNAME = config.networking.hostName;
    KERNEL_NAME =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "darwin"
      else "linux";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    #    # Although it points to a commonly-used path for user-owned executables,
    # $XDG_BIN_HOME is a non-standard environment variable. It is not part of
    # the XDG Base Directory Specification.
    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    TMPDIR = "/tmp";
    XDG_BIN_HOME = "$HOME/.local/bin";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    # TODO: is this correct for linux?
    # XDG_RUNTIME_DIR = "/tmp";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  # fonts.fonts = [ ];

  environment.shells = with pkgs; [
    bash
    fish
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  environment.systemPackages = with pkgs; [
    # TODO: add this via gitignore.nix or something to avoid IFD
    (writeScriptBin "dotflakes"
      (builtins.readFile "${dotflakesPath}/bin/dotflakes"))

    ## === Essentials ===

    binutils
    cacert
    coreutils
    curl
## compiler-rt-libc is broken in aarch64
    # dnsutils
    broot
    fd
    findutils
    gawk
    git
    gnumake
    gnupg
    gnused
    gnutar
    grc
    jq
    less
    moreutils
    nmap
    openssh
    openssl
    ripgrep
    rsync
    tmux
    wget
    whois
## cool rust tui
    diskonaut
    freshfetch
    tickrs
    bandwhich
    spotify-tui
    gpg-tui
#broken in darwin
    # zenith #glances?

    taskwarrior-tui
    bottom
    # hoard # stash for commands that are very long
    termscp
    gping #ping with graph
    joshuto #ranger clone
    prettyping
    xplr # filemanager

    ## === Nix Helpers ===
     cachix
    fup-repl
    manix # nix documentation search
    nix-diff # Explain why two Nix derivations differ
    nix-tree # Interactively browse dependency graphs of Nix derivations.
    # nvfetcher-bin # Generate nix sources expression for the latest version of packages
  ];
}
