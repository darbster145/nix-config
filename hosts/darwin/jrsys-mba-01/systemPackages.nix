{ inputs, config, pkgs, ... }:

{
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    neovim
    zsh
    home-manager
    tldr
    tmux
    fastfetch
    ranger
    thefuck
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
    kitty
    mkalias
    raycast
    slack
    nmap
    swift-quit
    wireguard-tools
    wireguard-go
    youtube-music
    shortcat
    bartender
    aerospace
    arc-browser
    inputs.zen-browser-darwin.packages."${system}"
    zed-editor
    firefox-devedition-unwrapped
    #ghostty
    yazi
    tmux
  ];
}
