# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    ./features/cli/neovim.nix
    ./features/cli/git.nix
    ./features/cli/zsh.nix
    ./features/cli/zoxide.nix
    ./features/cli/tmux.nix
    ./features/cli/yazi.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      allowUnsupported = true;
    };
  };

  home = {
    username = "brad";
    homeDirectory = "/home/brad";
  };

  home.packages = with pkgs; [
    banana-cursor
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  home.pointerCursor = {
    enable = true;
    package = pkgs.banana-cursor;
    name = "banana-cursor";
    hyprcursor.enable = true;
    hyprcursor.size = 24;
  };


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
