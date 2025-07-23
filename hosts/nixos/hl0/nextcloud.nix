{ config, pkgs, lib, ... }:

{

containers.nextcloud = {
  autoStart = true;
  privateNetwork = false;
  config = { config, pkgs, lib, ... }: {

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      hostName = "localhost";
      config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}"; # DON'T DO THIS IN PRODUCTION - the password file will be world-readable in the Nix Store!
    };

    system.stateVersion = "23.11";

    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };
      # Use systemd-resolved inside the container
      # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
      useHostResolvConf = lib.mkForce false;
    };
    
    services.resolved.enable = true;

  };

};
}
