{
  programs.waybar = {
    settings = {
      mainBar = {
        layer = "top";
        height = 38;
        modules-left = [ "custom/apple" "hyprland/workspaces" "custom/media" ];
        modules-right = [ "network" "cpu" "memory" "temperature" "pulseaudio" "backlight" "clock" "battery" ];
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
          persistent_workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
            "6" = [];
            "7" = [];
            "8" = [];
            "9" = [];
            "10" = [];
          };
        };
        "mpd" = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          unknown-tag = "N/A";
          interval = 2;
          consume-icons = {
            on = " ";
          };
          random-icons = {
            off = ''<span color="#f53c3c"></span> '';
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
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
          format-icons = [ "" "" "" "" "" ];
          tooltip = false;
        };
        "backlight" = {
          device = "apple-panel-bl";
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
          format-icons = [ "" "" "" "" "" ];
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
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        "custom/media" = {
          format = "{icon} {}";
          return-type = "json";
          max-length = 40;
          format-icons = {
            spotify = "";
            default = "🎜";
          };
          escape = true;
          exec = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null";
        };
        "custom/apple" = {
          format = " ";
          on-click = "wlogout";
          tooltip = false;
        };
      };
    };
  };
}
