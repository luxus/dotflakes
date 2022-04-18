{
  options,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config) my;
  inherit (pkgs.stdenv) isDarwin isLinux;

  user = builtins.getEnv "USER";
  name =
    if builtins.elem user ["" "root"]
    then my.username
    else user;
in {
  users.users.${my.username} = lib.mkAliasDefinitions options.my.user;

  my.user =
    {
      inherit name;

      shell = pkgs.zsh;
      packages = import ./package-list.nix {inherit pkgs;};
    }
    // (lib.optionalAttrs isLinux {
      # TODO: this SHOULD exist in nix-darwin! why doesn't it?
      extraGroups = ["wheel"];
      isNormalUser = true;
      home = "/home/${name}";
    })
    // (lib.optionalAttrs isDarwin {
      home = "/Users/${name}";
    });

  my.usernames = {
    github = "montchr";
    gitlab = "montchr";
    sourcehut = "montchr";
  };

  my.hm.home.sessionVariables = {
    # Default is "1". But when typeset in PragmataPro that leaves no space
    # between the icon and its filename.
    EXA_ICON_SPACING = "2";

    GITHUB_USER = my.usernames.github;
    Z_OWNER = my.username;
  };

  my.hm.home = {
    # Necessary for home-manager to work with flakes, otherwise it will
    # look for a nixpkgs channel.
    stateVersion = "21.11";
    username = my.username;
  };

  my.hm.programs.home-manager.enable = true;

  my.hm.xdg.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${my.username} = lib.mkAliasDefinitions options.my.hm;
  };
}
