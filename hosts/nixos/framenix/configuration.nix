{ lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../features/kanata.nix
    ../features/hyprland.nix
    ../features/fonts.nix
    ../features/remote-builders.nix
  ];

  # Keep nixi's key mappings, using the Framework internal keyboard.
  services.kanata.keyboards.internalKeyboard.devices = lib.mkForce [
    "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };
  programs.virt-manager.enable = true;
  programs.droidcam.enable = true;
  boot.kernel.sysctl."vm.mmap_rnd_bits" = 31;

  services.fwupd.enable = true;

  services.teamviewer.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ libva mesa libdrm ];
  };
  services.logind.settings.Login.HandlePowerKey = "ignore";

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  services.libinput.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };
  services.openssh = {
    enable = true;
    openFirewall = true;
  };
  networking.firewall.enable = true;

  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;
  programs.kdeconnect.enable = true;
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_testing;

  networking.hostName = "framenix";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.brad = {
    isNormalUser = true;
    description = "Brad";
    extraGroups = [ "wheel" "networkmanager" "video" "render" "libvirtd" ];
    shell = pkgs.zsh;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    btop
    fastfetch
    trashy
    android-tools
    widevine-cdm
    appimage-run
    gcc
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
    webcamoid
  ];

  # The swapfile is encrypted by the underlying LUKS container.
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024; # MiB
  }];

  zramSwap.enable = false;
  boot.zswap = {
    enable = true;
    compressor = "zstd";
    maxPoolPercent = 20;
  };

  # Keep ordinary suspend available; disable hibernation.
  boot.kernelParams = [ "nohibernate" ];

  system.stateVersion = "26.05";
}
