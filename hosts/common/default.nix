# Settings shared by every host, NixOS and nix-darwin alike.
# Only use options that exist on both platforms here; platform-specific
# shared settings live in hosts/nixos/features/common.nix (and the darwin host).
{
  lib,
  inputs,
  outputs,
  ...
}:

{
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    outputs.overlays.stable-packages
    outputs.overlays.additions
    outputs.overlays.modifications
  ];

  nix.optimise.automatic = lib.mkDefault true;

  # The schedule is platform-specific (`dates` on NixOS, `interval` on darwin).
  nix.gc = {
    automatic = lib.mkDefault true;
    options = lib.mkDefault "--delete-older-than 15d";
  };
}
