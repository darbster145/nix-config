{ pkgs, ... }:

let
  inherit (import ./palette.nix)
    hex
    blue
    magenta
    bgHighlight
    bgDark
    ;
in
{

  # Shared by every Hyprland host. Host-specific Lua (laptop panel, touchpad,
  # tearing, ...) is appended from the host's home-manager file with lib.mkAfter.
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    systemd.enable = false;
    extraConfig = ''
      ------------------
      ---- MONITORS ----
      ------------------

      -- Asus PG42UQ, matched by description so it works on any port/host.
      hl.monitor({
          output   = "desc:ASUSTek COMPUTER INC PG42UQ",
          mode     = "3840x2160@138",
          position = "0x0",
          scale    = 1,
          vrr      = 2,
          supports_hdr        = true,
          bitdepth            = 10,
          supports_wide_color = true,
      })

      -- Fallback for anything else that gets plugged in.
      hl.monitor({
          output   = "",
          mode     = "preferred",
          position = "auto",
          scale    = "auto",
      })


      ---------------------
      ---- MY PROGRAMS ----
      ---------------------

      local terminal    = "ghostty"
      local fileManager = "dolphin"
      local menu        = "walker"
      local browser     = "zen-beta"


      -------------------
      ---- AUTOSTART ----
      -------------------

      -- Long-running helpers (waybar, hypridle, hyprpaper, dunst, clipse,
      -- polkit agent, udiskie) are systemd user services. blueman-applet comes
      -- from XDG autostart.
      hl.on("hyprland.start", function ()
          hl.exec_cmd("uwsm finalize")
          -- Hands the login password to KWallet. Plasma runs this itself; its
          -- autostart entry is skipped under systemd, so Hyprland must run it.
          hl.exec_cmd("${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init")
          hl.exec_cmd("nm-applet --indicator")
          hl.exec_cmd("walker --gapplication-service")
      end)


      -------------------------------
      ---- ENVIRONMENT VARIABLES ----
      -------------------------------

      hl.env("XCURSOR_SIZE", "24")
      hl.env("XCURSOR_THEME", "Banana")
      hl.env("HYPRCURSOR_SIZE", "24")
      hl.env("HYPRCURSOR_THEME", "Banana")
      -- Lets Dolphin find Plasma's app menu ("Open with") outside Plasma.
      hl.env("XDG_MENU_PREFIX", "plasma-")


      -----------------------
      ---- LOOK AND FEEL ----
      -----------------------

      hl.config({
          general = {
              gaps_in  = 5,
              gaps_out = 10,

              border_size = 2,

              col = {
                  active_border   = { colors = {"rgb(${hex blue})", "rgb(${hex magenta})"}, angle = 45 },
                  inactive_border = "rgb(${hex bgHighlight})",
              },

              resize_on_border = false,
              allow_tearing    = false,
              layout           = "dwindle",
          },

          decoration = {
              rounding       = 8,
              rounding_power = 2,

              active_opacity   = 1.0,
              inactive_opacity = 1.0,

              shadow = {
                  enabled      = true,
                  range        = 4,
                  render_power = 3,
                  color        = "rgba(${hex bgDark}ee)",
              },

              blur = {
                  enabled   = true,
                  size      = 3,
                  passes    = 1,
                  vibrancy  = 0.1696,
              },
          },

          animations = {
              enabled = true,
          },
      })

      hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
      hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
      hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
      hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
      hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
      hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

      hl.animation({ leaf = "global",        enabled = true,  speed = 8,    bezier = "default" })
      hl.animation({ leaf = "border",        enabled = true,  speed = 4.3,  bezier = "easeOutQuint" })
      hl.animation({ leaf = "windows",       enabled = true,  speed = 5.6,  bezier = "easeOutQuint", style = "slide" })
      hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.4,  spring = "easy",         style = "popin 87%" })
      hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 4.4,  bezier = "linear",       style = "popin 87%" })
      hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.4,  bezier = "almostLinear" })
      hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.2,  bezier = "almostLinear" })
      hl.animation({ leaf = "fade",          enabled = true,  speed = 2.4,  bezier = "quick" })
      hl.animation({ leaf = "layers",        enabled = true,  speed = 4.8,  bezier = "easeOutQuint", style = "slide" })
      hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4.8,  bezier = "easeOutQuint", style = "slide" })
      hl.animation({ leaf = "layersOut",     enabled = true,  speed = 4.8,  bezier = "linear",       style = "slide" })
      hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.4,  bezier = "almostLinear" })
      hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.1,  bezier = "almostLinear" })
      hl.animation({ leaf = "workspaces",    enabled = true,  speed = 4.4,  bezier = "easeOutQuint", style = "slide" })
      hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 4.4,  bezier = "easeOutQuint", style = "slide" })
      hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 4.4,  bezier = "easeOutQuint", style = "slide" })
      hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 5.6,  bezier = "quick" })

      hl.config({
          dwindle = {
              preserve_split = true,
          },
          master = {
              new_status = "master",
          },
          scrolling = {
              fullscreen_on_one_column = true,
          },
          misc = {
              force_default_wallpaper = 0,
              disable_hyprland_logo   = false,
          },
          -- Desktop stays SDR; fullscreen HDR content switches the monitor to HDR.
          render = {
              cm_auto_hdr = 1,
          },
      })


      ---------------
      ---- INPUT ----
      ---------------

      hl.config({
          input = {
              kb_layout    = "us",
              follow_mouse = 1,
              sensitivity  = 0.5,

              touchpad = {
                  natural_scroll       = true,
                  clickfinger_behavior = true,
                  disable_while_typing = true,
              },
          },
      })

      hl.gesture({
          fingers   = 3,
          direction = "horizontal",
          action    = "workspace",
      })


      ---------------------
      ---- KEYBINDINGS ----
      ---------------------

      local mainMod = "SUPER"

      hl.bind(mainMod .. " + Q", hl.dsp.window.close())
      hl.bind(mainMod .. " + M", hl.dsp.exit())
      hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
      hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
      hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
      hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
      hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

      -- Session
      hl.bind(mainMod .. " + Escape",         hl.dsp.exec_cmd("loginctl lock-session"))
      hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exec_cmd("power-menu"))

      -- Clipboard history
      hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(terminal .. " --class=clipse.ghostty -e clipse"))

      -- Screenshots (saved to $HYPRSHOT_DIR and copied to the clipboard)
      hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region"))
      hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("hyprshot -m region --raw | satty --filename -"))
      hl.bind("Print",           hl.dsp.exec_cmd("hyprshot -m region"))
      hl.bind("SHIFT + Print",   hl.dsp.exec_cmd("hyprshot -m window"))
      hl.bind("CTRL + Print",    hl.dsp.exec_cmd("hyprshot -m output"))

      -- Move focus with mainMod + H/L/K/J
      hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

      -- Move windows with mainMod + SHIFT + H/L/K/J
      hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
      hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
      hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
      hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

      -- Switch workspaces with mainMod + [0-9]
      -- Move active window to a workspace with mainMod + SHIFT + [0-9]
      for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
          hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      -- Scratchpad
      hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
      hl.bind(mainMod .. " + ALT + S",   hl.dsp.window.move({ workspace = "special:magic" }))

      -- Scroll through existing workspaces with mainMod + scroll
      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

      -- Move/resize windows with mainMod + LMB/RMB and dragging
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Volume and brightness keys (swayosd shows the popup)
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +5 --max-volume 100"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5"),                  { locked = true, repeating = true })
      hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),         { locked = true })
      hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),          { locked = true })
      hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("swayosd-client --brightness +5"),                     { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("swayosd-client --brightness -5"),                     { locked = true, repeating = true })

      -- Media keys
      hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


      --------------------------------
      ---- WINDOWS AND WORKSPACES ----
      --------------------------------

      hl.window_rule({
          name  = "suppress-maximize-events",
          match = { class = ".*" },
          suppress_event = "maximize",
      })

      hl.window_rule({
          -- Fix some dragging issues with XWayland
          name  = "fix-xwayland-drags",
          match = {
              class      = "^$",
              title      = "^$",
              xwayland   = true,
              float      = true,
              fullscreen = false,
              pin        = false,
          },
          no_focus = true,
      })

      hl.window_rule({
          name  = "move-hyprland-run",
          match = { class = "hyprland-run" },
          move  = "20 monitor_h-120",
          float = true,
      })

      hl.window_rule({
          name   = "float-clipse",
          match  = { class = "clipse.ghostty" },
          float  = true,
          center = true,
      })

      hl.window_rule({
          name   = "float-pavucontrol",
          match  = { class = "org.pulseaudio.pavucontrol" },
          float  = true,
      })

      hl.window_rule({
          name   = "float-satty",
          match  = { class = "com.gabm.satty" },
          float  = true,
          center = true,
      })

      hl.window_rule({
          name   = "float-bluetooth",
          match  = { class = "blueman-manager" },
          float  = true,
          center = true,
      })

      hl.window_rule({
          name  = "idle-inhibit-fullscreen",
          match = { class = ".*" },
          idle_inhibit = "fullscreen",
      })
    '';
  };
}
