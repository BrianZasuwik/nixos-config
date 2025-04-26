# Configuration specific to the device it's on. Link into place so it can be imported by configuration.nix as device-configuration.nix
# Bootloader is here because I have one laptop that is not UEFI that I would like to also have my nixos config on.

{ config, pkgs, ... }:

let
  user = "bzas"; # Change to your username
  #sway-hardware-config = "/home/${user}/nixos-config/dotfiles/sway/config-laptop-boreas";
in
{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define hostname
  networking.hostName = "boreas";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Device specific config files
  home-manager = {
    users.${user} = { pkgs, ... }: {
      #xdg.configFile."sway/hardware-config".source = "${sway-hardware-config}";
      wayland.windowManager.sway = {
        config = {
          output = {
            eDP-1 = {
              resolution = "1920x1080 position 0,0";
            };
          };
          input = {
            "*" = {
              xkb_layout = "gb";
            };
            "2:7:SynPS/2_Synaptics_TouchPad" = {
              tap = "enabled";
              dwt = "enabled";
              natural_scroll = "enabled";
              middle_emulation = "enabled";
            };
          };
        };
      };
    };
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Graphics Settings
  services.xserver.videoDrivers = ["nvidia"];
  
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    # Nvidia PRIME for the dGPU
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
