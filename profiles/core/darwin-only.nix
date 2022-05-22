{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (pkgs.lib.our) dotflakesPath;
in {
  nix.nixPath = [
    # TODO: This entry should be added automatically via FUP's `nix.linkInputs`
    # and `nix.generateNixPathFromInputs` options, but currently that doesn't
    # work because nix-darwin doesn't export packages, which FUP expects.
    #
    # This entry should be removed once the upstream issues are fixed.
    #
    # https://github.com/LnL7/nix-darwin/issues/277
    # https://github.com/gytis-ivaskevicius/flake-utils-plus/issues/107
    "darwin=/etc/nix/inputs/darwin"
  ];

  environment.darwinConfig = "${dotflakesPath}/lib/compat/darwin";

  # Administrative users on Darwin systems are part of the admin group by default.
  nix.trustedUsers = ["@admin" "@wheel"];

  environment.systemPackages = with pkgs; [
    #  Swiss Army Knife for macOS
    # => https://github.com/rgcr/m-cli
    m-cli
    mas
    terminal-notifier

    # A tool for managing macOS defaults.
    # https://github.com/malob/prefmanager
    # FIXME: `prefmanager` build fails with sandbox mode enabled
    # https://github.com/malob/prefmanager/issues/2
    # prefmanager
  ];

  # Recreate /run/current-system symlink after boot
  services.activate-system.enable = true;
  services.nix-daemon.enable = true;
  users.nix.configureBuildUsers = true;

  homebrew = {
    enable = true;
    # enable = false;
    autoUpdate = true;
    global.noLock = true;
  };

  system.defaults.smb = {
    NetBIOSName = config.networking.hostName;
    ServerDescription = config.networking.hostName;
  };

  system.defaults.NSGlobalDomain = {
    # Whether light/dark modes are toggled automatically.
    AppleInterfaceStyleSwitchesAutomatically = false;
    AppleFontSmoothing = 0;
    AppleKeyboardUIMode = 3;
    AppleMeasurementUnits = "Inches";
    AppleMetricUnits = 0;
    ApplePressAndHoldEnabled = false;
    AppleShowAllExtensions = true;
    AppleShowScrollBars = "Automatic";
    AppleTemperatureUnit = "Celsius";
    InitialKeyRepeat = 10;
    KeyRepeat = 2;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
    # Disable automatic termination of "inactive" apps.
    NSDisableAutomaticTermination = true;
    NSDocumentSaveNewDocumentsToCloud = false;
    NSNavPanelExpandedStateForSaveMode = true;
    NSNavPanelExpandedStateForSaveMode2 = true;
    NSScrollAnimationEnabled = true;
    NSTableViewDefaultSizeMode = 1;
    NSTextShowsControlCharacters = true;
    # Disable the over-the-top focus ring animation
    # NSUseAnimatedFocusRing = false;
    NSWindowResizeTime = "0.001";
    PMPrintingExpandedStateForPrint = true;
    PMPrintingExpandedStateForPrint2 = true;
    # Whether to hide the menu bar.
    _HIHideMenuBar = lib.mkDefault false;
    # Use F1, F2, etc. keys as standard function keys.
    "com.apple.keyboard.fnState" = false;
    # Configures the trackpad tap behavior. Mode 1 enables tap to click.
    "com.apple.mouse.tapBehavior" = 1;
    # Apple menu > System Preferences > Sound Make a feedback sound when
    # the system volume changed. This setting accepts the integers 0 or
    # 1. Defaults to 1.
    "com.apple.sound.beep.feedback" = 0;
    # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.NSGlobalDomain.com.apple.sound.beep.volume
    # "com.apple.sound.beep.volume" = null;
    # Set the spring loading delay for directories. The default is the float `1.0`.
    "com.apple.springing.delay" = "0.1";
    # Enable spring loading (expose) for directories.
    "com.apple.springing.enabled" = true;
    # Disable "Natural" scrolling direction.
    "com.apple.swipescrolldirection" = false;
    # Whether to enable trackpad secondary click.
    "com.apple.trackpad.enableSecondaryClick" = true;
    # Configures the trackpad tracking speed (0 to 3). The default is "1".
    "com.apple.trackpad.scaling" = "1.0";
    # Configures the trackpad corner click behavior. Mode 1 enables right click.
    # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.NSGlobalDomain.com.apple.trackpad.trackpadCornerClickBehavior
    "com.apple.trackpad.trackpadCornerClickBehavior" = null;
  };

  # Prevent incessant nagging when opening downloaded apps.
  system.defaults.LaunchServices.LSQuarantine = false;
  # Keep macOS up to date.
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

  # Firewall
  system.defaults.alf = {
    allowdownloadsignedenabled = 0;
    allowsignedenabled = 1;
    globalstate = 0;
    loggingenabled = 0;
    stealthenabled = 0;
  };

  system.defaults.dock = {
    autohide = true;
    autohide-delay = "0";
    autohide-time-modifier = "0";
    dashboard-in-overlay = false;
    enable-spring-load-actions-on-all-items = false;
    expose-animation-duration = "0.1";
    expose-group-by-app = false;
    launchanim = false;
    mineffect = "genie";
    minimize-to-application = true;
    mouse-over-hilite-stack = true;
    mru-spaces = false;
    orientation = "left";
    show-process-indicators = true;
    show-recents = false;
    showhidden = true;
    static-only = true;
    tilesize = 32;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    # Whether to display icons on the desktop.
    CreateDesktop = false;
    FXEnableExtensionChangeWarning = false;
    QuitMenuItem = false;
    _FXShowPosixPathInTitle = false;
  };

  system.defaults.loginwindow = {
    DisableConsoleAccess = false;
    GuestEnabled = false;
    # Text to be shown on the login window. Default "\\U03bb".
    # LoginwindowText = null;
    PowerOffDisabledWhileLoggedIn = false;
    RestartDisabled = false;
    RestartDisabledWhileLoggedIn = false;
    SHOWFULLNAME = false;
    ShutDownDisabled = false;
    ShutDownDisabledWhileLoggedIn = false;
    SleepDisabled = true;
  };

  # The filesystem path to which screencaptures should be written.
  # system.defaults.screencapture.location = null;

  system.defaults.spaces = {
    # spans-displays: true;
  };

  system.defaults.trackpad = {
    # 0 to enable Silent Clicking, 1 to disable. The default is 1.
    ActuationStrength = 1;
    # Whether to enable trackpad tap to click. The default is false.
    Clicking = true;
    # For normal click: 0 for light clicking, 1 for medium, 2 for firm. The default is 1.
    FirstClickThreshold = 1;
    # For force touch: 0 for light clicking, 1 for medium, 2 for firm. The default is 1.
    SecondClickThreshold = 1;
    TrackpadRightClick = true;
    TrackpadThreeFingerDrag = true;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # https://daiderd.com/nix-darwin/manual/index.html#opt-system.stateVersion
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
