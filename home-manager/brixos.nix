# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    ./global/default.nix
    ./features/base/default.nix
    ./features/cli/tmux.nix
    ./features/cli/yazi.nix
    ./features/cli/zoxide.nix
    ./features/development/kubernetes.nix
    ./features/development/version-control.nix
    ./features/desktop/apps.nix
    ./features/desktop/oh-my-posh.nix
    ./features/desktop/opencode.nix
    ./features/desktop/zen-browser.nix
    ./features/desktop/ghostty.nix
    ./features/hyprland/default.nix
  ];



  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  home = {
    username = "brad";
    homeDirectory = "/home/brad";
  };

  home.packages = with pkgs; [
  ];
}
