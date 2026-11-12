# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ pkgs, ... }:

{
  imports = [
    ./global/default.nix
    ./features/cli/default.nix
    ./features/desktop/default.nix
    ./features/desktop/aerospace.nix
    ./features/desktop/opencode-work.nix
    ./features/development/kubernetes.nix
    #./features/development/zed-editor.nix
    ./features/development/version-control.nix
    ./features/development/colima.nix
  ];

  home.packages = with pkgs; [
    #istat-menus
    tidal
    aldente
    # Keep Mozilla's signed macOS app and native launcher intact for TCC profile access.
    firefox-bin-unwrapped
    google-chrome
    #zed-editor
    slack-cli
    #terraform
    tfenv
    powershell
    #(google-cloud-sdk.withExtraComponents [
    #  google-cloud-sdk.components.gke-gcloud-auth-plugin
    #])
    graphite-cli
    gam
    nodejs-slim_26
    nixos-rebuild
  ];
}
