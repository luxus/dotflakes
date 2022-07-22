{
  config,
  lib,
  pkgs,
  ...
}: (lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
  programs.obs-studio.enable = true;
  # programs.streamdeck-ui.enable = true;
})
