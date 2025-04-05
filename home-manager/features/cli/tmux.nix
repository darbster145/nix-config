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
    '';
  };
}
