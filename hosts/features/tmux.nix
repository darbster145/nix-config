{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      tokyo-night-tmux
      mode-indicator
      sensible
      weather
      fuzzback
      net-speed
    ];
  };
}
