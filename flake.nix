{
  description = "Combined flake for NixOS and Darwin systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # stable.url = "nixpkgs/nixos-24.05";
    # master.url = "nixpkgs/master";

    apple-silicon = {
      url = "github:zzywysm/nixos-asahi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:ch4og/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Optional: Homebrew taps for crapple
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    zen-browser-darwin = {
      url = "github:darbster145/zen-browser-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, apple-silicon, nix-flatpak, nix-darwin, nix-homebrew, firefox, home-manager, ... } @ inputs: {

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

    darwinConfigurations = {
      "JRSYS-MBA-01" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        system = "aarch64-darwin";
        modules = [
          ./darwin/hosts/jrsys-mba-01/configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };

      crapple = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        system = "aarch64-darwin";
        modules = [
          ./darwin/hosts/crapple/configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };
    };

    darwinPackages = {
      "JRSYS-MBA-01" = self.darwinConfigurations."JRSYS-MBA-01".pkgs;
      crapple = self.darwinConfigurations.crapple.pkgs;
    };
  };
}

