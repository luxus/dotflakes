{
  config,
  lib,
  pkgs,
  ...
}: {
environment.systemPackages = with pkgs; [
  brave
  gitkraken
  _1password-gui
  fractal
];
}
