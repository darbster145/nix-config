{ pkgs, ... }:

{
  # aarch64 emulation
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  nix.settings = {
    # Keep this so the build server can pull from cache when doing its own tasks
    substituters = [ "https://cache.nixos.org" ];
    max-jobs = 16;
    cores = 0;

    # Allows remote builder user to interact with the Nix daemon
    trusted-users = [ "root" "nixremote" ];
  };

  # Create the user that clients will SSH into
  users.users.nixremote = {
    isNormalUser = true;
    description = "Remote Nix Builder User";
    # The Nix daemon handles the build pool, but this user triggers it
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL75BD/YNJhcRkSe3n4X/kCYGXnZ3xiahbRVXkcyFSRO root@nixi"
    ];
  };

  # Ensure the SSH daemon is running so clients can connect
  #services.openssh = {
  #  enable = true;
  #  settings.PasswordAuthentication = false; # Secure it to SSH keys only
  #};
}
