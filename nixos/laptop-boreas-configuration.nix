# Configuration specific to the device it's on. Link into place so it can be imported by configuration.nix as device-configuration.nix
# Bootloader is here because I have one laptop that is not UEFI that I would like to also have my nixos config on.

{ config, pkgs, ... }:

let
  profile = import ./../user/profile.nix {};
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

  # Power management
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # Device specific home-manager configs
  home-manager = {
    users.${profile.user} = { pkgs, ... }: {
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
  services.xserver.videoDrivers = [ "intel" "nvidia" ];
  
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
