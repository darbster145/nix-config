{ inputs, config, pkgs, ... }:

{
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
    disk-inventory-x
    remmina
    zoxide
    fzf
    speedtest-cli
    stow
    btop
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
    #podman-desktop
    python3
    inputs.self.packages.${pkgs.system}.freelens-bin
    macfuse-stubs
    ghostty-bin
    ###google-chrome
    zenmap
  ];

  programs._1password = {
    enable = true;
  };
  programs._1password-gui = {
    package = pkgs._1password-ui-beta;
  };

}
