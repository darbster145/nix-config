{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "brad";
    autoMigrate = true;
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
      "zen-browser"
      "via"
    ];

    masApps = {
      # "vscode" = 6444809156;
    };
  };
}