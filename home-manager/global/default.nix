{ outputs, ... }:

{
  imports = [
    ./sops.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
      outputs.overlays.additions
      outputs.overlays.modifications
    ];

    config = {
      allowUnfree = true;
    };
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  home.stateVersion = "26.05";
}
