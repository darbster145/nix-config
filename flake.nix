{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    stable-nixpkgs = {
      url = "nixpkgs/nixos-24.11";
    };
    master-nixpkgs = {
      url = "nixpkgs/master";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser-darwin = {
      url = "github:darbster145/zen-browser-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
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

  };

  outputs =
    { self
    , nixpkgs
    , stable-nixpkgs
    , master-nixpkgs
    , lix-module
    , home-manager
    , nixos-wsl
    , apple-silicon
    , nix-darwin
    , nix-homebrew
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
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # TODO - Get single stable package generation working
      # stable-pkgs = forAllSystems (system: stable-nixpkgs.legacyPackages.${system});

    in
    {
      # Custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        brixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/nixos/brixos/configuration.nix
            lix-module.nixosModules.default
          ];
        };

        nixi = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/nixos/nixi/configuration.nix
            apple-silicon.nixosModules.apple-silicon-support
          ];
        };

        hl0 = stable-nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/nixos/hl0/configuration.nix
          ];
        };

        wixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/nixos/wixos/configuration.nix
            nixos-wsl.nixosModules.default
          ];
        };
      };

      darwinConfigurations = {
        "JRSYS-MBA-01" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          system = "aarch64-darwin";
          modules = [
            ./hosts/darwin/jrsys-mba-01/configuration.nix
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
        "bradlee@JRSYS-MBA-01" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/jrsys-mba-01.nix
          ];
        };

        "brad@crapple" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/crapple.nix
          ];
        };

        "brad@nixi" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/nixi.nix
          ];
        };
      };
    };
}



