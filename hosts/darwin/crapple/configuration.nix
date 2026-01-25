{ pkgs, inputs, ... }:

{

  imports = [
    ../features/nix-homebrew.nix
    ./homebrew.nix
  ];

  system.primaryUser = "brad";

  environment.systemPackages = with pkgs; [
    neovim
    utm
    tldr
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
    stow
    oh-my-posh
    aldente
    aerospace
#firefox-unwrapped
    # kanata # Broken on Darwin
    kubectl
    kubernetes-helm
    helmfile
    k9s
  ];

  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 0; Minute = 0; };
    options = "--delete-older-than 15d";
  };

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

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

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
}
