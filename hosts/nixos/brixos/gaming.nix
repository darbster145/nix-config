# Keep the old host-local module path as a thin wrapper around shared gaming
# settings and BrixOS-only Sunshine configuration.
{ ... }:

{
  imports = [
    ../features/gaming.nix
    ./sunshine.nix
  ];
}
