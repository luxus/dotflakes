{
  config,
  pkgs,
  lib,
  suites,
  profiles,
  hmUsers,
  ...
}: {
  imports =
    (with suites; typical)
    ++ (with profiles; [
      users.luxus
      # virtualisation.virtualbox
    ]);

  home-manager.users.luxus = {
    config,
    suites,
    profiles,
    ...
  }: {
    imports =
      [hmUsers.luxus]
      ++ (with suites; graphical)
      ++ (with profiles; [
        # languages.php
        # languages.ruby
        ##TODO:editing email stuff to make it work
        # mail
        # virtualisation.vagrant
      ]);

    # accounts.email.accounts.work.primary = true;
    # accounts.email.accounts.personal.primary = false;

    home.packages = with pkgs; [ngrok];

  #   programs.git.includes = [
  #     {
  #       condition = "gitdir:~/broadway/**";
  #       contents = {
  #         user.email = config.accounts.email.accounts.work.userName;
  #       };
  #     }
  #   ];
  };

  networking.hostName = "emily";

  # M1-pro 14 2021
  nixpkgs.system = "aarch64-darwin";
  nix.maxJobs = 8;
  nix.buildCores = 0;
  # $ networksetup -listallnetworkservices
  networking.knownNetworkServices = [
    "Wi-Fi"
  ];

  environment.variables = {
    PATH = ["$HOME/.local/bin" "$PATH"];
  };

  homebrew = {
    casks = ["microsoft-teams" "sketch"];
    masApps = {
      # "Xcode" = 497799835;
    };
  };
}
