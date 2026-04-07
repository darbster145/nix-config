{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = [ "hyprland-session.target" ];
    };
    settings = {
      mainBar = {
        layer = "top";
        height = 38;
        modules-left = [ "custom/apple" "clock" "hyprland/workspaces" "custom/media" ];
        modules-right = [ "network" "cpu" "memory" "temperature" "pulseaudio" "backlight" "battery" ];
        "wlr/workspaces" = {
          sort-by-number = true;
          format = "{name}: {icon}";
          on-click = "activate";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "0";
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
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ifname}: {ipaddr}/{cidr}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
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
    style = ''
  @keyframes blink-warning {
      70% {
          color: @light;
      }
      to {
          color: @light;
          background-color: @warning;
      }
  }

  @keyframes blink-critical {
      70% {
          color: @light;
      }
      to {
          color: @light;
          background-color: @critical;
      }
  }

  @define-color bg #353C4A;
  @define-color light #cdd6f4;
  @define-color dark #2e3440;
  @define-color warning #ebcb8b;
  @define-color critical #f38ba8;
  @define-color mode #1e1e2e;
  @define-color workspaces #1e1e2e;
  @define-color workspacesfocused #1e1e2e;
  @define-color tray @workspacesfocused;
  @define-color sound #1e1e2e;
  @define-color network #1e1e2e;
  @define-color memory #1e1e2e;
  @define-color cpu #1e1e2e;
  @define-color temp #1e1e2e;
  @define-color layout #1e1e2e;
  @define-color battery #1e1e2e;
  @define-color date #1e1e2e;
  @define-color time #3A4253;
  @define-color backlight #1e1e2e;
  @define-color apple #1e1e2e;

  * {
      border: none;
      border-radius: 0;
      min-height: 0;
      margin: 0;
      padding: 0;
  }

  #waybar {
      background: rgba(0,0,0,1);
      color: @light;
      font-family: "Noto Sans", "Font Awesome 6 Free";
      font-size: 12px;
      font-weight: bold;
  }

  #battery,
  #cpu,
  #custom-layout,
  #memory,
  #mode,
  #network,
  #pulseaudio,
  #temperature,
  #custom-alsa,
  #tray,
  #backlight {
      padding-left: 10px;
      padding-right: 10px;
      margin-left: 5px;
      margin-top: 4px;
      padding-top: 5px;
      padding-bottom: 5px;
      margin-bottom: 3px;
  }

  #clock {
      padding-left: 10px;
      padding-right: 10px;
      margin-right: 5px;
      margin-top: 4px;
      padding-top: 5px;
      padding-bottom: 5px;
      margin-bottom: 3px;
  }

  #custom-apple {
      padding-left: 8px;
      padding-right: 8px;
      margin-right: 5px;
      margin-top: 4px;
      padding-top: 2px;
      padding-bottom: 2px;
      margin-bottom: 3px;
  }

  #mode,
  #memory,
  #temperature,
  #battery {
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
  }

  #memory.critical,
  #cpu.critical,
  #temperature.critical,
  #battery.critical {
      color: @critical;
  }

  #mode,
  #memory.critical,
  #temperature.critical,
  #battery.critical.discharging {
      animation-name: blink-critical;
      animation-duration: 2s;
  }

  #network.disconnected,
  #memory.warning,
  #cpu.warning,
  #temperature.warning,
  #battery.warning {
      color: @warning;
  }

  #battery.warning.discharging {
      animation-name: blink-warning;
      animation-duration: 3s;
  }

  #mode {
      color: @light;
      background: @mode;
  }

  #workspaces button {
      font-weight: bold;
      padding-left: 5px;
      padding-right: 5px;
      color: @light;
      background: @workspaces;
      border-radius: 8px;
      margin-top: 4px;
      padding-top: 5px;
      padding-bottom: 5px;
      margin-bottom: 3px;
      margin-right: 1px;
  }

  #workspaces button.active {
      color: #f9e2af;
  }

  #workspaces button.urgent {
      color: #f38ba8;
  }

  #window {
      margin-right: 40px;
      margin-left: 40px;
  }

  #custom-alsa {
      background: @sound;
      border-radius: 8px;
  }

  #network {
      background: @network;
      border-radius: 8px;
  }

  #memory {
      background: @memory;
      border-radius: 8px;
  }

  #cpu {
      background: @cpu;
      border-radius: 8px;
  }

  #temperature {
      background: @temp;
      border-radius: 8px;
  }

  #custom-layout {
      background: @layout;
      border-radius: 8px;
  }

  #battery {
      background: @battery;
      border-radius: 8px;
      border-top-right-radius: 16px;
      margin-right: 5px;
  }

  #backlight {
      background: @backlight;
      border-radius: 8px;
  }

  #clock {
      background: @date;
      border-radius: 8px;
  }

  #pulseaudio {
      background: @sound;
      border-radius: 8px;
  }

  #tray {
      background: @tray;
      border-radius: 8px;
  }

  #custom-apple {
      font-size: 17px;
      background: @apple;
      border-radius: 8px;
      border-top-left-radius: 16px;
      margin-left: 5px;
      padding-left: 14px;
      padding-right: 14px;
  }

  #custom-notch {
      margin-left: 100px;
      margin-right: 100px;
      padding-left: 14px;
      padding-right: 14px;
  }
'';
  };
}
