# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: 

{
  imports = [
    ./features/development/kubernetes.nix
    ./features/development/version-control.nix
    ./features/desktop/apps.nix
    ./features/desktop/ghostty.nix
    ./features/desktop/opencode.nix
    ./features/desktop/aerospace.nix
    ./features/desktop/oh-my-posh.nix
    ./features/desktop/zen-browser.nix
    ./features/cli/git.nix
    ./features/cli/zsh.nix
    ./features/cli/tmux.nix
    ./features/cli/yazi.nix
    ./features/cli/common.nix
    ./features/cli/zoxide.nix
    ./features/cli/neovim.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      allowUnsupported = true;
    };
  };

  home = {
    username = "brad";
    homeDirectory = "/Users/brad";
  };

  home.packages = with pkgs; [
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
