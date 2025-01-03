{ inputs, config, pkgs, ... }:

{
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    neovim
    tldr
    tmux
    fastfetch
    ranger
    thefuck
    remmina
    #xquartz
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
    utm
    zoom-us
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
    #teams
  ];
}
