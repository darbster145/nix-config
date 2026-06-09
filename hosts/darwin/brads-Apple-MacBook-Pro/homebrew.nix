{ config, ...}:

{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    #caskArgs.no_quarantine = true;

    # Declared by nix-homebrew 
    taps = builtins.attrNames config.nix-homebrew.taps;

    brews = [
      "mas"
    ];

    casks = [
      "mac-mouse-fix"
      "windows-app"
      "linear"
      "claude-code@latest"
      "tailscale-app"
      "lunar"
      "imazing-profile-editor"
      "1password@nightly"
      "1password-cli@beta"
      "bartender"
      "istat-menus"
    ];

    masApps = {
      # "vscode" = 6444809156;
      "apple-configurator" = 1037126344;
    };
  };
}
