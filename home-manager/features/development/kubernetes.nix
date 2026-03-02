{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    kubectl
    k9s
    kubernetes-helm
    helmfile
    talosctl
    fluxcd
  ];

  programs.zsh = {
    shellAliases = {
      k = "kubectl";
      k9 = "k9s";
      h = "helm";
      hf = "helmfile";
      t = "talosctl";
    };
  };
}
