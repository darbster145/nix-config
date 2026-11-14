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

  wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
    -- Framework 13 panel, right of the PG42UQ
    local function laptopPanel(disabled)
        hl.monitor({
            output   = "eDP-1",
            disabled = disabled,
            mode     = "2880x1920@120",
            position = "auto-right",
            scale    = 1.5,
            vrr      = 2,
            supports_hdr        = true,
            bitdepth            = 10,
            supports_wide_color = true,
        })
    end
    -- Match the lid on (re)load, e.g. after home-manager switch with the lid shut
    local function lidClosed()
        local f = io.open("/proc/acpi/button/lid/LID0/state")
        if not f then return false end
        local state = f:read("*a")
        f:close()
        return state:find("closed") ~= nil
    end
    laptopPanel(lidClosed())

    -- Lid closed: panel off (logind decides whether to suspend)
    hl.bind("switch:on:Lid Switch",  function() laptopPanel(true) end,  { locked = true })
    hl.bind("switch:off:Lid Switch", function() laptopPanel(false) end, { locked = true })
  '';

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
