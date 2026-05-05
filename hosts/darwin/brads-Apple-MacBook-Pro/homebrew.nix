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
      "linear-linear"
      "claude-code@latest"
    ];

    masApps = {
      # "vscode" = 6444809156;
    };
  };
}
