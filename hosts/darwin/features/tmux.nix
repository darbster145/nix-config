{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    enableMouse = true;
    enableSensible = true;
    enableVim = true;
    #baseIndex = 1;
    #clock24 = true;
    # plugins = with pkgs.tmuxPlugins; [
    #   tokyo-night-tmux
    #   mode-indicator
    #   fuzzback
    #   net-speed
    # ];
  };
}
