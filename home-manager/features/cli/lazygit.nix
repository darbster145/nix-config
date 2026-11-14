{
  # `lg` opens lazygit and cds into the repo you were in when you quit
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      git.diffRenderers = [ { command = "delta --{{colorScheme}} --paging=never"; } ];
    };
  };
}
