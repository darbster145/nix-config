{ inputs, config, pkgs, ... }:

{
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    neovim
    ripgrep
    nixos-rebuild
    zsh
    sshfs
    macfuse-stubs
    home-manager
    tldr
    tmux
    fastfetch
    unzip
    zoxide
    fzf
    speedtest-cli
    stow
    htop
    oh-my-posh
    powershell
    cargo
    mkalias
    raycast
    slack
    nmap
    aerospace
    yazi
    nix-tree
    speedtest-cli
    kubectl
    talosctl
    k9s
    kubernetes-helm
    helmfile
    kanata-with-cmd
    bitwarden-desktop
  ];
}
