{
  inputs = {
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    nixpkgs = {
      url = "nixpkgs/nixos-25.11";
    };

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };

    walker = {
      url = "github:abenz1267/walker";
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

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

  };

  outputs =
    { self
    , nixpkgs-unstable
    , nixpkgs
    , home-manager
    , nixos-wsl
    , apple-silicon
    , nix-darwin
    , nix-homebrew
    , ghostty
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      # Supported systems for flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      # This is a function that generates an attribute by calling a function
      # passed to it, with each system as an argument
      forAllSystems = nixpkgs-unstable.lib.genAttrs systems;

      # TODO - Get single stable package generation working
      # stable-pkgs = forAllSystems (system: stable-nixpkgs.legacyPackages.${system});

    in
    {
      # Custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs-unstable.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = forAllSystems (system: nixpkgs-unstable.legacyPackages.${system}.alejandra);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        brixos = nixpkgs-unstable.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/nixos/brixos/configuration.nix
          ];
        };

        nixi = nixpkgs-unstable.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hosts/nixos/nixi/configuration.nix
            apple-silicon.nixosModules.apple-silicon-support
          ];
        };

        hl0 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/hl0/configuration.nix
          ];
        };

        onix = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          system = "aarch64-linux";
          modules = [
            ./hosts/nixos/onix/configuration.nix
          ];
        };
      };

      darwinConfigurations = {
        "SYS-MBA-02" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          system = "aarch64-darwin";
          modules = [
            ./hosts/darwin/SYS-MBA-02/configuration.nix
            nix-homebrew.darwinModules.nix-homebrew
            #lix-module.nixosModules.default
          ];
        };

        crapple = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          system = "aarch64-darwin";
          modules = [
            ./hosts/darwin/crapple/configuration.nix
            nix-homebrew.darwinModules.nix-homebrew
          ];
        };
      };

      homeConfigurations = {
        "brad@SYS-MBA-02" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/sys-mba-02.nix
          ];
        };

        "brad@crapple" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/crapple.nix
          ];
        };

        "brad@nixi" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.aarch64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/nixi.nix
          ];
        };

        "brad@brixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/brixos.nix
          ];
        };
      };
    };
}



