{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Shared between open terminals; commands starting with a space are not saved.
    history = {
      size = 100000;
      save = 100000;
      extended = true;
      share = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

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
