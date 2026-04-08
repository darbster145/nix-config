{

  programs.ashell = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };

    settings = {
      position = "Top";
      enable_esc_key = true;
      log_level = "debug";

      modules = {
        left = [
          "Workspaces"
          "Tray"
        ];
        center = [
          "Window Title"
          "Clock"
        ];
        right = [
          "MediaPlayer"
          "SystemInfo"
          [
            "Privacy"
            "Settings"
          ]
        ];
      };

      workspaces = {
        visibilityMode = "MonitorSpecific";
        max_workspaces = 10;
        enable_workspace_filling = true;
      };

      media_player = {
        max_title_length = 20;
      };

      system_info = {
        indicators = [ "Cpu" "Memory" "UploadSpeed" "DownloadSpeed" ];
        interval = 5;
      };

      clock = {
        format = "%d %H:%M:%S";
      };

      appearance = {
        font_name = "FiraCode Mono";
        style = "Islands";

        # Tokyo Night Theme #
        primary_color = "#7aa2f7";
        success_color = "#9ece6a";
        text_color = "#a9b1d6";
        workspace_colors = [ "#7aa2f7" "#9ece6a" ];
        danger_color = {
          base = "#f7768e";
          weak = "#e0af68";
        };
        background_color = {
          base = "#1a1b26";
          weak = "#24273a";
          strong = "#414868";
        };
        secondary_color = {
          base = "#0c0d14";
        };
      };
    };
  };

}
