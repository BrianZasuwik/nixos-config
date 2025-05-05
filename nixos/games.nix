{ config, pkgs, pkgs-unstable, ... }:
let
  profile = import ./../user/profile.nix {};
in
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks = {
      enable = true;
      package = pkgs.protontricks;
    };
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  home-manager = {
    users.${profile.user} = { pkgs, lib, pkgs-unstable, ... }: {
      home.packages = with pkgs-unstable; [
        vintagestory
        clonehero
      ];
    };
  };
}