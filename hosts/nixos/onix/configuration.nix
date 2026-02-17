{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

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
  networking.networkmanager.enable = true;

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    mutableUsers = false;
    users.darbster = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINDd1x5laUcERxGmCI8twj7PU5hOnqLKb8m4dJuTUVFV nixi-onix"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIvybHh2fP6dGIPwvstU5UZWaEtXH5aOA5aeri7Ow7Do brixos-onix"
      ];
    };
  };

  nix.settings.trusted-users = [ "darbster" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable passwordless sudo.
  security.sudo.extraRules = [
    {
      users = [ "darbster" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

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

  services.fail2ban = {
    enable = true;
  };

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
