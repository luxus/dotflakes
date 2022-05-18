{
  config,
  lib,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    LUNARVIM_RUNTIME_DIR = "${config.xdg.dataHome}/lunarvim";
    LUNARVIM_CONFIG_DIR = "${config.xdg.configHome}/lvim";
    LUNARVIM_CACHE_DIR = "${config.xdg.cacheHome}/nvim";
  };

  home.sessionPath = ["$HOME/.local/bin" ];
  home.packages = with pkgs; [
     neovim-nightly
# neovim-unwrapped

    ##: LunarVim dependencies {{
    #: core
    lua53Packages.luacheck
    cargo
    fd
    ripgrep
    gcc
    unzip

    #: nodejs
    nodePackages.neovim
    tree-sitter

#nix
    statix
    deadnix
    alejandra
    #: python
     (python311.withPackages (ps: [ ps.setuptools  ]))
     # black ps.isort
      poetry
      pyright

    #: }}
  ];
}
