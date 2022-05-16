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
  imports = with suites;
    graphical
    ++ personal
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

  home-manager.users.luxus = {
    profiles,
    suites,
    ...
  }: {
    imports =
      [hmUsers.luxus]
      ++ (with suites; graphical)
      ++ (with profiles; []);
  };

  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.device = "/dev/sda";
  # boot.initrd.checkJournalingFS = false;

  # networking.useDHCP = false;
  # networking.interfaces.enp0s5.useDHCP = true;
  # networking.firewall.enable = false;

  security.sudo.wheelNeedsPassword = false;

  environment.variables.DOTFIELD_DIR = "/persist/dotflakes";

  users.mutableUsers = false;

  system.stateVersion = "21.11";
}
