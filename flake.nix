{
  description = "Brian's NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    home-manager = { 
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
  let
    lib = nixpkgs.lib;
  in
  {
    nixosConfigurations = {
      boreas = lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              pkgs-unstable = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
                config.permittedInsecurePackages = [
                  "dotnet-runtime-7.0.20"
                ];
              };
            };
          }
          ./nixos/configuration.nix
          ./nixos/games.nix
          ./devices/laptop-boreas-configuration.nix
        ];
        specialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
      };
    };
  };
}