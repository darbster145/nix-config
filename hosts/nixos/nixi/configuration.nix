{ config, lib, pkgs, apple-silicon, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../features/kanata.nix
      ../features/hyprland.nix
      ../features/fonts.nix
      #../brixos/gnome.nix
      ./virtualization.nix
    ];

  boot.kernelParams = [ "appledrm.show_notch=1" ];

  # boot.kernelPackages = lib.mkForce pkgs.linux-asahi-fairydust;

  boot.kernel.sysctl."vm.mmap_rnd_bits" = 31;

  hardware.asahi.extractPeripheralFirmware = true;

  nix.settings = {
    extra-substituters = [
      "https://nixos-apple-silicon.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
    ];
  };

  #services.udev.extraRules = ''
  #  SUBSYSTEM=="power_supply", KERNEL=="macsmc-battery", ATTR{charge_control_end_threshold}="80"
  #'';

  # Use the grub EFI boot loader.
  boot.loader.grub = {
    enable = true;
    useOSProber = false;
    device = "nodev";
  };

  boot.loader.efi.canTouchEfiVariables = false;
  
  services.displayManager.sddm.enable = true;

  services.desktopManager.plasma6.enable = true;

  services.xserver.displayManager.lightdm.enable = false;
  
  services.teamviewer.enable = true;
  # Enable zram swap
  zramSwap.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva
      mesa
      libdrm
    ];
  };

  services.logind.settings.Login = {
    # don’t shutdown when power button is short-pressed
    HandlePowerKey = "ignore";
  };

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

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  #services.printing.enable = true;

  services.libinput.enable = true;

  # Enable tailscale
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  users.users.brad = {
    isNormalUser = true;
    description = "Brad";
    extraGroups = [ "wheel" "video" "render" "libvirtd" ];
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
    home-manager
    widevine-cdm
    appimage-run
    gcc
    asahi-bless
    asahi-nvram
    asahi-btsync
    asahi-wifisync
    #protonvpn-gui
    thunderbird
    #pear-desktop
    ytermusic
    remmina
    openconnect
    openconnect_openssl
    ungoogled-chromium
    firefox-bin
    nix-prefetch
    adoptopenjdk-icedtea-web
    blueman
    banana-cursor
    inputs.self.packages.${pkgs.system}.freelens-bin
    inputs.claude-desktop.packages.${pkgs.system}.default
  ];

  # Enable Appimages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # SSH 
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

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
