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
      "tsui"
    ];

    casks = [
      "ghostty"
      "obs"
      "parallels"
      "bitwarden"
      "mac-mouse-fix"
      "barrier"
      "microsoft-remote-desktop"
      "orangedrangon-android-messages"
      "istat-menus"
      "jellyfin-media-player"
      "swift-quit"
      "topnotch"
      "protonvpn"
      "crystalfetch"
      "microsoft-teams"
    ];


    masApps = {
      # "vscode" = 6444809156;
    };
  };
}
