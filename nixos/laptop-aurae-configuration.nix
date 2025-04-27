# Configuration specific to the device it's on. Link into place so it can be imported by configuration.nix as device-configuration.nix

{ config, pkgs, ... }:

let
  user = "bzas"; # Change to your username
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

  # Power management
  services.thermald.enable = true;

  # Device specific config files
  home-manager = {
    users.${user} = { pkgs, ... }: {
      wayland.windowManager.sway = {
        config = {
          output = {
            LVDS-1 = {
              resolution = "1280x800 position 0,0";
            };
          };
          input = {
            "*" = {
              xkb_layout = "gb";
            };
            "1:1:AT_Translated_Set_2_keyboard" = {
              xkb_layout = "pt";
              xkb_variant = "nodeadkeys";
            };
            "0:0:Toshiba_input_device" = {
              xkb_layout = "pt";
              xkb_variant = "nodeadkeys";
            };
            "0:1:Power_Button" = {
              xkb_layout = "pt";
              xkb_variant = "nodeadkeys";
            };
            "0:6:Video_Bus" = {
              xkb_layout = "pt";
              xkb_variant = "nodeadkeys";
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
