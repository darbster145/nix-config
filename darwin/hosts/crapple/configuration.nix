{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    tldr
    zoxide
    fastfetch
    #google-chrome
    raycast
    htop
    btop
    ripgrep
    fd
    fzf
    ranger
    bartender
    thefuck
    stow
    oh-my-posh
    fira-code
    nerdfonts
  ];

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };

    brews = [];

    casks = [
      "firefox"
      "bitwarden"
      "thunderbird"
      "signal"
      "orangedrangon-android-messages"
      "AeroSpace"
      "aldente"
      "jellyfin-media-player"
      "istat-menus"
      "swift-quit"
      "topnotch"
      "protonvpn"
      "betterdisplay"
      "kitty"
      "microsoft-office"
    ];

    caskArgs.no_quarantine = true;
  };

  # Set friendly computername
  networking.computerName = "crapple";

  # Set hostname
  networking.hostName = "crapple";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Allow unfree and broken packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  # Enable experimental features for flakes
  nix.settings.experimental-features = "nix-command flakes";

  # zsh shell settings
  programs.zsh.enable = true;

  # Git commit hash for darwin-version
  system.configurationRevision = null;

  # State version and host platform
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Disable startup chime
  system.startup.chime = false;

  # Shell aliases
  environment.shellAliases = {
    ll = "ls -al";
  };

  # System defaults like dock, clock, finder, etc.
  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      mru-spaces = false;
      magnification = false;
      mineffect = "scale";
      minimize-to-application = true;
      persistent-others = [ "/Applications" ];
      static-only = true;
      show-recents = false;
    };

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
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "brad";

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
      "nikitabobko/homebrew-tap" = inputs.AeroSpace;
    };

    mutableTaps = false;
  };
}

