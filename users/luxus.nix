{
  config,
  pkgs,
  lib,
  suites,
  profiles,
  hmUsers,
  ...
}: {
  users.users.luxus = {
    isHidden = false;
    shell = pkgs.zsh;
  };

  home-manager.users.luxus = hmArgs: {
    imports = [hmUsers.luxus];

    home.packages = with pkgs; [
      # TODO: move this to a common profile when pandas dep is fixed upstream
      # visidata # A terminal spreadsheet multitool for discovering and arranging data
    ];

    programs.firefox.profiles = {
      home.isDefault = false;
      work.isDefault = true;
    };

    # programs.git.includes = [
    #   {
    #     condition = "gitdir:~/workspaces/kleinweb**";
    #     contents = {
    #       # TODO: configure mail
    #       user.email = "chrismont@temple.edu";
    #     };
    #   }
    # ];
  };
}
