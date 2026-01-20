# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  #zen-browser = pkgs.callPackage ./zen-browser-unwrapped/package.nix { };
  freelens-bin = pkgs.callPackage ./freelens-bin/package.nix { };
}
