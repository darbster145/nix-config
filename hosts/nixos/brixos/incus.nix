{ pkgs, config, ... }:

{
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };
  networking.nftables.enable = true;
  users.users.brad.extraGroups = [ "incus-admin" ];
}
