{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lazygit       # Terminal UI for git
    stow          # Symlink manager for dotfiles
  ];
}
