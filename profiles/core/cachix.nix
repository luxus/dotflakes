{
  config,
  lib,
  pkgs,
  ...
}: {
  nix.settings.substituters = [
    "https://luxus.cachix.org"
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "luxus.cachix.org-1:eW/nJy5bZow2D3wf59qy7a9mfiZNjshIK/BozwgIlLU="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
}
