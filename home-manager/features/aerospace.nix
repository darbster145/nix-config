{
  programs.aerospace = {
    enable = true;
    launchd = {
      enable = true;
      keepAlive = true;
    };
    settings = {
      after-login-command = [ ];
      after-startup-command = [ ];
      start-at-login = true;

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";

      key-mapping.preset = "qwerty";

      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      on-focus-changed = "move-mouse window-lazy-center";

      workspace-to-monitor-force-assignment = {
        "1" = 2;
        "10" = 2;
        "9" = 2;
      };

      gaps = {
        inner.horizontal = 10;
        inner.vertical = 10;
        outer.left = 10;
        outer.bottom = 10;
        outer.top = 10;
        outer.right = 10;
      };

      mode.main.binding = {
        cmd-slash = "layout tiles horizontal vertical";
        cmd-comma = "layout accordion horizontal vertical";

        cmd-h = "focus left";
        cmd-j = "focus down";
        cmd-k = "focus up";
        cmd-l = "focus right";

        cmd-shift-h = "move left";
        cmd-shift-j = "move down";
        cmd-shift-k = "move up";
        cmd-shift-l = "move right";

        cmd-shift-minus = "resize smart -50";
        cmd-shift-equal = "resize smart +50";

        cmd-1 = "workspace 1";
        cmd-2 = "workspace 2";
        cmd-3 = "workspace 3";
        cmd-4 = "workspace 4";
        cmd-5 = "workspace 5";
        cmd-6 = "workspace 6";
        cmd-7 = "workspace 7";
        cmd-8 = "workspace 8";
        cmd-9 = "workspace 9";
        cmd-0 = "workspace 10";

        cmd-shift-1 = "move-node-to-workspace 1";
        cmd-shift-2 = "move-node-to-workspace 2";
        cmd-shift-3 = "move-node-to-workspace 3";
        cmd-shift-4 = "move-node-to-workspace 4";
        cmd-shift-5 = "move-node-to-workspace 5";
        cmd-shift-6 = "move-node-to-workspace 6";
        cmd-shift-7 = "move-node-to-workspace 7";
        cmd-shift-8 = "move-node-to-workspace 8";
        cmd-shift-9 = "move-node-to-workspace 9";
        cmd-shift-0 = "move-node-to-workspace 10";

        cmd-tab = "workspace-back-and-forth";
        cmd-shift-tab = "move-workspace-to-monitor --wrap-around next";

        cmd-shift-semicolon = "mode service";
      };

      mode.service.binding = {
        esc = [ "reload-config" "mode main" ];
        r = [ "flatten-workspace-tree" "mode main" ];
        f = [ "layout floating tiling" "mode main" ];
        backspace = [ "close-all-windows-but-current" "mode main" ];

        cmd-shift-h = [ "join-with left" "mode main" ];
        cmd-shift-j = [ "join-with down" "mode main" ];
        cmd-shift-k = [ "join-with up" "mode main" ];
        cmd-shift-l = [ "join-with right" "mode main" ];
      };
    };
  };
}
