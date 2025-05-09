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
  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "firewire_ohci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Filesystem
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b7140590-32e6-435b-b0ee-79fdc0530900";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/10917183-a085-40cb-9b6e-bcaab8c39c82"; }
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
            eDP-1 = {
              resolution = "1280x800 position 0,0";
            };
          };
          input = {
            "*" = {
              xkb_layout = "gb";
            };
          };
        };
      };
    };
  };

  # Configure console keymap
  console.keyMap = "uk";
}
