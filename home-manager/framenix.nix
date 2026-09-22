{ lib, pkgs, ... }:

{
  imports = [
    ./global/default.nix
    ./features/base/default.nix
    ./features/cli/tmux.nix
    ./features/cli/yazi.nix
    ./features/cli/zoxide.nix
    ./features/development/kubernetes.nix
    ./features/development/version-control.nix
    ./features/desktop/apps.nix
    ./features/desktop/codex-desktop.nix
    ./features/desktop/oh-my-posh.nix
    ./features/desktop/opencode.nix
    ./features/desktop/zen-browser.nix
    ./features/desktop/ghostty.nix
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

  home = {
    username = "brad";
    homeDirectory = "/home/brad";
  };

  home.packages = with pkgs; [
    banana-cursor
    bitwarden-cli
    jellyfin-media-player
    proton-vpn
    proton-vpn-cli
    opencode-claude-auth
    claude-code
    codex
    vlc
  ];

  home.pointerCursor = {
    enable = true;
    package = pkgs.banana-cursor;
    name = "banana-cursor";
    hyprcursor.enable = true;
    hyprcursor.size = 24;
  };
}
