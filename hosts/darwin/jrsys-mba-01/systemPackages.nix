{ inputs, config, pkgs, ... }:

{
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    neovim
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
    swift-quit
    bartender
    aerospace
    inputs.zen-browser-darwin.packages."${system}"
    zed-editor
    firefox-unwrapped
    yazi
    tmux
    nix-tree
    speedtest-cli
    kubectl
    k9s
    kubernetes-helm
    helmfile
    kanata-with-cmd
  ];
}
