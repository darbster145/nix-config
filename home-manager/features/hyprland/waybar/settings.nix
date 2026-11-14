{ lib, ... }:

{
  # GNOME-style top bar: workspaces left, clock centre, one status pill right.
  # Hosts add modules to the status pill (e.g. "battery"); power stays last.
  programs.waybar = {
    settings = {
      mainBar = {
        layer = "top";
        height = 34;
        spacing = 0;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "group/status" ];

        "group/status" = {
          orientation = "horizontal";
          modules = lib.mkMerge [
            (lib.mkOrder 500 [
              "tray"
              "idle_inhibitor"
              "pulseaudio"
            ])
            (lib.mkOrder 1500 [ "custom/power" ])
          ];
        };

        "hyprland/workspaces" = {
          format = "";
          sort-by-number = true;
          on-click = "activate";
        };

        "clock" = {
          format = "{:%a %b %d  %H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            format.today = "<b><u>{}</u></b>";
          };
        };

        "tray" = {
          icon-size = 16;
          spacing = 10;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰛊";
          };
          tooltip-format-activated = "Keeping awake";
          tooltip-format-deactivated = "Click to keep awake";
        };

        "pulseaudio" = {
          format = "{icon}";
          format-muted = "󰖁";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋋";
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          tooltip-format = "{desc}: {volume}%";
          on-click = "pavucontrol";
        };

        "power-profiles-daemon" = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}";
          format-icons = {
            default = "󰗑";
            performance = "󰓅";
            balanced = "󰗑";
            power-saver = "󰌪";
          };
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "󰂄  {capacity}%";
          format-plugged = "󰚥  {capacity}%";
          format-icons = [
            "󰁺"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰂂"
            "󰁹"
          ];
          tooltip-format = "{timeTo}";
        };

        "custom/power" = {
          format = "󰐥";
          on-click = "power-menu";
          tooltip = false;
        };
      };
    };
  };
}
