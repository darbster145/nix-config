{ config, ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
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
      "1password@nightly"
      "1password-cli"
      "chromium"
      "crystalfetch"
      "disk-inventory-x"
      "displaylink"
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
      "ghostty@tip"
      "obsidian"
      "macfuse"
      "vmware-fusion"
      "obs"
      "tailscale"
      "moonlight"
      "rancher"
    ];

    masApps = {
      # "vscode" = 6444809156;
    };
  };
}
