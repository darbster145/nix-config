{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    #shell = "/bin/zsh";

    plugins = with pkgs.tmuxPlugins; [
      tokyo-night-tmux
      mode-indicator
      weather
      fuzzback
      net-speed
    ];

    extraConfig = ''
      unbind -T root C-l

      # Open new tab at current directory
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };
}
