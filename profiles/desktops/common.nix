{
  config,
  lib,
  pkgs,
  ...
}: {
environment.systemPackages = with pkgs; [
  brave
  obsidian
  gitkraken
  _1password-gui
  fractal
];
}
