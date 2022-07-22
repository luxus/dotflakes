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

  home.packages = with pkgs; [
    neovim-nightly
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    withPython3 = true;
    withRuby = false;
    withNodeJs = true;

    extraPackages = with pkgs; [
    #   # Language servers
      pyright
      ccls
      gopls
    #   ltex-ls
       nodePackages.bash-language-server
      sumneko-lua-language-server
    #   rnix-lsp
      tree-sitter
      alejandra

    #   # null-ls sources
       asmfmt
       # failed on aarch64
      # black
       codespell
       cppcheck
      deadnix
       editorconfig-checker
       gofumpt
      nixpkgs-fmt
      gitlint
       mypy
       nodePackages.alex
      nodePackages.prettier
      nodePackages.markdownlint-cli
      nodejs
      nodePackages.npm
      vale
      proselint
      python3Packages.flake8
      lua53Packages.luacheck
       # failed on aarch64
      #  shellcheck
       shellharden
       shfmt
       statix
       stylua
       vim-vint

    #   # Other stuff
       bc
       cowsay
    ];
  };
}
