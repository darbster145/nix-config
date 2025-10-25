{ config, pkgs, inputs, ... }:

{

  imports = [
    ../features/nix-homebrew.nix
    ./homebrew.nix
    ../features/app-alias.nix
    ./systemPackages.nix
    ../features/tmux.nix
    ../../nixos/features/fonts.nix
    #../features/linux-builder.nix
  ];

  ids.gids.nixbld = 350;

  nix.package = pkgs.nix;

  system.primaryUser = "bradlee";

<<<<<<< Updated upstream
  nix.optimise = {
    automatic = false;
  };
=======
  nix.optimise.automatic = true;
>>>>>>> Stashed changes

  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 0; Minute = 0; };
    options = "--delete-older-than 15d";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

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

    screencapture.location = "/Users/bradlee/Pictures/screenshots";

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

