{
  description = "A 'very' basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    apple-silicon.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... } @ inputs: {
    nixosConfigurations = {
      brixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [ ./nixos/hosts/brixos/configuration.nix];
      };
      nixi = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "aarch64-linux";
        modules = [ ./nixos/hosts/nixi/configuration.nix ];
      };
    };
  };
}

