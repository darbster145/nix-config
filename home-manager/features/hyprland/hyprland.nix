{
  config,
  lib,
  pkgs,
  ...
}:

let
  palette = import ./palette.nix;
  cfg = config.wayland.windowManager.hyprland;
in
{

  # Make KDE apps behave as in Plasma: its app menu ("Open with") and its
  # colours/style. Set here because UWSM sets XDG_MENU_PREFIX before Hyprland's env runs.
  xdg.configFile = {
    "uwsm/env-hyprland".text = ''
      export XDG_MENU_PREFIX=plasma-
      export QT_QPA_PLATFORMTHEME=kde
    '';
  }
  # Home Manager only reloads Hyprland when hyprland.lua changes; reload on
  # changes to the required Lua files too.
  // lib.mapAttrs' (
    name: _:
    lib.nameValuePair "hypr/${
      builtins.replaceStrings [ "." ] [ "/" ] (lib.removeSuffix ".lua" name)
    }.lua" { onChange = config.xdg.configFile."hypr/hyprland.lua".onChange; }
  ) cfg.extraLuaFiles;

  # The Lua config lives in ./lua. Files are required in name order.
  # Host-specific Lua (laptop panel, ...) is added from the host's home-manager file.
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    systemd.enable = false;
    extraLuaFiles = {
      "10-monitors" = ./lua/monitors.lua;
      "20-autostart" = ./lua/autostart.lua;
      "30-env" = ./lua/env.lua;
      "40-look" = ./lua/look.lua;
      "50-input" = ./lua/input.lua;
      "60-binds" = ./lua/binds.lua;
      "70-rules" = ./lua/rules.lua;

      programs = {
        content = ./lua/programs.lua;
        autoLoad = false;
      };

      # Nix store paths and palette colours the Lua config needs.
      nix = {
        autoLoad = false;
        content = ''
          return ${
            lib.generators.toLua { } {
              colors = lib.mapAttrs (_: palette.hex) (removeAttrs palette [ "hex" ]);
              kwallet_init = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init";
            }
          }
        '';
      };
    };
  };
}
