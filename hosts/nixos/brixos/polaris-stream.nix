{ inputs, pkgs, ... }:

{
  # nixpkgs' services.polaris is the unrelated Polaris music server.
  disabledModules = [ "services/misc/polaris.nix" ];

  services.polaris = {
    enable = true;
    users = [ "brad" ];
  }
  // import ./polaris-packages.nix { inherit inputs pkgs; };
}
