{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      cd = "z";
      tm = "trash";
      vmstop = "vmrun stop ~/.vms/Other\ Linux\ 6.x\ kernel\ 64-bit\ Arm\ 2.vmwarevm nogui";
      vmstart = "vmrun start ~/.vms/Other\ Linux\ 6.x\ kernel\ 64-bit\ Arm\ 2.vmwarevm nogui";
      ts = "tailscale";

      # Git Aliases
      gs = "git status --short";
      ga = "git add .";
      gd = "git diff";
      gc = "git commit";
      gcl = "git clone";
      gp = "git pull";
      gu = "git push";
      gl = "git log";
      gb = "git branch";
      gi = "git init";
      # Kubernetes Aliases
      k = "kubectl";
      k9 = "k9s";
      h = "helm";
      hf = "helmfile";
    };

    initContent = ''
            # Initialize oh-my-posh
            eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/base.toml)"

            # Initialize zoxide
            eval "$(zoxide init zsh)"

            # Yazi change directory on exit
            function y() {
      	      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      	      yazi "$@" --cwd-file="$tmp"
      	      if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      		builtin cd -- "$cwd"
      	      fi
      	      rm -f -- "$tmp"
            }

            # Start tmux on terminal startup
            if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
              exec tmux
            fi

            fastfetch
    '';
  };
}
