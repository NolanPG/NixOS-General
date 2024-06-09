{
  description = "General porpuse flake";

  inputs = {
    # NixOS System
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
      laptop = lib.nixosSystem {
        inherit system;
        modules = [ 
          ./hosts/laptop/default.nix 
          chaotic.nixosModules.default
        ];
      };

      desktop = lib.nixosSystem {
        inherit system;
        modules = [ 
          ./hosts/desktop/default.nix 
          chaotic.nixosModules.default
        ];
      };
    };

    homeConfigurations = {
      nolan = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          ./home/home.nix 

          nixvim.homeManagerModules.nixvim
          ./home/neovim.nix

          ./home/vscodium/vscodium.nix
        ];
      };
    };
  };
}
