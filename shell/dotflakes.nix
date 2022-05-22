{
  pkgs,
  extraModulesPath,
  inputs,
  lib,
  ...
}: let
  inherit
    (pkgs)
    agenix
    alejandra
    cachix
    editorconfig-checker
    nixUnstable
    # nvfetcher-bin
    shellcheck
    shfmt
    # terraform
    treefmt
    ;

  inherit (pkgs.nodePackages) prettier;

  hooks = import ./hooks;

  withCategory = category: attrset: attrset // {inherit category;};
  pkgWithCategory = category: package: {inherit package category;};

  dotflakes = pkgWithCategory "dotflakes";
  linter = pkgWithCategory "linters";
  formatter = pkgWithCategory "formatters";
  utils = withCategory "utils";
in {
  _file = toString ./.;

  commands =
    [
      (dotflakes nixUnstable)
      (dotflakes agenix)
      # (dotflakes inputs.deploy.packages.${pkgs.system}.deploy-rs)
      # (dotflakes terraform)
      (dotflakes treefmt)

      {
        category = "dotflakes";
        # name = nvfetcher-bin.pname;
        # help = nvfetcher-bin.meta.description;
        # command = "cd $PRJ_ROOT/pkgs; ${nvfetcher-bin}/bin/nvfetcher -c ./sources.toml $@";
      }

      (utils {
        name = "evalnix";
        help = "Check Nix parsing";
        command = "fd --extension nix --exec nix-instantiate --parse --quiet {} >/dev/null";
      })

      (formatter alejandra)
      (formatter prettier)
      (formatter shfmt)

      (linter editorconfig-checker)
      (linter shellcheck)
    ]
    ++ lib.optional (!pkgs.stdenv.buildPlatform.isi686)
    (dotflakes cachix)
    ++ lib.optional (pkgs.stdenv.hostPlatform.isLinux && !pkgs.stdenv.buildPlatform.isDarwin)
    (dotflakes inputs.nixos-generators.defaultPackage.${pkgs.system});
}
