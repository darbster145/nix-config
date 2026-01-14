{ config, ... }:

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
      #"kanata"
    ];

    casks = [
      "crystalfetch"
      "istat-menus"
      "jiggler"
      "mac-mouse-fix"
      "microsoft-office"
      "microsoft-auto-update"
      "windows-app"
      "splashtop-business"
      "topnotch"
      "tunnelblick"
      "via"
      "obsidian"
      "obs"
      "karabiner-elements"
      "bartender"
      "displaylink"
      "firefox@nightly"
      "tailscale-app"
    ];

    masApps = {
      # "vscode" = 6444809156;
    };
  };
}
