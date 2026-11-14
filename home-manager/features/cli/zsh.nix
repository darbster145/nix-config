{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Ctrl+S/Ctrl+Q no longer pause terminal output.
    setOptions = [ "NO_FLOW_CONTROL" ];

    # General utility aliases (tool-specific aliases are in their respective feature modules)
    shellAliases = {
      tm = "trash";
      ts = "tailscale";
      ff = "fastfetch";
    };
  };
}
