{ config, pkgs, inputs, ... }:

{

  imports = [
    ../features/nix-homebrew.nix
    ./homebrew.nix
    ../features/app-alias.nix
    ./systemPackages.nix
    ../features/tmux.nix
    ../../nixos/features/fonts.nix
  ];

  fonts.packages = with pkgs; [
    fira-code
  ];

  environment.systemPackages = with pkgs; [
    tmux
  ];

  ids.gids.nixbld = 350;

  # Needed for Determinate Nix
  nix.enable = false;

  nix.package = pkgs.nix;

  #nix.optimise.automatic = true;

  system.primaryUser = "bradlee";

  # nix.gc = {
  #   automatic = true;
  #   interval = { Weekday = 0; Hour = 0; Minute = 0; };
  #   options = "--delete-older-than 15d";
  # };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = "nix-command flakes";

  environment.variables.EDITOR = "nvim";

  programs.zsh.enable = true;

  system.configurationRevision = null;
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true; # Needed for tmux
    watchIdAuth = true;
  };


  #system.activationScripts.postUserActivation.text = ''/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u '';

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
      InitialKeyRepeat = 25;
      KeyRepeat = 1;
      NSAutomaticCapitalizationEnabled = true;
      NSDisableAutomaticTermination = true;
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
}

