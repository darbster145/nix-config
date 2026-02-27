{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;
    settings = {

      shell-integration = "detect";
      confirm-close-surface = true;

      ### Theme ###
      theme = "TokyoNight";

      ### Fonts ###
      font-family = "FiraMono Nerd Font Mono";
      font-size = 16;

      ### Blur & Transparency ###
      #background-opacity = .95
      #background-blur = 50

    };
  };
}

