{ inputs, pkgs, config, ...}:

{
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    firefox-devedition
    kitty
    htop
    fastfetch
    btop
    signal-desktop
    appimage-run
    stow
    oh-my-posh
    gcc
    firefox
    bitwarden
    inputs.zen-browser.packages.${pkgs.system}.default
    asahi-bless
    asahi-nvram
    asahi-btsync
    asahi-wifisync
    protonvpn-gui
    thunderbird
    gearlever
    youtube-music
    wofi
    jellyfin-media-player
    remmina
    openconnect
    openconnect_openssl
    lazygit
    tmux
    ungoogled-chromium
    youtube-music
    box64
    adoptopenjdk-icedtea-web
    _1password-gui-beta
    _1password-cli
    nix-prefetch
    adoptopenjdk-icedtea-web
    wireguard-tools
    libreoffice
    cargo
    yakuake
    teams-for-linux
    tangram

    # Hyperland Programs
    waybar
    brightnessctl
    pavucontrol
    wlogout

  ];
}
