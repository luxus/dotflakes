{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver.enable = true;

  # Enable the kde Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.displayManager.kdm.wayland = true;
  services.xserver.desktopManager.plasma5.enable = true;
  programs.gnupg.agent.pinentryFlavor = "qt";

  environment.systemPackages = with pkgs; [
    libsForQt514.bismuth
  ];
}
