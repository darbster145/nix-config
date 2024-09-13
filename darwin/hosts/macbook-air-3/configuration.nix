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
  ];

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;            
      upgrade = true;
    };
    caskArgs.no_quarantine = true;

    taps = [ 
      "nikitabobko/homebrew-tap"      
      "koekeishiya/formulae" 
    ];

    brews = [ 
      "yabai" 
      "skhd"
    ];

    casks = [
      "microsoft-edge"
      "1password"
      "1password-cli"
      "bartender"
      "bitwarden"
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
      "notion"
      "raycast"
      "slack"
      "splashtop-business"
      "swift-quit"
      "topnotch"
      "tunnelblick"
      "utm"
      "zoom"
      "zenmap"
      "yt-music"
      "shortcat"
      "aerospace"
      "betterdisplay"
        "kitty"
    ];
 };

  fonts.packages = with pkgs; [
      fira-code
      nerdfonts
 ];

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

