{
  config,
  lib,
  pkgs,
  suites,
  profiles,
  hmUsers,
  ...
}: let
  secretsDir = ../../../secrets;
in {
  imports =
    suites.graphical
    ++ suites.personal
    ++ (with profiles; [
      audio
      users.luxus
     # virtualisation.guests.parallels
    ])
    ++ [./hardware-configuration.nix];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.useOSProber = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 15;
    };
    timeout = lib.mkDefault 2;
  };
  console.earlySetup = true;
  users.users.luxus = {
    openssh.authorizedKeys.keys = import "${secretsDir}/authorized-keys.nix";
  };

  home-manager.users.luxus = hmArgs@{
    ...
  }: {
    imports =
      [hmUsers.luxus]
      ++ hmArgs.suites.graphical
      ++ (with hmArgs.profiles; []);
  };
  security.sudo.wheelNeedsPassword = false;

  environment.variables.DOTFIELD_DIR = "/persist/dotflakes";

  users.mutableUsers = false;

  system.stateVersion = "21.11";
}
