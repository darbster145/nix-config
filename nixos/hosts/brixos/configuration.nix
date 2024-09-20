# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./gnome.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "iscsi_tcp" ];

  # Bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  networking.hostName = "brixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr
      libva
      libvdpau-va-gl
    ];
  };

  # Set your time zone.
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

  # Hyprland
  programs.hyprland.enable = true;

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.openiscsi = {
    enable = true; # Enable openiscsi daemon
    name = "iqn.2024-09.com.nixos:my-nixos-initiator"; # Set your iSCSI initiator name
    discoverPortal = "10.0.0.3";
  };

  # Custom activation script to ensure iscsid is running and log in to the specific iSCSI target

  # Custom systemd service for logging in to a specific iSCSI target
  systemd.services.iscsi-login-lingames = {
    description = "Login to iSCSI target iqn.2005-10.org.freenas.ctl:lingames";
    after = [ "network.target" "iscsid.service" ];
    wants = [ "iscsid.service" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.openiscsi}/bin/iscsiadm -m discovery -t sendtargets -p 10.0.0.3";
      ExecStart = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2005-10.org.freenas.ctl:lingames -p 10.0.0.3 --login";
      ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T iqn.2005-10.org.freenas.ctl:lingames -p 10.0.0.3 --logout";
      Restart = "on-failure";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };

  fileSystems."/home/brad/Games" = {
    device = "/dev/disk/by-path/ip-10.0.0.3:3260-iscsi-iqn.2005-10.org.freenas.ctl:lingames-lun-0"; # Replace with the correct device path after iSCSI login
    fsType = "ext4"; # Or the correct filesystem type
    options = [ "_netdev" "nofail" ]; # Ensures network is up before mounting
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brad = {
    isNormalUser = true;
    description = "Brad";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/brad/.steam/root/compatibilitytools.d";
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    bitwarden
    thunderbird
    fastfetch
    inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
    inputs.zen-browser.packages."${system}".specific
    chromium
    gcc
    htop
    nvtopPackages.full
    btop
    #coolercontrol.coolercontrol-gui
    #linuxKernel.packages.linux_6_6.it87
    #coolercontrol.coolercontrold
    #coolercontrol.coolercontrol-liqctld
    #coolercontrol.coolercontrol-ui-data
    #lm-sensors
    kitty
    waybar
    dunst
    wofi
    openiscsi
    stow
    pkgs.gnome.gnome-tweaks
    signal-desktop
    zoxide
    fzf
    bat
    tldr
    thefuck
    lutris
    adwaita-icon-theme
    mangohud
    protonup
    bottles
    heroic
    trash-cli
    papirus-icon-theme
    openrgb-with-all-plugins
    gearlever
    teams-for-linux
    jellyfin-media-player
  ];

  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update.onActivation = true;
    remotes = [
      { name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
      { name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo"; }
    ];
    packages = [
      #     Example of how to add a package from the beta repo     
      #     { appId = "com.brave.Browser"; origin = "flathub-beta"; }
      "com.vscodium.codium"
      "com.github.tchx84.Flatseal"
      #"io.github.zen_browser.zen"
    ];
  };

  # Enable Appimages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.hardware.openrgb.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  programs.coolercontrol.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
