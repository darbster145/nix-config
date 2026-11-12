{ lib, pkgs, ... }:

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

  # These services hang off graphical-session.target, which KDE also starts.
  # Keep them out of Plasma sessions. mkForce because the upstream modules set
  # this to a plain string ("WAYLAND_DISPLAY"), which can't merge with a list.
  systemd.user.services = lib.genAttrs [ "waybar" "hypridle" "hyprpaper" ] (_: {
    Unit.ConditionEnvironment = lib.mkForce [
      "WAYLAND_DISPLAY"
      "XDG_CURRENT_DESKTOP=Hyprland"
    ];
  });

  home.packages = with pkgs; [
    #kdePackages.xwaylandvideobridge # Needed to screenshare xwayland programs
    hyprpolkitagent
    hyprsunset
    udiskie # Auto Mount USB
    waypaper # GUI frontend for hyprpaper, swww, etc
    nwg-dock
  ];
}
