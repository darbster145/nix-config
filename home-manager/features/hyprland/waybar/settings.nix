{
  programs.waybar = {
    settings = {
      mainBar = {
        layer = "top";
        height = 38;
        modules-left = [
          "custom/power"
          "hyprland/workspaces"
          "mpris"
        ];
        # Hosts with a battery append "backlight" and "battery" via lib.mkAfter.
        modules-right = [
          "tray"
          "network"
          "cpu"
          "memory"
          "temperature"
          "pulseaudio"
          "clock"
        ];
        "hyprland/workspaces" = {
          sort-by-number = true;
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = " ";
            "2" = " ";
            "3" = " ";
            "4" = " ";
            "5" = " ";
            "6" = " ";
            "7" = " ";
            "8" = " ";
            "9" = " ";
            "10" = " ";
          };
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
            "6" = [ ];
            "7" = [ ];
            "8" = [ ];
            "9" = [ ];
            "10" = [ ];
          };
        };
        "tray" = {
          spacing = 10;
        };
        "clock" = {
          format = "{:%H:%M %a %b %d}";
          tooltip = false;
        };
        "cpu" = {
          format = "  {usage}%";
          tooltip = false;
        };
        "memory" = {
          format = "  {}%";
          tooltip = false;
        };
        "temperature" = {
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip = false;
        };
        "backlight" = {
          format = "{icon}  {percent}%";
          format-icons = [ "" ];
          tooltip = false;
        };
        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip = false;
        };
        "network" = {
          format-wifi = "";
          format-ethernet = "";
          format-linked = "";
          format-disconnected = "⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip = false;
          on-click = "nm-connection-editor";
        };
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };
        "mpris" = {
          format = "{status_icon} {dynamic}";
          dynamic-len = 40;
          dynamic-order = [
            "title"
            "artist"
          ];
          status-icons = {
            playing = "▶";
            paused = "⏸";
            stopped = "⏹";
          };
        };
        "custom/power" = {
          format = "";
          on-click = "wlogout";
          tooltip = false;
        };
      };
    };
  };
}
