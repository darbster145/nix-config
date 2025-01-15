# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./jellyfin.nix
    ];

  boot.kernelParams = [
    "i915.enable_guc=2"
  ];

  fileSystems."/mnt/immich/library" = {
    device = "10.0.0.3:/mnt/notonedrive/docker-volumes/immich/library";
    fsType = "nfs";
  };

  fileSystems."/mnt/immich/postgres" = {
    device = "10.0.0.3:/mnt/gofast/docker-volumes/immich/postgres";
    fsType = "nfs";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hl0"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  networking = {
    # Define the bond interface and assign the IP
    interfaces = {
      bond0 = {
        ipv4.addresses = [
          {
            address = "10.0.0.2";
            prefixLength = 24; # Adjust based on your subnet mask
          }
        ];
      };
    };
    defaultGateway = "10.0.0.1";
    nameservers = [ "10.0.0.1" ];

    # Define the bonded interface settings
    bonds = {
      bond0 = {
        driverOptions = {
          mode = "802.3ad";    # LACP mode
          lacp_rate = "fast";  # Faster LACP rate
        };
        interfaces = [ "enp1s0" "eno1" ]; # Specify interfaces directly here for the bond
      };
    };
  };


  # Enable networking
  #networking.networkmanager.enable = true;
  #networking = {
  #  interfaces = {
  #    enp1s0.ipv4.addresses = [{
  #      address = "10.0.0.2";
  #      prefixLength = 24;
  #    }];
  #  };
  #  defaultGateway = {
  #    address = "10.0.0.1";
  #    interface = "enp1s0";
  #  };
  #  nameservers = [
  #    "10.0.0.1"
  #  ];
  #};

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver # previously vaapiIntel
      vaapiVdpau
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      intel-media-sdk # QSV up to 11th gen
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.darbster = {
    isNormalUser = true;
    description = "darbster";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    docker-compose
    fastfetch
    htop
    btop
    git
  ];

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

  # Enable Tailscale
  services.tailscale = {
    enable = true;
  };

  services.netdata = {
    enable = true;
  };

  # Auto Updates
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 19999 ];
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

}
