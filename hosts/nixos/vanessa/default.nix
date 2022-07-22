{
  config,
  hmUsers,
  lib,
  pkgs,
  profiles,
  suites,
  inputs,
  peers,
  primaryUser,
  ...
}: let
  inherit (config.networking) hostName;

  host = peers.hosts.${hostName};
  net = peers.networks.${host.network};
  interface = "eth0";
in {
  imports =
    (with suites; tangible ++ workstation)
    ++ (with profiles; [
      boot.refind
      hardware.amd
      # FIXME: only apply this to the proper output -- will not currently allow
      # configuring multiple outputs.
      hardware.displays.LG-27GL850-B
      hidpi
      # nvidia
      remote-builder
      workstations.flatpak
      virtualisation.libvirtd
    ])
    ++ [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "auto";
  # FIXME: does this interfere with rEFInd? if not this, then i blame Windows.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 15;
  boot.initrd.supportedFilesystems = ["ext4" "btrfs"];
  boot.supportedFilesystems = ["ext4" "btrfs"];

  system.stateVersion = "22.05";

  ## --- networking ---

  networking.useDHCP = false;
  networking.usePredictableInterfaceNames = false;
  networking.firewall.enable = false;

  networking.defaultGateway = {
    inherit interface;
    inherit (net.ipv4) address;
  };

  networking.interfaces.${interface} = {
    ipv4.addresses = [
      {
        inherit (host.ipv4) address;
        inherit (net.ipv4) prefixLength;
      }
    ];
  };

  ### === users ================================================================

  users.mutableUsers = false;
  users.users.root.hashedPassword = "$6$ED4waehzm6upRTYI$w5I.2WoMrjKqXUfURK92tBDlEkeQHiHWt2J4Kuc6thGazc0Xa6r0uyDN49sC..WA6i6uaVIwCQXDPovlmKtBc0";
  users.users.luxus = {
    uid = 1000;
    isNormalUser = true;
    initialHashedPassword = "$6$Kd74uMMxr6V0pSlC$i7Bx54OrhMq.UUsr8VRk0FyxRl56NSMEqpppmO63acNaYUWqzBWkBWJP9hg4zsK7EcheYyuGosra0XsLhfKqI0";
    hashedPassword = "$6$Kd74uMMxr6V0pSlC$i7Bx54OrhMq.UUsr8VRk0FyxRl56NSMEqpppmO63acNaYUWqzBWkBWJP9hg4zsK7EcheYyuGosra0XsLhfKqI0";
    openssh.authorizedKeys.keys = primaryUser.authorizedKeys;
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
      "luxus"
      "secrets"
      (lib.mkIf config.virtualisation.libvirtd.enable "libvirtd")
    ];
    shell = pkgs.zsh;
  };
  home-manager.users = {
    luxus = hmArgs: {
      imports =
        (with hmArgs.suites; workstation)
        ++ [hmUsers.luxus];
    };
  };

  programs.htop.enable = true;
  programs.steam.enable = true;
}
