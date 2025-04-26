# Configuration specific to the device it's on. Link into place so it can be imported by configuration.nix as device-configuration.nix

{ config, pkgs, ... }:

let
  user = "bzas"; # Change to your username
  sway-hardware-config = "/home/${user}/nixos-config/dotfiles/sway/config-laptop-aurae";
in
{
  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pt";
    variant = "nodeadkeys";
  };

  # Device specific config files
  home-manager = {
    users.${user} = { pkgs, ... }: {
      xdg.configFile."sway/hardware-config".source = "${sway-hardware-config}";
    };
  };

  # Configure console keymap
  console.keyMap = "pt-latin1";

  # Define hostname
  networking.hostName = "aurae";

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Extra packages
  environment.systemPackages = with pkgs; [
    # Kitty and other fancy terminals just don't play nice with this laptop.
    # (It is ancient)
    xfce.xfce4-terminal
  ];
}
