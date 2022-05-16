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
    suites.typical
    ++ [
      profiles.users.montchr
      profiles.virtualisation.virtualbox
    ];

  home-manager.users.montchr = hmArgs: {
    imports =
      [hmUsers.xtallos]
      ++ hmArgs.suites.graphical
      ++ (with hmArgs.profiles; [
        aws
        languages.php
        languages.ruby
        mail
        virtualisation.vagrant
      ]);

    accounts.email.accounts.work.primary = true;
    accounts.email.accounts.personal.primary = false;

    home.packages = with pkgs; [ngrok];

    programs.firefox.profiles = {
      home.isDefault = false;
      work.isDefault = true;
    };

    programs.git.includes = [
      {
        condition = "gitdir:~/broadway/**";
        contents = {
          user.email = hmArgs.config.accounts.email.accounts.work.userName;
        };
      }
    ];
  };

  networking.hostName = "alleymon";

  # MacBookPro16,2
  nixpkgs.system = "x86_64-darwin";
  # 2.3 GHz Quad-Core Intel Core i7
  nix.maxJobs = 4;
  nix.buildCores = 0;
  # $ networksetup -listallnetworkservices
  networking.knownNetworkServices = [
    "Bluetooth PAN"
    "Thunderbolt Bridge"
    "USB 10/100/1000 LAN"
    "Wi-Fi"
  ];

  environment.variables = {
    PATH = ["$HOME/broadway/bin" "$PATH"];
  };

  homebrew = {
    casks = ["figma" "microsoft-teams" "sketch"];
    masApps = {
      "Harvest" = 506189836;
      "Jira" = 1475897096;
      "xScope" = 889428659;
      "Xcode" = 497799835;
    };
  };
}
