{ config, lib, pkgs, apple-silicon, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../features/kanata.nix
      ../features/hyprland.nix
      ../features/fonts.nix
      #../brixos/gnome.nix
    ];

  boot.kernelParams = [ "apple_dcp.show_notch=1" ];

  nix.settings = {
    extra-substituters = [
      "https://nixos-apple-silicon.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
    ];
  };

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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      libva
      libdrm
    ];
  };

  # services.logind.settings.Login = ''
  #   # don’t shutdown when power button is short-pressed
  #   HandlePowerKey=ignore
  # '';

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  #  Enable Gnome
  services.xserver.displayManager.gdm.enable = true;

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable tailscale
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brad = {
    isNormalUser = true;
    description = "Brad";
    extraGroups = [ "wheel" "video" "render" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.allowUnsupportedSystem = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    trashy
    legcord
    libreoffice
    home-manager
    widevine-cdm
    zoxide
    wget
    git
    nix-tree
    yazi
    ghostty
    unzip
    htop
    fastfetch
    btop
    signal-desktop
    appimage-run
    stow
    oh-my-posh
    gcc
    bitwarden-desktop
    inputs.zen-browser.packages.${pkgs.system}.default
    asahi-bless
    asahi-nvram
    asahi-btsync
    asahi-wifisync
    #protonvpn-gui
    thunderbird
    gearlever
    youtube-music
    remmina
    openconnect
    openconnect_openssl
    lazygit
    tmux
    ungoogled-chromium
    firefox-bin
    nix-prefetch
    adoptopenjdk-icedtea-web
    nix-tree
    #libreoffice
    bc
    jq
    kubectl
    k9s
    kubernetes-helm
    helmfile
    talosctl
    inputs.self.packages.${pkgs.system}.freelens-bin
    blueman
    banana-cursor
    obsidian
  ];

  # Enable Appimages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

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
