{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./gnome.nix
    ./iscsi.nix
    ../features/fonts.nix
    ../features/hyprland.nix
    ./ollama.nix
  ];

  boot.initrd.kernelModules = [
    "amdgpu"
  ];
  boot.kernelParams = [
    "acpi_enforce_resources=lax"
    "acpi_backlight=video"
    "acpi_backlight=vendor"
    "acpi_backlight=native"
    # Needed for LACT AMDGPU Overclocking Support
    "amdgpu.ppfeaturemask=0xffffffff"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [
    "iscsi_tcp"
    "it87"
    "coretemp"
    "amdgpu"
  ];
  boot.extraModprobeConfig = ''
    options it87 force_id=0x8689
  '';
  boot.extraModulePackages = with config.boot.kernelPackages; [
    it87
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  nix.optimise.automatic = true;

  # Bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    systemd-boot = {
      enable = true;
      #edk2-uefi-shell.enable = true;
      windows = {
        windows11 = {
          title = "Windows 11";
          efiDeviceHandle = "HD1b";
          sortKey = "z_windows";
        };
      };
    };
  };

  nix.settings.trusted-users = [ "root" "brad" "nixremote" ]; # Replace with your username

  nix.settings.sandbox = true;

  boot.supportedFilesystems = [ "ntfs" ];

  zramSwap.enable = true;

  #powerManagement.enable = true;

  networking.hostName = "brixos";
  networking.interfaces.enp16s0.wakeOnLan = {
    enable = true;
    policy = [ "magic" ];
  };

  networking.networkmanager.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      libva
      libvdpau-va-gl
      mesa
      vaapiVdpau
      mesa.opencl
    ];
  };

  time.timeZone = "America/Denver";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Tailscale
  #services.tailscale = {
  #  enable = true;
  # useRoutingFeatures = "both";
  #};

  # Enable Sunshine
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable QMK and VIA
  hardware.keyboard.qmk.enable = true;
  services.udev.packages = [ pkgs.via ];

  services.openiscsi = {
    enable = true; # Enable openiscsi daemon
    name = "iqn.2024-09.com.nixos:my-nixos-initiator"; # Set your iSCSI initiator name
    discoverPortal = "10.0.0.3";
  };

  # LACT systemd service
  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };


  users.users.brad = {
    isNormalUser = true;
    description = "Brad";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  services.teamviewer.enable = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/brad/.steam/root/compatibilitytools.d";
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #inputs.ghostty.packages.x86_64-linux.default
    ghostty
    azuredatastudio
    kubectl
    rustup
    unrar
    obsidian
    sshfs
    amarok
    nodejs
    wget
    curl
    git
    yazi
    cargo
    fastfetch
    inputs.zen-browser.packages."${system}".default
    chromium
    gcc
    htop
    dnsutils
    btop
    linuxKernel.packages.linux_6_6.it87
    lm_sensors
    dunst
    openiscsi
    stow
    pkgs.gnome-tweaks
    signal-desktop
    zoxide
    oh-my-posh
    fzf
    discord
    bat
    tldr
    pay-respects
    lutris
    adwaita-icon-theme
    mangohud
    goverlay
    protonup
    bottles
    heroic
    trash-cli
    papirus-icon-theme
    openrgb-with-all-plugins
    gearlever
    libreoffice
    lact
    via
    barrier
    mpv
    adoptopenjdk-icedtea-web
    bitwarden
    zed-editor
    home-manager
    kubectl
    k9s
    pciutils
    amdgpu_top
    nethogs
    wirelesstools
    iotop
    gtop
    # Hyprland DE Packages
    xdg-desktop-portal-hyprland
    kdePackages.xwaylandvideobridge # Needed to screenshare xwayland programs
    hyprpolkitagent
    hyprcursor
    hyprsunset
    wlogout
    waybar
    dunst
    udiskie # Auto Mount USB
    wl-clipboard
    rofi-wayland
    hyprpaper
    waypaper # GUI fontend for hyprpaper, swww, etc
    nwg-dock
    playerctl
    zathura
    banana-cursor
    #davinci-resolve
  ];

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      tumbler
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };

  # Enable Appimages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.hardware.openrgb.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    allowSFTP = true;
  };

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ 11987 47989 ];
  #networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # DO NOT CHANGE
  system.stateVersion = "24.11";

  programs.coolercontrol.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
      workstation = true;
      addresses = true;
      hinfo = true;
    };
  };

  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
    openFirewall = true;
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;


  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
