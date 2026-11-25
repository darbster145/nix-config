{ pkgs, config, ... }:

{
  imports = [ ./k9s.nix ];

  home.packages = with pkgs; [
    kubectl
    radar-bin
    radar-desktop-bin
    kubernetes-helm
    helmfile
    talosctl
    infisical
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
