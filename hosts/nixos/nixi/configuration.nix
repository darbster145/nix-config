{ config, lib, pkgs, apple-silicon, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../features/kanata.nix
      ../features/remoteBuilders.nix
      ../features/hyprland.nix
      ../../features/zsh.nix
      ../../features/tmux.nix
    ];


  boot.kernelParams = [ "apple_dcp.show_notch=1" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="macsmc-battery", ATTR{charge_control_end_threshold}="80"
  '';

  # Use the grub EFI boot loader.
  boot.loader.grub = {
    enable = true;
    useOSProber = false;
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = false;

  # Enable zram swap
  zramSwap.enable = true;

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  # Auto optimize the nix store
  nix.optimise.automatic = true;

  # Auto Garbage Collect
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  networking = {
    hostName = "nixi";
    networkmanager = {
      enable = true;
    };
  };

  # Set your time zone.
  time.timeZone = "America/Denver";

  # enable GPU support and audio
  hardware.asahi = {
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    setupAsahiSound = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable KDE6
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;

  #  Enable Gnome
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome = {
  #   enable = true;
  #   extraGSettingsOverridePackages = [ pkgs.mutter ];
  #   extraGSettingsOverrides = ''
  #     [org.gnome.mutter]
  #     experimental-features=['scale-monitor-framebuffer']
  #   '';
  # };


  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable tailscale
  services.tailscale.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brad = {
    isNormalUser = true;
    description = "Brad";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.allowUnsupportedSystem = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    trashy
    zoxide
    wget
    moonlight-qt
    git
    nix-tree
    yazi
    ghostty
    unzip
    #inputs.ghostty.packages.aarch64-linux.default
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
    jellyfin-media-player
    remmina
    openconnect
    openconnect_openssl
    lazygit
    tmux
    ungoogled-chromium
    youtube-music
    adoptopenjdk-icedtea-web
    nix-prefetch
    adoptopenjdk-icedtea-web
    nix-tree
    #libreoffice
    bc
    jq
  ];

  # Enable Appimages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts._3270
    nerd-fonts.agave
    nerd-fonts.anonymice
    nerd-fonts.arimo
    nerd-fonts.aurulent-sans-mono
    nerd-fonts.bigblue-terminal
    nerd-fonts.bitstream-vera-sans-mono
    nerd-fonts.blex-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.code-new-roman
    nerd-fonts.comic-shanns-mono
    nerd-fonts.commit-mono
    nerd-fonts.cousine
    nerd-fonts.d2coding
    nerd-fonts.daddy-time-mono
    nerd-fonts.departure-mono
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.envy-code-r
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.geist-mono
    nerd-fonts.go-mono
    nerd-fonts.gohufont
    nerd-fonts.hack
    nerd-fonts.hasklug
    nerd-fonts.heavy-data
    nerd-fonts.hurmit
    nerd-fonts.im-writing
    nerd-fonts.inconsolata
    nerd-fonts.inconsolata-go
    nerd-fonts.inconsolata-lgc
    nerd-fonts.intone-mono
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.iosevka-term-slab
    nerd-fonts.jetbrains-mono
    nerd-fonts.lekton
    nerd-fonts.liberation
    nerd-fonts.lilex
    nerd-fonts.martian-mono
    nerd-fonts.meslo-lg
    nerd-fonts.monaspace
    nerd-fonts.monofur
    nerd-fonts.monoid
    nerd-fonts.mononoki
    nerd-fonts.mplus
    nerd-fonts.noto
    nerd-fonts.open-dyslexic
    nerd-fonts.overpass
    nerd-fonts.profont
    nerd-fonts.proggy-clean-tt
    nerd-fonts.recursive-mono
    nerd-fonts.roboto-mono
    nerd-fonts.shure-tech-mono
    nerd-fonts.sauce-code-pro
    nerd-fonts.space-mono
    nerd-fonts.symbols-only
    nerd-fonts.terminess-ttf
    nerd-fonts.tinos
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu-sans
    nerd-fonts.victor-mono
    nerd-fonts.zed-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # SSH 
  services.openssh.enable = true;

  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ ... ];
    # allowedUDPPorts = [ ... ];
  };

  # DO NOT CHANGE
  system.stateVersion = "24.11";

  # Enable nix experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
