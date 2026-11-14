{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$os$username$hostname$directory$git_branch$git_commit$cmd_duration$status";
      palette = "tokyo_night";

      palettes.tokyo_night = {
        foreground = "#c0caf5";
        blue = "#7aa2f7";
        magenta = "#bb9af7";
        cyan = "#7dcfff";
      };

      os = {
        disabled = false;
        format = "[$symbol]($style)";
        style = "foreground";
        symbols = {
          Macos = " ";
          NixOS = " ";
          Linux = " ";
        };
      };

      username = {
        show_always = true;
        format = "[$user@]($style)";
        style_user = "blue";
        style_root = "blue";
      };

      hostname = {
        ssh_only = false;
        format = "[$hostname]($style) ";
        style = "blue";
      };

      directory = {
        format = "[$path]($style) ";
        style = "magenta";
        home_symbol = "~";
        truncation_length = 1;
        truncation_symbol = "..../";
        truncate_to_repo = false;
      };

      git_branch = {
        format = "[$branch]($style) ";
        style = "cyan";
        only_attached = true;
      };

      git_commit = {
        format = "[$hash]($style) ";
        style = "cyan";
        only_detached = true;
      };

      # Shown when a command takes 2s or longer
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "foreground";
        min_time = 2000;
      };

      # Exit code of the last command, only when it failed
      status = {
        disabled = false;
        format = "[$status]($style) ";
        style = "red";
      };
    };
  };
}
