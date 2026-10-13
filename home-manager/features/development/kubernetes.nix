{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    kubectl
    radar-bin
    k9s
    kubernetes-helm
    helmfile
    talosctl
    fluxcd
    argocd
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
