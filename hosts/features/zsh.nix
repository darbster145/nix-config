{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      nn = "nvim ~/.config/nix-config/hosts/nixos/nixi/configuration.nix";
      nf = "nvim ~/.config/nix-config/flake.nix";
      nr = "sudo nixos-rebuild switch --flake ~/.config/nix-config/flake.nix --impure";
      cd = "z";
      tm = "trash";
    };
  };
}
