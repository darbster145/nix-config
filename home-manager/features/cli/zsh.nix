{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # General utility aliases (tool-specific aliases are in their respective feature modules)
    shellAliases = {
      tm = "trash";
      ts = "tailscale";
      ff = "fastfetch";
    };

    initContent = ''
      # Start tmux on terminal startup
      if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        exec tmux
      fi
    '';
  };
}
