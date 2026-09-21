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
    ./features/development/zed-editor.nix
    ./features/development/version-control.nix
    ./features/desktop/default.nix
    ./features/cli/default.nix
  ];
  home = {
    username = "brad";
    homeDirectory = "/Users/brad";
  };

  home.packages = with pkgs; [
    #istat-menus
    #freelens-bin
    aldente
    firefox
    google-chrome
    #zed-editor
    opencode-claude-auth
    #terraform
    tfenv
    powershell
    #(google-cloud-sdk.withExtraComponents [
    #  google-cloud-sdk.components.gke-gcloud-auth-plugin
    #])
    graphite-cli
    nodejs-slim_26
    nerd-fonts.fira-mono
    nerd-fonts.symbols-only
    noto-fonts
  ];

  fonts.fontconfig.enable = true;

  programs.gh = {
    enable = true;
  };

  programs.gh-dash = {
    enable = true;
  };

}
