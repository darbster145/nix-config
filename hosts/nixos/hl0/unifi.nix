{ pkgs, config, ... }:

{

  services.unifi = {
    enable = true;
    openFirewall = true;
    unifiPackage = pkgs.unifi;
    mongodbPackage = pkgs.mongodb-ce;
  };

  networking.firewall.allowedTCPPorts = [ 8443 ];

}
