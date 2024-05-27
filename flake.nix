{
  description = "General usage flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { 
    self, 
    nixpkgs, 
    home-manager, 
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
        modules = [ ./laptop/configuration.nix ];
      };

      desktop = lib.nixosSystem {
        inherit system;
        modules = [ ./desktop/configuration.nix ];
      };
    };

    homeConfigurations = {
      nolan = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/home.nix ];
      };
    };
  };
}
