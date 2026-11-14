{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprland.nix
    ./theme.nix
    ./waybar/default.nix
    ./wlogout.nix
  ];

  services.hyprpolkitagent.enable = true;
  services.dunst.enable = true;
  services.udiskie = {
    enable = true;
    tray = "never"; # tray mode needs a tray.target, which nothing provides here
  };
  services.clipse.enable = true;

  # These services hang off graphical-session.target, which KDE also starts.
  # Keep them out of Plasma sessions. mkForce because some upstream modules set
  # this to a plain string ("WAYLAND_DISPLAY"), which can't merge with a list.
  systemd.user.services =
    lib.mapAttrs
      (
        _: enabled:
        lib.mkIf enabled {
          Unit.ConditionEnvironment = lib.mkForce [
            "WAYLAND_DISPLAY"
            "XDG_CURRENT_DESKTOP=Hyprland"
          ];
        }
      )
      {
        waybar = config.programs.waybar.enable;
        hypridle = config.services.hypridle.enable;
        hyprpaper = config.services.hyprpaper.enable;
        hyprpolkitagent = config.services.hyprpolkitagent.enable;
        dunst = config.services.dunst.enable;
        udiskie = config.services.udiskie.enable;
        clipse = config.services.clipse.enable;
      };

  home.packages = with pkgs; [
    hyprsunset
  ];
}
