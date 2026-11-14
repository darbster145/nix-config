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

      # Popups (fzf, sesh) use the terminal background instead of grey
      set -g popup-style "bg=default"
      set -g popup-border-lines rounded
    '';
  };

  # prefix + T: fuzzy pick a tmux session or zoxide folder to open/attach
  programs.sesh = {
    enable = true;
    enableTmuxIntegration = true;
    tmuxKey = "T";
  };
}
