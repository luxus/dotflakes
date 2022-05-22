{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # FIXME
    # ./security/pam.nix
  ];

  # https://github.com/LnL7/nix-darwin/pull/228
  # TODO: errors on activation!
  # security.pam.enableSudoTouchIdAuth = true;

  # TODO: why disabled? caused an error?
  # system.defaults.".GlobalPreferences".com.apple.sound.beep.sound = "Funk";

  # system.defaults.universalaccess = {
  #   reduceTransparency = true;
  #   closeViewScrollWheelToggle = true;
  #   closeViewZoomFollowsFocus = true;
  # };

}
