# Configuration specific to the device it's on. Link into place so it can be imported by configuration.nix as device-configuration.nix
# Bootloader is here because I have one laptop that is not UEFI that I would like to also have my nixos config on.

{ config, pkgs, lib, modulesPath, ... }:

let
  profile = import ./../user/profile.nix {};
in
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Kernel
  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "firewire_ohci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" "thinkpad_acpi" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/c0f76681-aef9-4264-900a-f7d4d729f397";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/1b5252ff-52ce-4e9a-8b45-f7393f28ee94"; }
    ];

  ### Networking
  networking.hostName = "anemoi"; # Define your hostname.
  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # Enable networking
  networking.networkmanager.enable = true;
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s25.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Power management
  services.thermald.enable = true;

  # Device specific home-manager configs
  home-manager = {
    users.${profile.user} = { pkgs, ... }: {
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
}
