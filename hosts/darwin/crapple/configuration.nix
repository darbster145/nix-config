{ pkgs, inputs, ... }:

{

  imports = [
    ../features/nix-homebrew.nix
    ./homebrew.nix
    ./systemPackages.nix
  ];

  system.primaryUser = "brad";

  environment.systemPackages = with pkgs; [
    neovim
    utm
    tldr
    google-chrome
    zoxide
    fastfetch
    lazygit
    raycast
    htop
    btop
    ripgrep
    fd
    fzf
    ranger
    bartender
    stow
    oh-my-posh
    aldente
    aerospace
    inputs.zen-browser.packages."${system}".default
    thunderbird-latest-unwrapped
    firefox-unwrapped
    kubectl
    kubernetes-helm
    helmfile
    k9s
  ];

  # Set friendly computername
  networking.computerName = "crapple";

  # Set hostname
  networking.hostName = "crapple";

  # Auto upgrade nix package and the daemon service.
  nix.package = pkgs.nix;

  # Allow unfree and broken packages
  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.allowBroken = true;

  # Enable experimental features for flakes
  nix.settings.experimental-features = "nix-command flakes";

  # zsh shell settings
  programs.zsh.enable = true;

  # Git commit hash for darwin-version
  system.configurationRevision = null;

  # State version and host platform
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Disable startup chime
  system.startup.chime = false;

  # System defaults like dock, clock, finder, etc.
  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.24;
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
      InitialKeyRepeat = 25;
      KeyRepeat = 1;
      NSAutomaticCapitalizationEnabled = true;
      NSDisableAutomaticTermination = true;
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

    LaunchServices.LSQuarantine = false;

  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };


  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 0; Minute = 0; };
    options = "--delete-older-than 15d";
  };

  environment.variables.EDITOR = "nvim";

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true; # Needed for tmux
    watchIdAuth = true;
  };

}
