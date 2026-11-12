{
  inputs,
  lib,
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

  # Use the panel's advertised mode instead of the MacBook display timings.
  _module.args.hyprlandLaptopMonitor = ''
    hl.monitor({
        output = "eDP-1",
        mode = "preferred",
        position = "auto",
        scale = 1.5,
    })
  '';
  programs.waybar.settings.mainBar.backlight.device = lib.mkForce "intel_backlight";

  home.packages = with pkgs; [
    bitwarden-cli
    bitwarden-desktop
    proton-vpn-cli
    claude-code
    inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default
    vlc
    ytermusic
    sone
    remmina
    #ungoogled-chromium
    firefox-bin
    webcamoid
    easyeffects
    android-tools
    widevine-cdm
    nix-prefetch
  ];
}
