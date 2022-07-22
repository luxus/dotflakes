{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  nix = {
    nixPath = ["nixos-config=${../../lib/compat/nixos}"];
    optimise.automatic = true;
    settings = {
      system-features = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      auto-optimise-store = true;
   };
  };

  boot.loader.systemd-boot.consoleMode = "auto";
  boot.cleanTmpDir = lib.mkDefault true;

  environment.shellAliases = {
    # Fix `nixos-option` for flake compatibility
    nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";
  };

  environment.systemPackages = with pkgs; [
    dosfstools
    efibootmgr
    gptfdisk
    inetutils
    iputils
    mtr
    pciutils
    sysstat
    usbutils
    utillinux
  ];

  programs.git.enable = true;
  programs.git.config = {
    safe.directory = [
      "/etc/nixos"
      "/etc/dotfield"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    # For rage encryption, all hosts need a ssh key pair
    enable = lib.mkForce true;

    openFirewall = true;
    passwordAuthentication = false;
    permitRootLogin = "prohibit-password";
  };

  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
