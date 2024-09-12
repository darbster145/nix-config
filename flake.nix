{
  description = "A 'very' basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    home-manager.url = "github:nix-community/home-manager/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { nixpkgs, nix-flatpak, apple-silicon, ... } @ inputs: {
    nixosConfigurations = {
      brixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [ 
          ./nixos/hosts/brixos/configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };
      nixi = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "aarch64-linux";
        modules = [ 
          ./nixos/hosts/nixi/configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          apple-silicon.nixosModules.apple-silicon-support
        ];
      };
    };
  };
}

