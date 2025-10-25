{ pkgs, config, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    utm
    tldr
    google-chrome
    zoxide
    fastfetch
    lazygit
    raycast
    htop
    ripgrep
    btop
    ripgrep
    fd
    fzf
    ranger
    stow
    oh-my-posh
    aldente
    aerospace
    inputs.zen-browser.packages."${system}".default
    firefox-unwrapped
    kubectl
    kubernetes-helm
    helmfile
    k9s
  ];
}
