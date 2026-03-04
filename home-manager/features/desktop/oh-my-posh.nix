{
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      version = 3;
      final_space = true;

      palette = {
        blue = "#89B4FA";
        closer = "p:os";
        lavender = "#B4BEFE";
        os = "#ACB0BE";
        pink = "#F5C2E7";
      };

      blocks = [
        {
          type = "prompt";
          alignment = "left";
          segments = [
            {
              template = "{{.Icon}} ";
              foreground = "p:os";
              type = "os";
              style = "plain";
              properties = {
                cache_duration = "none";
              };
            }
            {
              template = "{{ .UserName }}@{{ .HostName }} ";
              foreground = "p:blue";
              type = "session";
              style = "plain";
              properties = {
                cache_duration = "none";
              };
            }
            {
              template = "{{ .Path }} ";
              foreground = "p:pink";
              type = "path";
              style = "plain";
              properties = {
                cache_duration = "none";
                folder_icon = "....";
                home_icon = "~";
                style = "agnoster_short";
              };
            }
            {
              template = "{{ .HEAD }} ";
              foreground = "p:lavender";
              type = "git";
              style = "plain";
              properties = {
                branch_icon = " ";
                cache_duration = "none";
                cherry_pick_icon = " ";
                commit_icon = " ";
                fetch_status = false;
                fetch_upstream_icon = false;
                merge_icon = " ";
                no_commits_icon = " ";
                rebase_icon = " ";
                revert_icon = " ";
                tag_icon = " ";
              };
            }
            {
              template = "";
              foreground = "p:closer";
              type = "text";
              style = "plain";
              properties = {
                cache_duration = "none";
              };
            }
          ];
        }
      ];
    };
  };
}

