{ lib, pkgs, ... }:

let
  # Waybar's built-in "disk" module only reports space used, so disk I/O
  # throughput comes from /proc-style block stats (512-byte sectors).
  diskIo = pkgs.writeShellApplication {
    name = "waybar-disk-io";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      interval=2

      totals() {
        r=0
        w=0
        for d in /sys/block/*; do
          case ''${d##*/} in loop* | ram* | zram* | dm-* | md* | sr*) continue ;; esac
          read -r _ _ rs _ _ _ ws _ < "$d/stat"
          r=$((r + rs))
          w=$((w + ws))
        done
      }

      human() {
        numfmt --to=iec --suffix=B/s --format="%.1f" "$1"
      }

      totals
      prev_r=$r
      prev_w=$w
      while true; do
        sleep "$interval"
        totals
        read_bps=$(((r - prev_r) * 512 / interval))
        write_bps=$(((w - prev_w) * 512 / interval))
        prev_r=$r
        prev_w=$w
        rh=$(human "$read_bps")
        wh=$(human "$write_bps")
        printf '{"text":"󰋊 󰁅 %s 󰁝 %s","tooltip":"Disk read: %s\\nDisk write: %s"}\n' \
          "$rh" "$wh" "$rh" "$wh"
      done
    '';
  };
in
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
        modules-right = [
          "group/system"
          "group/status"
        ];

        "group/system" = {
          orientation = "horizontal";
          modules = [
            "cpu"
            "memory"
            "network"
            "custom/disk-io"
          ];
        };

        "cpu" = {
          interval = 2;
          format = "󰻠 {usage}%";
          tooltip-format = "CPU: {usage}% ({avg_frequency} GHz)";
        };

        "memory" = {
          interval = 2;
          format = "󰍛 {percentage}%";
          tooltip-format = "RAM: {used:0.1f} / {total:0.1f} GiB\nSwap: {swapUsed:0.1f} / {swapTotal:0.1f} GiB";
        };

        "network" = {
          interval = 2;
          format = "󰇚 {bandwidthDownBytes} 󰕒 {bandwidthUpBytes}";
          format-disconnected = "󰤮 offline";
          tooltip-format = "{ifname}: {ipaddr}\nDown: {bandwidthDownBytes}\nUp: {bandwidthUpBytes}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n{ifname}: {ipaddr}\nDown: {bandwidthDownBytes}\nUp: {bandwidthUpBytes}";
        };

        "custom/disk-io" = {
          exec = lib.getExe diskIo;
          return-type = "json";
        };

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
