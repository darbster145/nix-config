{ config, pkgs, ... }:

{
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    neovim
    tldr
    tmux
    fastfetch
    ranger
    thefuck
    unzip
    zoxide
    fzf
    speedtest-cli
    stow
    fira-code
    htop
    btop
    oh-my-posh
    spacebar
    powershell
    cargo
    kitty
    #_1password-gui-beta
    _1password
    #biitwarden-cli
    mkalias
    raycast
    slack
    nmap
    swift-quit
    utm
    zoom-us
    #wireguard-tools
    #wireguard-go
    youtube-music
    shortcat
    bartender
    aerospace
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "brad";
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    caskArgs.no_quarantine = true;

    taps = [
      #"koekeishiya/formulae"
    ];

    brews = [
      #"yabai"
      #"skhd"
      "mas"
    ];

    casks = [
      #"bitwarden"
      "1password"
      "chromium"
      "crystalfetch"
      "disk-inventory-x"
      "displaylink"
      "firefox@developer-edition"
      "istat-menus"
      "jiggler"
      "mac-mouse-fix"
      "microsoft-office"
      "microsoft-remote-desktop"
      "splashtop-business"
      "topnotch"
      "tunnelblick"
      "zenmap"
      "zen-browser"
    ];

    masApps = {
      # "vscode" = 6444809156;
    };
  };

  fonts.packages = with pkgs; [
    fira-code
    nerdfonts
  ];

  # Enable Tailscale
  services.tailscale.enable = true;

  #services.aerospace.enable = true;
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;
  system.configurationRevision = null;
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.enableSudoTouchIdAuth = true;
  system.activationScripts.postUserActivation.text = ''/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u '';

  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
    in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  system.startup.chime = false;

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.24;
      mru-spaces = false;
      magnification = false;
      mineffect = "scale";
      minimize-to-application = true;
      persistent-others = [
        "~/Applications"
      ];
    };

    LaunchServices.LSQuarantine = false;

    menuExtraClock = {
      Show24Hour = true;
      ShowSeconds = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "Nlsv";
      FXDefaultSearchScope = "SCcf";
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
    };

    loginwindow.LoginwindowText = "sugundezz";

    screencapture.location = "~/Pictures/screenshots";

    screensaver.askForPasswordDelay = 10;

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    spaces.spans-displays = false;

    trackpad = {
      ActuationStrength = 1;
      Clicking = true;
      Dragging = false;
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      "com.apple.sound.beep.volume" = 1.0;
      NSScrollAnimationEnabled = true;
      "com.apple.swipescrolldirection" = true;
      AppleShowAllExtensions = true;
      NSWindowShouldDragOnGesture = true;
      NSUseAnimatedFocusRing = true;
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = false;
  };
}

