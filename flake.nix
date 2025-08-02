{
  description = "General porpuse flake";

  inputs = {
    # NixOS System
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim
    # nixvim = {
    #   url = "github:nix-community/nixvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Chaotic (Bleeding edge packages)
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { 
    self, 
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    chaotic,
    zen-browser,
    ... 
    } @inputs:

    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      pkgsWithOverlays = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          chaotic.overlays.default
        ];
      };

      pkgsStable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    in {

    nixosConfigurations = {
      desktop = lib.nixosSystem {
        inherit system;

        modules = [ 
          ./hosts/desktop/default.nix 
          chaotic.nixosModules.default
        ];

        specialArgs = {
          pkgs-stable = pkgsStable;
          pkgs = pkgsWithOverlays;
        };
      };

      laptop = lib.nixosSystem rec {
        inherit system;

        modules = [ 
          ./hosts/laptop/default.nix 
          chaotic.nixosModules.default
        ];

        specialArgs = {
          pkgs-stable = pkgsStable;
          pkgs = pkgsWithOverlays;
        };
      };
    };

    homeConfigurations = {
      nolan = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsWithOverlays;
        modules = [ 
          ./home/home.nix 
          #nixvim.homeManagerModules.nixvim # error: gdtoolkit has been renamed to gdtoolkit_3 to distinguish from version 4
          #./home/neovim.nix
          ./home/vscodium/vscodium.nix

          inputs.zen-browser.homeModules.beta
        ];
      };
    };
  };
}
