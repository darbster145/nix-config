{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      #nn = "nvim ~/.config/nix-config/hosts/nixos/nixi/configuration.nix";
      nf = "nvim ~/.config/nix-config/flake.nix";
      #nr = "sudo nixos-rebuild switch --flake ~/.config/nix-config/flake.nix --impure";
      cd = "z";
      tm = "trash";

      nn = "nvim $HOME/.config/nix-config/hosts/darwin/jrsys-mba-01/configuration.nix";
      nr = "darwin-rebuild switch --flake $HOME/.config/nix-config/";
      vmstop = "vmrun stop ~/.vms/Other\ Linux\ 6.x\ kernel\ 64-bit\ Arm\ 2.vmwarevm nogui";
      vmstart = "vmrun start ~/.vms/Other\ Linux\ 6.x\ kernel\ 64-bit\ Arm\ 2.vmwarevm nogui";
    };

    initExtra = ''
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
