{
  description = "Combined flake for NixOS and Darwin systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    home-manager.url = "github:nix-community/home-manager/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-darwin.url = "github:LnL7/nix-darwin";
    spacebar.url = "github:cmacrae/spacebar/v1.4.0";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    firefox.url = "github:nix-community/flake-firefox-nightly";
    firefox.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.url = "github:MarceColl/zen-browser-flake";


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
    AeroSpace = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, apple-silicon, nix-flatpak, nix-darwin, nix-homebrew, firefox, ... } @ inputs: {

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

