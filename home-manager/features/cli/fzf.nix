let
  palette = import ../hyprland/palette.nix;
in
{
  # Keybindings: Ctrl+R (history), Ctrl+T (insert file path), Alt+C (cd into dir)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    # Needed by sesh; inside tmux, fzf opens in a popup
    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = [ "-p 80%,60%" ];
    };

    defaultCommand = "fd --type f --hidden --exclude .git";
    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
    ];

    # Tokyo Night; background left unset so it matches the terminal
    colors = with palette; {
      fg = fg;
      "fg+" = fg;
      "bg+" = bgHighlight;
      hl = cyan;
      "hl+" = cyan;
      info = comment;
      border = border;
      separator = border;
      scrollbar = border;
      prompt = blue;
      pointer = magenta;
      marker = magenta;
      spinner = magenta;
      header = yellow;
      gutter = "-1";
    };

    fileWidget = {
      command = "fd --type f --hidden --exclude .git";
      options = [ "--preview 'bat --color=always --style=numbers --line-range=:200 {}'" ];
    };

    changeDirWidget = {
      command = "fd --type d --hidden --exclude .git";
      options = [ "--preview 'ls -la --color=always {}'" ];
    };

    historyWidget.options = [
      "--preview 'echo {}'"
      "--preview-window=down:3:wrap"
    ];
  };
}
