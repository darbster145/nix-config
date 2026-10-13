# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  freelens-bin = pkgs.callPackage ./freelens-bin/package.nix { };
  radar-bin = pkgs.callPackage ./radar-bin/package.nix { };
  radar-desktop-bin = pkgs.callPackage ./radar-desktop-bin/package.nix { };
}
