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
    ./global/default.nix
    ./features/development/kubernetes.nix
    ./features/development/version-control.nix
    ./features/desktop/default.nix
    ./features/cli/default.nix
  ];
  home = {
    username = "brad";
    homeDirectory = "/Users/brad";
  };

  home.packages = with pkgs; [
    notion-app
    #istat-menus
    #bartender
    freelens-bin
    zoxide
    raycast
    aldente
    firefox
    google-chrome
    zed-editor
    opencode-claude-auth
  ];

  programs.gh = {
    enable = true;
  };

  programs.gh-dash = {
    enable = true;
  };

}
