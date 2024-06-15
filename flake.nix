{
  description = "General porpuse flake";

  inputs = {
    # NixOS System
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Chaotic (Bleeding edge packages)
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { 
    self, 
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nixvim,
    chaotic,
    ... 
    }:

    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in {

    nixosConfigurations = {
      laptop = lib.nixosSystem rec {
        inherit system;

        modules = [ 
          ./hosts/laptops/ideapad/default.nix 
          chaotic.nixosModules.default
        ];
      };

      laptop-yoga = lib.nixosSystem rec {
        inherit system;

        modules = [ 
          ./hosts/laptops/yoga/default.nix 
          chaotic.nixosModules.default
        ];
      };

      desktop = lib.nixosSystem {
        inherit system;

        modules = [ 
          ./hosts/desktop/default.nix 
          chaotic.nixosModules.default
        ];

        specialArgs = {
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };

          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        };
      };
    };

    homeConfigurations = {
      nolan = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          ./home/home.nix 

          nixvim.homeManagerModules.nixvim # error: gdtoolkit has been renamed to gdtoolkit_3 to distinguish from version 4
          ./home/neovim.nix

          ./home/vscodium/vscodium.nix
        ];
      };
    };
  };
}
