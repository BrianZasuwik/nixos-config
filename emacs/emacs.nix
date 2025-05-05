{ config, pkgs, ... }:
let
  profile = import ./../user/profile.nix {};
in
{
  home-manager = {
    users.${profile.user} = { pkgs, lib, ... }: {
      services.emacs = {
        enable = true;
        client = {
          enable = true;
        };
        package = with pkgs; (
          (emacsPackagesFor emacs).emacsWithPackages (
            epkgs: [
              epkgs.company
              epkgs.lsp-mode
              epkgs.magit
              epkgs.which-key
            ]
          )
        );
      };
    };
  };
}