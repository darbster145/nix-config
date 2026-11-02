{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  # nixpkgs' services.polaris is the unrelated Polaris music server.
  disabledModules = [ "services/misc/polaris.nix" ];

  # Upstream's module sets the obsolete avahi publish options, which warn on
  # any value. Publishing is configured via services.avahi.settings instead.
  services.avahi.publish.enable = lib.mkForce null;
  services.avahi.publish.userServices = lib.mkForce null;

  services.polaris = {
    enable = true;
    users = [ "brad" ];
  }
  // import ./polaris-packages.nix { inherit inputs pkgs; };
}
