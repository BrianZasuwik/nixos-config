# Configuration specific to the device it's on. Link into place so it can be imported by configuration.nix as device-configuration.nix

{ config, pkgs, ... }:

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
