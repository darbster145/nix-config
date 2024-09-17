# Edit this configuration file to define what should be installed 
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, apple-silicon, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
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

  networking.hostName = "nixi"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # enable GPU support and audio
  hardware.asahi = {
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    setupAsahiSound = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  #services.xserver.enable = true;
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome = {
  #  enable = true;
  #  extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
  #  extraGSettingsOverrides = ''
  #    [org.gnome.mutter]
  #    experimental-features=['scale-monitor-framebuffer']
  #  '';
  #};

  programs.hyprland.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brad = {
    isNormalUser = true;
    description = "Brad";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    firefox-devedition-bin
    kitty
    # inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
    htop
    fastfetch
    btop
    signal-desktop
    appimage-run
    stow
    oh-my-posh
    gcc
    asahi-nvram
    asahi-bless
    asahi-btsync
    asahi-wifisync
    protonvpn-gui
    protonmail-bridge-gui
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
    # Hyperland Programs
    waybar
    brightnessctl
    pavucontrol
    libreoffice
    teams-for-linux
    wireguard-tools
    cargo
    yakuake
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
    ];
  };

  # Enable Appimages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    fira-code
    font-awesome
    powerline-fonts
    powerline-symbols
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # SSH 
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # DO NOT CHANGE
  system.stateVersion = "24.11";

  # Enable nix experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
