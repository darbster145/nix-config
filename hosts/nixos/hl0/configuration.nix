{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # ./jellyfin.nix
    # ./nextcloud.nix
    # ./unifi.nix
    # ./proxmox.nix
  ];

  # Kernel and modules
  boot.kernelParams = [ "i915.enable_guc=3" ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_blk" "virtio_scsi" "virtio_net" ];

  boot.kernelModules = [ ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      intel-compute-runtime
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.enableRedistributableFirmware = true;

  services.qemuGuest.enable = true;

  # Mounts for your NFS shares
  fileSystems."/mnt/immich/library" = {
    device = "10.0.0.3:/mnt/notonedrive/docker-volumes/immich/library";
    fsType = "nfs";
  };
  fileSystems."/mnt/immich/postgres" = {
    device = "10.0.0.3:/mnt/gofast/docker-volumes/immich/postgres";
    fsType = "nfs";
  };

  fileSystems."/mnt/gofast/docker-volumes" = {
    device = "10.0.0.3:/mnt/gofast/docker-volumes";
    fsType = "nfs";
  };

  fileSystems."/mnt/notonedrive/docker-volumes" = {
    device = "10.0.0.3:/mnt/notonedrive/docker-volumes";
    fsType = "nfs";
  };

  fileSystems."/mnt/notonedrive/media" = {
    device = "10.0.0.3:/mnt/notonedrive/media";
    fsType = "nfs";
  };

  zramSwap.enable = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname and networking
  networking.hostName = "hl0";
  networking.networkmanager.enable = true;

  # Time and locale
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # User
  users.users.darbster = {
    isNormalUser = true;
    description = "darbster";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    neovim
    docker-compose
    fastfetch
    htop
    btop
    git
    clinfo
    iptables
    iproute2
    intel-gpu-tools
  ];

  # Services
  services.openssh.enable = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  services.fail2ban = {
    enable = true;
  };

  # Auto updates
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # Firewall (disabled, but open specific ports if re-enabled later)
  networking.firewall.allowedTCPPorts = [ 19999 443 80 7777 ];
  networking.firewall.allowedUDPPorts = [ 7777 ];
  networking.firewall.enable = false;

  # State version (don’t change)
  system.stateVersion = "24.05";

  # Enable flakes and the new CLI
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

