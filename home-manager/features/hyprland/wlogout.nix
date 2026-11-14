{ pkgs, ... }:

let
  c = import ./palette.nix;

  # wlogout only takes pixel margins, so size them from the focused monitor
  # to get a compact centred row of buttons like GNOME's power menu.
  power-menu = pkgs.writeShellApplication {
    name = "power-menu";
    runtimeInputs = with pkgs; [
      jq
      wlogout
    ];
    text = ''
      read -r w h < <(hyprctl monitors -j | jq -r '.[] | select(.focused) | "\(.width / .scale | floor) \(.height / .scale | floor)"')
      exec wlogout -b 4 -L $(((w - 760) / 2)) -R $(((w - 760) / 2)) -T $(((h - 190) / 2)) -B $(((h - 190) / 2))
    '';
  };
in
{

  home.packages = [ power-menu ];

  # Opened with `power-menu` from waybar and SUPER+SHIFT+Escape.
  programs.wlogout = {
    enable = true;
    layout = [

      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }

      {
        label = "logout";
        action = "uwsm stop";
        text = "Log Out";
        keybind = "e";
      }

      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Restart";
        keybind = "r";
      }

      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Power Off";
        keybind = "s";
      }

    ];

    style = ''
      * {
          box-shadow: none;
          font-family: "Adwaita Sans";
          font-size: 15px;
          font-weight: bold;
      }

      window {
          background-color: rgba(0, 0, 0, 0.5);
      }

      button {
          margin: 10px;
          border: none;
          border-radius: 12px;
          color: ${c.fg};
          background-color: ${c.bg};
          background-repeat: no-repeat;
          background-position: center;
          background-size: 48px;
      }

      button:focus,
      button:hover {
          background-color: ${c.bgHighlight};
          outline-style: none;
      }

      #lock     { background-image: -gtk-icontheme("system-lock-screen-symbolic"); }
      #logout   { background-image: -gtk-icontheme("system-log-out-symbolic"); }
      #reboot   { background-image: -gtk-icontheme("system-reboot-symbolic"); }
      #shutdown { background-image: -gtk-icontheme("system-shutdown-symbolic"); }
    '';
  };

}
