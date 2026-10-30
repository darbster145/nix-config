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
    ./features/development/kubernetes.nix
    #./features/development/zed-editor.nix
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
    tidal
    aldente
    # Keep Mozilla's signed macOS app and native launcher intact for TCC profile access.
    firefox-bin-unwrapped
    google-chrome
    #zed-editor
    opencode-claude-auth
    slack-cli
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

  programs.opencode.settings.mcp.servers.radar = {
    type = "remote";
    url = "http://127.0.0.1:52551/mcp";
    oauth = false;
  };

  fonts.fontconfig.enable = true;
}
