{
  description = "A 'very' basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    apple-silicon = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... } @ inputs: {
      nixosConfigurations = {
        brixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./configuration.nix ];
        };
        nixi = nixpkgs.lib.nixosSystem {
          system = "aarch64_linux";
          modules = [ ./configuration.nix ];
        };
      };
   };
 };
}

