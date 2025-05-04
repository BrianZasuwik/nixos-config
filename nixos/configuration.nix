# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# https://github.com/BrianZasuwik

# Sway WM, Mako, & Waybar configs based on config by https://github.com/arkboix
# which can be found here https://github.com/arkboix/sway/

{ config, pkgs, ... }:
let
  profile = import ./../user/profile.nix {};
in
{
  imports =
    [
      ./../dotfiles/sway/sway.nix
      ./../dotfiles/wofi/wofi.nix
      ./../dotfiles/waybar/waybar.nix
      ./../dotfiles/mako/mako.nix
    ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "${profile.timezone}";

  # Select internationalisation properties.
  i18n.defaultLocale = "${profile.locale}";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${profile.locale}";
    LC_IDENTIFICATION = "${profile.locale}";
    LC_MEASUREMENT = "${profile.locale}";
    LC_MONETARY = "${profile.locale}";
    LC_NAME = "${profile.locale}";
    LC_NUMERIC = "${profile.locale}";
    LC_PAPER = "${profile.locale}";
    LC_TELEPHONE = "${profile.locale}";
    LC_TIME = "${profile.locale}";
  };

  services.xserver = {
    enable = false;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  ### Display manager (ly)
  services.displayManager.ly.enable = true;

  ### Power management
  powerManagement.enable = true;
  services.upower = {
    enable = true;
    percentageLow = 25;
    percentageCritical = 10;
  };

  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;

  programs.git.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.flatpak.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  services.blueman.enable = true;

  services.syncthing = {
    enable = true;
    user = "${profile.user}";
    dataDir = "/home/${profile.user}";
    configDir = "/home/${profile.user}/.config/syncthing";
    guiAddress = "127.0.0.1:8384";
  };

  services.printing.enable = true;

  programs.firefox.enable = true;

  security.polkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${profile.user} = {
    isNormalUser = true;
    description = "${profile.name}";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "usb" "plugdev" "kvm" "users" "vboxusers" ];
    packages = with pkgs; [];
  };

  qt.style = "adwaita-dark";

  home-manager = {
    users.${profile.user} = { pkgs, lib, ... }: {

      home.username = "${profile.user}";
      home.homeDirectory = "/home/${profile.user}";

      home.packages = with pkgs; [
        discord
        thonny
        fastfetch
        fortune
        cowsay
        gimp
        qbittorrent
        filezilla
        vlc
      ];
      programs.bash = {
        enable = true;
        bashrcExtra = "
alias sway='sway --unsupported-gpu'
";
      };

      services.poweralertd.enable = true;

      services.playerctld.enable = true;

      ### Kitty configuration:
      programs.kitty = {
        enable = true;
        shellIntegration = {
          enableBashIntegration = true;
          enableFishIntegration = false;
          enableZshIntegration = false;
        };
        settings = {
          confirm_os_window_close = 0;
          background_opacity = 0.7;
          background_blur = 48;
          background_tint = 0.1;
        };
      };

      ### VSCode configuration:
      programs.vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          ms-python.python
          ecmel.vscode-html-css
        ];
      };

      ### KDE Connect
      services.kdeconnect.enable = true;

      ### Automatically link any external configuration files into .config
      # Less prefereable than directly managing via home manager but necessary for some which are missing modules.
      #xdg.configFile."sway/config".source = "/home/${profile.user}/nixos-config/dotfiles/sway/config";
      #xdg.configFile."waybar/style.css".source = "/home/${profile.user}/nixos-config/dotfiles/waybar/style.css";
      #xdg.configFile."waybar/config.jsonc".source = "/home/${profile.user}/nixos-config/dotfiles/waybar/config.jsonc";
      #xdg.configFile."mako/config".source = "/home/${profile.user}/nixos-config/dotfiles/mako/config";
      #xdg.configFile."wofi/style.css".source = "/home/${profile.user}/nixos-config/dotfiles/wofi/style.css";
      #xdg.configFile."kitty/kitty.conf".source = "/home/${profile.user}/nixos-config/dotfiles/kitty/kitty.conf";

      xdg.desktopEntries = {
        nemo = {
          name = "Nemo";
          exec = "${pkgs.nemo-with-extensions}/bin/nemo";
        };
      };
      ### Default Applications
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = [ "nemo.desktop" ];
          "application/x-gnome-saved-search" = [ "nemo.desktop" ];
        };
      };

      ### Theme configs
      # Change to catppuccin once home manager is properly set up and happy with other configs?
      gtk = {
        enable = true;
        theme = {
          name = "Adwaita";
          package = pkgs.gnome-themes-extra;
        };
        iconTheme = {
          name = "Numix";
          package = pkgs.numix-icon-theme;
        };
        cursorTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };
        gtk4 = {
          extraConfig = {
            gtk-application-prefer-dark-theme = 1;
          };
        };
        gtk3 = {
          extraConfig = {
            gtk-application-prefer-dark-theme = 1;
          };
        };
      };

      #State version is required and should stay at the version originally installed.
      #You can update Home Manager without changing this value.
      home.stateVersion = "24.11";
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nano
    wget
    lshw
    wev
    gzip
    unzip
    zip
    pulseaudio
    image-roll
    libreoffice
    mission-center
    ffmpegthumbnailer
    webp-pixbuf-loader
    libgsf
    ranger
    libnotify
    xdg-utils
    xdg-user-dirs
    xdg-user-dirs-gtk
    nemo-with-extensions
  ];

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

  virtualisation.virtualbox = {
    host = {
      enable = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-han-sans
      corefonts
      liberation_ttf
      
      (nerdfonts.override {fonts = [ "NerdFontsSymbolsOnly" "Iosevka" "IosevkaTerm" "IosevkaTermSlab" ]; })
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Serif" ];
      sansSerif = [ "Noto Sans" "Sans" ];
    };
    fontDir.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = rec {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
