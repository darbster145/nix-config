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
    ranger
    unzip
    zoxide
    fzf
    speedtest-cli
    stow
    fira-code
    htop
    btop
    oh-my-posh
    spacebar
    powershell
    cargo
    mkalias
    raycast
    slack
    nmap
    swift-quit
    youtube-music
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
