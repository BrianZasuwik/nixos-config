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
    pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
  in
  {
    nixosConfigurations = {
      boreas = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          ./configuration.nix
          ./../devices/laptop-boreas-configuration.nix
        ];
        specialArgs = {
          inherit pkgs-unstable;
        };
      };
    };
  };
}