{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./dunst.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprland.nix
    ./swayosd.nix
    ./theme.nix
    ./walker.nix
    ./waybar/default.nix
    ./wlogout.nix
  ];

  services.hyprpolkitagent.enable = true;
  services.udiskie = {
    enable = true;
    tray = "never"; # tray mode needs a tray.target, which nothing provides here
  };
  services.clipse.enable = true;

  # Screenshot annotation (SUPER+SHIFT+A). Enter copies, Ctrl+S saves.
  programs.satty = {
    enable = true;
    settings.general = {
      early-exit = [ "all" ];
      corner-roundness = 8;
      initial-tool = "arrow";
      copy-command = "wl-copy";
      output-filename = "~/Pictures/satty-%Y-%m-%d_%H-%M-%S.png";
      actions-on-enter = [ "save-to-clipboard" ];
    };
  };

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
        swayosd = config.services.swayosd.enable;
      };

  home.packages = with pkgs; [
    hyprsunset
  ];
}
