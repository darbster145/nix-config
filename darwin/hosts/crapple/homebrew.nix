{ config, ...}:

{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    caskArgs.no_quarantine = true;

    # Declared by nix-homebrew 
    taps = builtins.attrNames config.nix-homebrew.taps;

    brews = [
      "mas"
    ];

    casks = [
      "firefox"
      "mac-mouse-fix"
      "barrier"
      "1password@nightly"
      "microsoft-remote-desktop"
      "kitty"
      "google-chrome"
      "bitwarden"
      "orangedrangon-android-messages"
      "istat-menus"
      "jellyfin-media-player"
      "swift-quit"
      "topnotch"
      "protonvpn"
      "betterdisplay"
      "microsoft-office"
      "thunderbird"
      "signal"
    ];


    masApps = {
      # "vscode" = 6444809156;
    };
  };
}
