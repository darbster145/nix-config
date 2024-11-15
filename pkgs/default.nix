# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  asahi-bless = pkgs.callPackage ./asahi-bless/default.nix { };
  asahi-nvram = pkgs.callPackage ./asahi-nvram/default.nix { };
}
