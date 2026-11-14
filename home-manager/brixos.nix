# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./global/default.nix
    ./features/cli/default.nix
    ./features/desktop/default.nix
    ./features/desktop/codex-desktop.nix
    ./features/development/kubernetes.nix
    ./features/development/version-control.nix
    ./features/hyprland/default.nix
  ];

  home.packages = with pkgs; [
    discord
    chromium
    zed-editor
    zathura
    bluetui
    pay-respects
    rustup
    nodejs
    # lutris
    #davinci-resolve
  ];
}
