{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux system;

  cfg = config.age;
  secretsDir = ../../secrets;

  # nix-darwin does not support the `users.<name>.extraGroups` option, but
  # that's not a problem since we're only using darwin systems as a single
  # admin user. although the username may vary across systems, each "primary
  # user" will still be in the `admin` group.
  dotflakesGroup =
    if isLinux
    then pkgs.lib.our.dotflakes.group
    else "admin";

  # mkEspansoMatchesSecret = name: {
  #   "espanso/${name}.yml" = {
  #     file = "${secretsDir}/espanso/${name}.yml.age";
  #     group = dotflakesGroup;
  #     path = "${cfg.secretsDir}/espanso/${name}.yml";
  #   };
  # };
in {
  environment.systemPackages = with pkgs; [
    agenix
    rage
  ];

  age.secrets = lib.mkMerge [
    {
      "wireless.env".file = "${secretsDir}/wireless.env.age";
    }
    # (mkEspansoMatchesSecret "personal")
    # (mkEspansoMatchesSecret "work")
  ];
}
