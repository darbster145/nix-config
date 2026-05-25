{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./disk-config.nix
    ];

  boot.kernelParams = [ "console=ttyS0,115200" ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    initrd.systemd.enable = true;
  };

  systemd.targets.multi-user.enable = true;

  services.qemuGuest.enable = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "onix";

  networking.useDHCP = true;

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    mutableUsers = true;

    users.darbster = {
      isNormalUser = true;
      initialPassword = "Temp1234!";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIvybHh2fP6dGIPwvstU5UZWaEtXH5aOA5aeri7Ow7Do brixos-onix"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLOLHSg/E2juzxv80UX5KUwsw04dgVUS+Iw0gqvdQ3C brad@nixi"
      ];
    };

  };

  nix.settings.trusted-users = [ "darbster" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
    curl
    git
    vim
    wget
    neovim
    fastfetch
    btop
    apparmor-utils
  ];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  #services.fail2ban = {
  #  enable = true;
  #  ignoreIP = [
  #    "127.0.0.1/8"
  #    "::1"
  #    "100.64.0.0/10"
  #  ];
  #};

  # Disable autologin.
  services.getty.autologinUser = null;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    # SSH 
    22
  ];

  # Disable documentation for minimal install.
  documentation.enable = false;

  system.stateVersion = "24.11"; # Did you read the comment?
}
