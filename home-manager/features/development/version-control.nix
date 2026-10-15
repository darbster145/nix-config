{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lazygit
    lazydocker
    lazyssh
    codex
    opencode-desktop
  ];

  programs.gh.enable = true;
  programs.gh-dash.enable = true;

  programs.zsh = {
    shellAliases = {
      lg = "lazygit";
    };
  };
}
