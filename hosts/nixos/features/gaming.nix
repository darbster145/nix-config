{ config, pkgs, ... }:

let
  hyprctl = "${config.programs.hyprland.package}/bin/hyprctl";

  # GameMode start/end hook: Hyprland effects off while gaming, plus a notification.
  gamemodeHook = pkgs.writeShellScript "gamemode-hook" ''
    if [ "$1" = on ]; then effects=false; else effects=true; fi

    ${hyprctl} eval "hl.config({
      animations = { enabled = $effects },
      decoration = { blur = { enabled = $effects }, shadow = { enabled = $effects } },
    })" > /dev/null 2>&1 || true

    ${pkgs.libnotify}/bin/notify-send -a GameMode -i input-gaming \
      "GameMode $1" "Hyprland effects $([ "$1" = on ] && echo paused || echo restored)"
  '';
in
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    protontricks.enable = true;
  };

  # Launch games with `gamemoderun %command%` in Steam to use this.
  programs.gamemode = {
    enable = true;
    settings = {
      general.renice = 10;
      custom = {
        start = "${gamemodeHook} on";
        end = "${gamemodeHook} off";
      };
    };
  };

  users.users.brad.extraGroups = [ "gamemode" ];

  hardware.uinput.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", SYMLINK+="uinput"
  '';

  environment.systemPackages = with pkgs; [
    goverlay
    heroic
    mangohud
  ];
}
