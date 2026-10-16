{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../features/common.nix
  ];

  hardware.enableRedistributableFirmware = true;

  services.qemuGuest.enable = true;

  # Mounts for your NFS shares
  fileSystems."/mnt/immich/library" = {
    device = "10.0.0.3:/mnt/notonedrive/docker-volumes/immich/library";
    fsType = "nfs4";
    options = [
      "_netdev"
      "nofail"
      "x-systemd.automount"
    ];
  };
  fileSystems."/mnt/immich/postgres" = {
    device = "10.0.0.3:/mnt/gofast/docker-volumes/immich/postgres";
    fsType = "nfs4";
    options = [
      "_netdev"
      "nofail"
      "x-systemd.automount"
    ];
  };

  fileSystems."/mnt/gofast/docker-volumes" = {
    device = "10.0.0.3:/mnt/gofast/docker-volumes";
    fsType = "nfs4";
    options = [
      "_netdev"
      "nofail"
      "x-systemd.automount"
    ];
  };

  fileSystems."/mnt/notonedrive/docker-volumes" = {
    device = "10.0.0.3:/mnt/notonedrive/docker-volumes";
    fsType = "nfs4";
    options = [
      "_netdev"
      "nofail"
      "x-systemd.automount"
    ];
  };

  fileSystems."/mnt/notonedrive/media" = {
    device = "10.0.0.3:/mnt/notonedrive/media";
    fsType = "nfs4";
    options = [
      "_netdev"
      "nofail"
      "x-systemd.automount"
    ];
  };

  zramSwap.enable = true;

  # Server keeps generations longer but collects more often than the default.
  nix.gc = {
    dates = "daily";
    options = "--delete-older-than 30d";
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname and networking
  networking.hostName = "hl0";
  networking.networkmanager.enable = true;

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # User
  users.users.darbster = {
    isNormalUser = true;
    description = "darbster";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    neovim
    docker-compose
    fastfetch
    htop
    btop
    git
    iptables
    iproute2
    infisical
  ];

  # Services
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
  };

  # Auto updates
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # Firewall (disabled)
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [
      19999
      443
      80
      7777
    ];
    allowedUDPPorts = [
      7777
    ];
  };

  # State version (don’t change)
  system.stateVersion = "24.05";
}
