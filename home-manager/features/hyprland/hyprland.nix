{ lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = [
        "eDP-1,3024x1964@120,0x0,1.68,bitdepth,10"
        # "HDMI-A-1,3840x2160@60,-3840x-496,1.00,bitdepth,10"
        "DP-1,3840x2160@120,-3840x-496,1.00,bitdepth,10"
      ];

      "debug:disable_scale_checks" = 1;

      bindl = [
        ",switch:on:Apple SMC power/lid events,exec,hyprctl keyword monitor \"eDP-1, disable\""
        ",switch:off:Apple SMC power/lid events,exec,hyprctl keyword monitor \"eDP-1, 3024x1964@60, 0x0, 1.68\""
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      exec-once = [
        "nm-applet & blueman-applet"
        "hyprpaper"
        "hypridle"
        "clipse -listen"
        "hyprctl setcursor Banana 24"
        "/usr/lib/pam_kwallet_init"
        "walker --gapplication-service"
        "elephant"
      ];

      env = [
        "HYPRCURSOR_THEME,Banana"
        "HYPRCURSOR_SIZE,24"
        "XCURSOR_THEME,Banana"
        "XCURSOR_SIZE,24"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;
        sensitivity = 1.0;

        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
          disable_while_typing = true;
        };
      };

      gesture = [
        "3, horizontal, workspace"
      ];

      gestures = {
        workspace_swipe_invert = true;
        workspace_swipe_forever = true;
        workspace_swipe_create_new = true;
        workspace_swipe_distance = 700;
      };

      misc = {
        disable_hyprland_logo = true;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
      };

      animations = {
        enabled = true;

        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];

        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 5, default, popin 80%"
          "border, 1, 5, default"
          "borderangle, 1, 8, default"
          "fade, 1, 3, default"
          "workspaces, 1, 2, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        # new_is_master = true;
      };

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, T, exec, ghostty"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, nautilus"
        "$mainMod, F, togglefloating,"
        "$mainMod, R, exec, walker"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, B, exec, zen-beta"
        "$mainMod CONTROL, L, exec, hyprlock"

        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e+1"

        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
        ",XF86MonBrightnessUp,exec,brightnessctl set +5%"

        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"

        "SUPER, V, exec, ghostty --class=com.example.clipse -e clipse"

        "$mainMod SHIFT, S, exec, hyprshot -m region | wl-copy"
      ];

      binde = [
        "$mainMod, XF86MonBrightnessUp, exec, brightnessctl -d kbd_backlight set 5%+"
        "$mainMod, XF86MonBrightnessDown, exec, brightnessctl -d kbd_backlight set 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
