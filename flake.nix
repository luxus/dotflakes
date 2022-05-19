{
  description = "dotflakes";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = "
    https://luxus.cachix.org
    https://cachix.org/api/v1/cache/nix-community
  ";
  nixConfig.extra-trusted-public-keys = "
    luxus.cachix.org-1:eW/nJy5bZow2D3wf59qy7a9mfiZNjshIK/BozwgIlLU=
    nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
  ";

  inputs = {
    # Channels
    nixos-stable.url = "github:NixOS/nixpkgs/release-21.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-trunk.url = "github:NixOS/nixpkgs/master";
    nixpkgs-darwin-stable.url = "github:NixOS/nixpkgs/nixpkgs-21.11-darwin";

    # Flake utilities.
    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixpkgs";
    digga.inputs.darwin.follows = "darwin";
    digga.inputs.home-manager.follows = "home-manager";
    nixlib.url = "github:nix-community/nixpkgs.lib";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # System management.
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin-stable";
    prefmanager.url = "github:malob/prefmanager";
    prefmanager.inputs.nixpkgs.follows = "nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixlib.follows = "nixlib";
    nixos-generators.inputs.nixpkgs.follows = "nixos-unstable";

    # Deployments.
    deploy.url = "github:serokell/deploy-rs";
    deploy.inputs.nixpkgs.follows = "nixpkgs";

    # Sources management.
    nur.url = "github:nix-community/NUR";
    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "nixpkgs";
    gitignore.url = "github:hercules-ci/gitignore.nix";
    gitignore.inputs.nixpkgs.follows = "nixpkgs";

    # Secrets management.
    agenix.url = "github:montchr/agenix/darwin-support";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # Development tools.
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
    # emacs-overlay.url = "github:nix-community/emacs-overlay";
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    phps.url = "github:fossar/nix-phps";
    phps.inputs.utils.follows = "digga/flake-utils-plus/flake-utils";
    phps.inputs.nixpkgs.follows = "nixos-unstable";

    # User environments.
    # TODO:use montchr home-manager
    home-manager.url = "github:montchr/home-manager/trunk";
    home-manager.inputs.nixpkgs.follows = "nixos-unstable";

    # Other sources.
    nix-colors.url = "github:Misterio77/nix-colors";
    base16-kitty = {
      url = "github:kdrag0n/base16-kitty";
      flake = false;
    };
    nixpkgs.follows = "nixos-unstable";
  };

  outputs = {
    self,
    agenix,
    darwin,
    deploy,
    digga,
    # emacs-overlay,
    neovim-nightly-overlay,
    gitignore,
    home-manager,
    nixlib,
    nix-colors,
    nixos-generators,
    nixos-hardware,
    nixos-stable,
    nixpkgs,
    nixos-unstable,
    nur,
    nvfetcher,
    phps,
    ...
  } @ inputs:
    digga.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;

      channels = {
        nixos-stable = {
          imports = [
            (digga.lib.importOverlays ./overlays/common)
            (digga.lib.importOverlays ./overlays/nixos-stable)
          ];
        };
        nixpkgs-darwin-stable = {
          imports = [
            (digga.lib.importOverlays ./overlays/common)
            (digga.lib.importOverlays ./overlays/nixpkgs-darwin-stable)
          ];
          overlays = [
            ./pkgs/darwin
          ];
        };
        nixos-unstable = {};
        nixpkgs-trunk = {};
      };

      lib = import ./lib {lib = digga.lib // nixos-unstable.lib;};

      sharedOverlays = [
        (final: prev: {
          __dontExport = true;
          inherit inputs;
          lib = prev.lib.extend (lfinal: lprev: {
            our = self.lib;
          });
        })

        (final: prev: {
          inherit (inputs.phps.packages.${final.system}) php81;
          php = final.php81;
        })

        agenix.overlay
        # emacs-overlay.overlay
        neovim-nightly-overlay.overlay
        gitignore.overlay
        nur.overlay
        nvfetcher.overlay

        (import ./pkgs)
      ];

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos-unstable";
          imports = [(digga.lib.importExportableModules ./modules)];
          modules = [
            {lib.our = self.lib;}
            ({suites, ...}: {imports = suites.basic;})
            digga.nixosModules.bootstrapIso
            digga.nixosModules.nixConfig
            home-manager.nixosModules.home-manager
            agenix.nixosModules.age
          ];
        };

        imports = [(digga.lib.importHosts ./hosts/nixos)];
        hosts = {
          vanessa = {};
          ci-ubuntu = {};
        };

        importables = rec {
          profiles =
            digga.lib.rakeLeaves ./profiles
            // {users = digga.lib.rakeLeaves ./users;};

          suites = with profiles; {
            basic = [
              boot
              core.common
              core.nixos
              networking.common
            ];
            minimal =
              suites.basic
              ++ [
                users.nixos
                users.root
              ];
            graphical =
              suites.basic
              ++ [
                desktops.common
                desktops.gnome
                fonts.common
                desktops.sound
              ];
            personal = [
              secrets
            ];
          };
        };
      };

      darwin = {
        hostDefaults = {
          system = "aarch64-darwin";
          channelName = "nixpkgs-darwin-stable";
          imports = [(digga.lib.importExportableModules ./modules)];
          modules = [
            {lib.our = self.lib;}
            ({suites, ...}: {imports = suites.basic;})
            home-manager.darwinModules.home-manager
            # `nixosModules` is correct, even for darwin
            agenix.nixosModules.age
            nix-colors.homeManagerModule
          ];
        };

        imports = [(digga.lib.importHosts ./hosts/darwin)];
        hosts = {
          emily = {};
          macOS = {};
          ci-darwin = {};
        };

        importables = rec {
          profiles =
            digga.lib.rakeLeaves ./profiles
            // {users = digga.lib.rakeLeaves ./users;};

          suites = with profiles;  {
            basic = [
              core.common
              core.darwin
              networking.common
            ];
            graphical =
              suites.basic
              ++ [
                fonts.common
                darwin.gui
                darwin.system-defaults
              ];
            typical =
              suites.graphical
              ++ [
                secrets
              ];
          };
        };
      };

      home = {
        imports = [(digga.lib.importExportableModules ./users/modules)];
        modules = [
          nix-colors.homeManagerModule
          ({suites, ...}: {imports = suites.basic;})
        ];
        importables = rec {
          profiles = digga.lib.rakeLeaves ./users/profiles;
          suites = with profiles; rec {
            basic = [
              core
              direnv
              git
              misc
              navi
              # ranger
              shells.fish
              # shells.zsh
              ssh
              tealdeer
            ];
            dev = [
              # emacs
              languages.nodejs
              # languages.python
              vim
            ];
            graphical = [
              colors
              espanso
              keyboard
              kitty
              foot
            ];
            personal = [
              gnupg
              secrets
            ];
          };
        };

        users = {
          nixos = {suites, ...}: {
            imports = with suites; basic;
          };
          luxus = {suites, ...}: {
            imports = with suites;
              basic ++ dev ++ personal ++ graphical;
          };
        };
      };

      devshell = ./shell;

      homeConfigurations =
        digga.lib.mkHomeConfigurations
        (digga.lib.collectHosts self.nixosConfigurations self.darwinConfigurations);

      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations {};
    };
}
