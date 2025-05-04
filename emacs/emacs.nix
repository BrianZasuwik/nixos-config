{ config, pkgs, ... }:
let
  profile = import ./../user/profile.nix {};
in
{
  home-manager = {
    users.${profile.user} = { pkgs, lib, ... }: {
      programs.emacs = {
        enable = true;
      };
      services.emacs = {
        enable = true;
        client = {
          enable = true;
        };
      };
    };
  };
}