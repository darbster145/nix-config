{
  inputs,
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

  # Laptop panel and lid switch. Sorts after the shared files, so it loads last.
  wayland.windowManager.hyprland.extraLuaFiles."hosts.framenix" =
    ./features/hyprland/lua/hosts/framenix.lua;

  # Low-battery notifications (defaults: warning 15%, critical 5%).
  services.batsignal = {
    enable = true;
    extraArgs = [
      "-n"
      "BAT1"
    ];
  };

  programs.waybar.settings.mainBar."group/status".modules = [
    "power-profiles-daemon"
    "battery"
  ];

  services.hypridle.settings.listener = [
    # Keyboard backlight
    {
      timeout = 60;
      on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd '*::kbd_backlight' set 0";
      on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd '*::kbd_backlight'";
    }

    # Suspend after 12 minutes, but only on battery
    {
      timeout = 720;
      on-timeout = toString (
        pkgs.writeShellScript "suspend-on-battery" ''
          [ "$(cat /sys/class/power_supply/ACAD/online)" = 0 ] && systemctl suspend
        ''
      );
    }
  ];

  programs.hyprlock.settings.auth.fingerprint = {
    enabled = true;
    ready_message = "Scan fingerprint to unlock";
    present_message = "Scanning...";
    retry_delay = 250;
  };

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
