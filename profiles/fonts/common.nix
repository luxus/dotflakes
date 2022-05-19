{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isLinux isMacOS;
in {
  environment.systemPackages = with pkgs; [
    (lib.mkIf isLinux font-manager)
  ];

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs;
      [
       (nerdfonts.override { fonts = [ "Inconsolata" "IBMPlexMono" "CascadiaCode" "SourceCodePro" "FiraCode" "Hack" "Iosevka"]; })
      ]
      ++ (lib.optionals isLinux [
      ])
      ++ (lib.optionals isMacOS [
        sf-pro
      ]);
  };
}
