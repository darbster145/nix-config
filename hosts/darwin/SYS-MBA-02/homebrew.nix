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
      "1password@nightly"
      "1password-cli"
      "chromium"
      "crystalfetch"
      "disk-inventory-x"
      "istat-menus"
      "jiggler"
      "mac-mouse-fix"
      "microsoft-office"
      "microsoft-auto-update"
      "windows-app"
      "splashtop-business"
      "topnotch"
      "tunnelblick"
      "zenmap"
      "via"
      "microsoft-teams"
      "obsidian"
      "macfuse"
      "obs"
      "ghostty"
      "freelens"
      "karabiner-elements"
      "bartender"
      "displaylink"
      "firefox@nightly"
      "tailscale-app"
      "munki"
    ];

    masApps = {
      # "vscode" = 6444809156;
    };
  };
}
