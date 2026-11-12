{
  config,
  lib,
  outputs,
  pkgs,
  ...
}:

{
  imports = [
    ./sops.nix
  ];

  home = {
    username = lib.mkDefault "brad";
    homeDirectory = lib.mkDefault (
      if pkgs.stdenv.hostPlatform.isDarwin then
        "/Users/${config.home.username}"
      else
        "/home/${config.home.username}"
    );
  };

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
