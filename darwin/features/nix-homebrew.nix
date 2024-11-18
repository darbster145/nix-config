{ inputs, ... }:

{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "brad";
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    caskArgs.no_quarantine = true;

    taps = [
      #"koekeishiya/formulae"
    ];

    brews = [
      #"yabai"
      #"skhd"
      "mas"
    ];

    casks = [
      #"bitwarden"
      "1password"
      "1password-cli"
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
      "splashtop-business"
      "topnotch"
      "tunnelblick"
      "zenmap"
      "via"
    ];

    masApps = {
      # "vscode" = 6444809156;
    };
  };
}
