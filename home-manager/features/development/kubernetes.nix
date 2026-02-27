{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kubectl
    k9s
    kubernetes-helm
    helmfile
    talosctl
    fluxcd
  ];
}
