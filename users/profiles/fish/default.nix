{ config, lib, pkgs, ... }:

let
  inherit (lib.strings) fileContents;

  configDir = "${config.dotfield.configDir}/fish";

  mkFileLink = path: onChange: {
    "fish/${path}" = {
      inherit onChange;
      source = "${configDir}/${path}";
    };
  };
  mkFileLink' = path: mkFileLink "${path}.fish";
in
{
  environment.variables = {
    SHELL = "fish";
  };

  my.user.shell = pkgs.fish;

  my.hm.programs = {
    fish = {
      enable = true;
      interactiveShellInit = fileContents ./interactiveShellInit.fish;
      shellInit = fileContents ./shellInit.fish;
      shellAbbrs = import ./abbrs.nix { inherit config lib pkgs; };
      shellAliases = import ./aliases.nix { inherit config lib pkgs; };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  my.hm.xdg.configFile = lib.mkMerge [
    ({ "starship".source = "${config.dotfield.configDir}/starship"; })
  ];

}
