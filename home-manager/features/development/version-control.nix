{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lazygit
    lazydocker
    gh
    gh-dash
    lazyssh
    codex
    opencode-desktop
  ];
}
