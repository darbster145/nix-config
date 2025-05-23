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
  boot.kernelModules = [ "iscsi_tcp" 
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

  boot.blacklistedKernelModules = [ "kvm_amd" "kvm" ];

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

  nix.settings.trusted-users = [ "root" "brad" ]; # Replace with your username

  nix.settings.sandbox = true;

  systemd.tpm2.enable = false;

  boot.supportedFilesystems = [ "ntfs" ];

  #virtualisation.virtualbox.host.enable = true;
  #users.extraGroups.vboxusers.members = [ "brad" ];
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  #virtualisation.virtualbox.host.addNetworkInterface = true;

  #virtualisation.vmware.host.enable = true;

  environment.etc."vbox/networks.conf".text = ''
    * 192.168.0.0/16
  '';

  virtualisation.libvirtd.enable = false;

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
  services.tailscale.enable = true;

  # Enable Sunshine
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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
    extraGroups = [ "networkmanager" "wheel" "video" "vboxusers" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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
    inputs.ghostty.packages.x86_64-linux.default
    torzu
    amarok
    nodejs
    wget
    curl
    git
    yazi
    cargo
    _1password-gui-beta
    _1password-cli
    thunderbird
    fastfetch
    inputs.zen-browser.packages."${system}".default
    chromium
    gcc
    htop
    btop
    coolercontrol.coolercontrol-gui
    linuxKernel.packages.linux_6_6.it87
    coolercontrol.coolercontrold
    coolercontrol.coolercontrol-liqctld
    coolercontrol.coolercontrol-ui-data
    lm_sensors
    kitty
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
    thefuck
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
    teams-for-linux
    jellyfin-media-player
    #linuxKernel.packages.linux_6_11.it87
    tangram
    libreoffice
    lact
    via
    barrier
    input-leap
    gnome-remote-desktop
    mpv
    adoptopenjdk-icedtea-web
    bitwarden
    zed-editor
    home-manager

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
    hashcat
  ];

  programs.light.enable = true;

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
  services.openssh.enable = true;

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ ... ];
  #networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # DO NOT CHANGE
  system.stateVersion = "24.11";

  programs.coolercontrol.enable = true;

  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;

  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
    openFirewall = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
