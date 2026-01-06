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
    fira-code
    htop
    oh-my-posh
    spacebar
    powershell
    cargo
    mkalias
    raycast
    slack
    nmap
    aerospace
    yazi
    tmux
    nix-tree
    speedtest-cli
    kubectl
    talosctl
    k9s
    kubernetes-helm
    helmfile
    kanata-with-cmd
    bitwarden-desktop
    lazygit
    wireshark
    lunar
    fluxcd
    utm
    podman-desktop
    python3
  ];

}
