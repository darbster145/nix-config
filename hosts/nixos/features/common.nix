# Settings shared by every NixOS host. Values use mkDefault where a host
# might reasonably want something different, so a plain assignment in the
# host's configuration.nix wins.
{ lib, ... }:

{
  imports = [
    ../../common
  ];

  nix.gc.dates = lib.mkDefault "weekly";

  time.timeZone = lib.mkDefault "America/Denver";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
}
