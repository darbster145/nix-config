{
  description = "A 'very' basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... } @ inputs: 
    {
      nixosConfigurations.brixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
	 ./configuration.nix
	];
      };
  };
}
