let
  dpms = action: "hyprctl dispatch 'hl.dsp.dpms({ action = \"${action}\" })'";
in
{

  # Shared listeners. Hosts append extra listeners (keyboard backlight,
  # suspend, ...) from their own home-manager file.
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = dpms "enable";
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
        ignore_wayland_inhibit = false;
      };

      listener = [
        # Blank screen
        {
          timeout = 600;
          on-timeout = dpms "disable";
          on-resume = dpms "enable";
        }

        # Lock screen
        {
          timeout = 660;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };

}
