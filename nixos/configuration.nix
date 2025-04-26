# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# https://github.com/BrianZasuwik

# Sway WM, Mako, & Waybar configs based on config by https://github.com/arkboix
# which can be found here https://github.com/arkboix/sway/

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz;
  #unstableTarball = builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;

  # User variables
  user = "bzas"; # Change to your username
  name = "Brian Zasuwik"; # Change to your name

  # Theming & colour variables
  background = "#212121";
  background-light = "#3a3a3a";
  border = "#285577";
  foreground = "#e0e0e0";
  black = "#5a5a5a";
  red = "#ff9a9e";
  green = "#b5e8a9";
  yellow = "#ffe6a7";
  blue = "#63a4ff";
  magenta = "#dda0dd";
  cyan = "#a3e8e8";
  white = "#ffffff";
  orange = "#ff8952";
  crimson = "#c92225";

  wallpaper = "M31_IRAC-MIPS.jpg";
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix # Include the results of the hardware scan.
      /etc/nixos/device-configuration.nix # Include the device specific config (hardware configuration other than scan results)
      (import "${home-manager}/nixos")
    ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver = {
    enable = false;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  powerManagement.enable = true;

  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;

  # Display Manager (ly)
  services.displayManager.ly.enable = true;

### Now managed by home-manager
#  # Window Manager (Sway)
#  programs.sway = {
#    enable = true;
#    package = pkgs.swayfx;
#    wrapperFeatures = {
#      base = true;
#      gtk = true;
#    };
#    xwayland.enable = true;
#    extraPackages = with pkgs; [
#      brightnessctl
#      kitty
#      grim
#      slurp
#      pulseaudio
#      swayidle
#      swaylock
#      wofi
#      swaybg
#      wl-clipboard
#      mako
#      gdu
#      btop
#      pavucontrol
#    ];
#    extraOptions = [
#      "--unsupported-gpu"
#    ];
#  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.waybar.enable = true;

  programs.light.enable = true;

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

  xdg.autostart.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  services.flatpak.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  services.blueman.enable = true;

  services.syncthing = {
    enable = true;
    user = "${user}";
    dataDir = "/home/${user}";
    configDir = "/home/${user}/.config/syncthing";
    guiAddress = "127.0.0.1:8384";
  };

  services.printing.enable = true;

  programs.firefox.enable = true;

  security.polkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "${name}";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "usb" "plugdev" "kvm" "users" "vboxusers" ];
    packages = with pkgs; [];
  };

  qt.style = "adwaita-dark";

  home-manager = {
    users.${user} = { pkgs, ... }: {

      home.username = "${user}";
      home.homeDirectory = "/home/${user}";

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
        # Packages for wm:
        brightnessctl
        grim
        slurp
        swaybg
        wl-clipboard
        gdu
        btop
        pavucontrol
      ];
      programs.bash.enable = true;

      services.playerctld.enable = true;

      ### sway wm configuration:
      # Based on sway config by https://github.com/arkboix
      # Found here: https://github.com/arkboix/sway/
      wayland.windowManager.sway = {
        enable = true;
        package = pkgs.swayfx;
        wrapperFeatures = {
          base = true;
          gtk = true;
        };
        xwayland = true;
        extraOptions = [ "--unsupported-gpu" ];
        config = {
          terminal = "kitty";
          menu = "dmenu_path | wofi --allow-images --show=drun | xargs swaymsg exec --";
          modifier = "Mod4";

          focus = {
            followMouse = true;
            wrapping = "no";
          };

          bars = [
            {
              command = waybar;
            }
          ];

          gaps = {
            inner = 10;
          };

          # I'm not a vim user, so I'd like my navigation
          # keys to be in a navigation-y shape.
          up = "i";
          down = "k";
          left = "j";
          right = "l";

          window = {
            border = 2;
            titlebar = true;
            commands = [
              {
                command = "foating enable, move position center, resize 600 400";
                criteria = {
                  app_id = "org.pulseaudio.pavucontrol";
                };
              }
              {
                command = "floating enable";
                criteria = {
                  app_id = "yad";
                };
              }
              {
                command = "floating enable, move position center";
                criteria = {
                  title = "Steam Settings";
                };
              }
              {
                command = "floating enable, move position center";
                criteria = {
                  title = "Friends List";
                };
              }
            ];
          };

          floating = {
            border = 2;
            titlebar = true;
          };

          keybindings = let
            modifier = config.wayland.windowManager.sway.config.modifier;
            terminal = config.wayland.windowManager.sway.config.terminal;
            menu = config.wayland.windowManager.sway.config.menu;
            up = config.wayland.windowManager.sway.config.up;
            down = config.wayland.windowManager.sway.config.down;
            left = config.wayland.windowManager.sway.config.left;
            right = config.wayland.windowManager.sway.config.right;
          in lib.mkOptionDefault {
            # Start a terminal
            "${modifier}+Return" = "exec ${terminal}";
            "${modifier}+F1" = "exec ${terminal}";
              # The Mod+F(Key) binds are held over from my Gnome setup
              # as I am used to them.

            # Start a web browser
            "XF86HomePage" = "exec firefox";
            "${modifier}+F2" = "exec firefox";

            # Start a file manager
            "${modifier}+F3" = "exec thunar";

            # Kill focused window
            "${modifier}+Shift+q" = "kill";

            # Start your launcher
            "${modifier}+d" = "exec ${menu}";

            # Reload the config file
            "${modifier}+Shift+c" = "reload";
              # Won't be reloading any changes on the fly as Sway's managed by
              # home maanger, but it might come in handy in case something breaks
              # ¯\_(ツ)_/¯

            # Exit sway
            "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";

            ### Moving around
            # Moving your focus around
            "${modifier}+Left" = "focus left";
            "${modifier}+Down" = "focus down";
            "${modifier}+Up" = "focus up";
            "${modifier}+Right" = "focus right";
            "${modifier}+${left}" = "focus left";
            "${modifier}+${down}" = "focus down";
            "${modifier}+${up}" = "focus up";
            "${modifier}+${right}" = "focus right";
            # Moving the focused window
            "${modifier}+Shift+Left" = "move left";
            "${modifier}+Shift+Down" = "move down";
            "${modifier}+Shift+Up" = "move up";
            "${modifier}+Shift+Right" = "move right";
            "${modifier}+Shift+${left}" = "move left";
            "${modifier}+Shift+${down}" = "move down";
            "${modifier}+Shift+${up}" = "move up";
            "${modifier}+Shift+${right}" = "move right";

            ### Workspaces
            # Switch to workspace
            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";
            "${modifier}+0" = "workspace number 10";
            # Move focused container to workspace
            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
            "${modifier}+Shift+6" = "move container to workspace number 6";
            "${modifier}+Shift+7" = "move container to workspace number 7";
            "${modifier}+Shift+8" = "move container to workspace number 8";
            "${modifier}+Shift+9" = "move container to workspace number 9";
            "${modifier}+Shift+0" = "move container to workspace number 10";

            ### Layout controls
            # Split
            "${modifier}+b" = "splith";
            "${modifier}+v" = "splitv";
            # Switch current container between different layout styles
            "${modifier}+s" = "layout stacking";
            "${modifier}+w" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";
            # Make current window fullscreen
            "${modifier}+f" = "fullscreen";
            # Toggle floating for current window
            "${modifier}+Shift+space" = "floating toggle";
            # Swap focus between tiling area and floating area
            "${modifier}+space" = "focus mode_toggle";
            # Move focus to parent container
            "${modifier}+a" = "focus parent";

            ### Scratchpad
            # Move currently focused window to the scratchpad
            "${modifier}+Shift+minus" = "move scratchpad";
            # Cycle through the scratchpad
            "${modifier}+minus" = "scratchpad show";

            ### Modes
            # Resize mode
            "${modifier}+r" = "mode resize";

            # Brightness Control
            "XF86MonBrightnessDown" = "exec brightnessctl set 2%-";
            "XF86MonBrightnessUp" = "exec brightnessctl set +2%";

            # Volume Controls
            "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
            "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
            "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
            "${modifier}+XF86AudioRaiseVolume" = "exec 'pactl set-source-volume @DEFAULT_SOURCE@ +1%'";
            "${modifier}+XF86AudioLowerVolume" = "exec 'pactl set-source-volume @DEFAULT_SOURCE@ -1%'";
            "XF86AudioMicMute" = "exec 'pactl set-source-mute @DEFAULT_SOURCE@ toggle'";

            ### Media controls
            # Launch VLC (My universal media player of choice)
            "XF86AudioMedia" = "exec vlc";
            # Pause/Play
            "XF86AudioPlay" = "playerctl play-pause";
            # Stop
            "XF86AudioStop" = "playerctl stop";
            # Previous/Next
            "XF86AudioPrev" = "playerctl previous";
            "XF86AudioNext" = "playerctl next";

            # Screenshots
            "Print" = "exec grim -g \"$(slurp)\" \"$HOME/Pictures/screenshots/$(date '+%y%m%d_%H-%M-%S').png\"";
          };

          modes = {
            resize = {
              Up = "resize shrink height 10px";
              Down = "resize grow height 10px";
              Left = "resize shrink width 10px";
              Right = "resize grow width 10px";
              "${up}" = "resize shrink height 10px";
              "${down}" = "resize grow height 10px";
              "${left}" = "resize shrink width 10px";
              "${right}" = "resize grow width 10px";
              Return = "mode default";
              Escape = "mode default";
            };
          };

          output = {
            "*" = {
              bg = "/home/${user}/nixos-config/wallpapers/${wallpaper}";
            };
          };

          extraConfigEarly = "
          corner_radius 10

          blur on
          blue_xray off
          blue_passes 2
          blur_radius 5
          
          shadows on
          shadows_on_csd off
          shadow_blue_radius 20
          shadow_color #0000007F
          
          default_dim_inactive 0.0
          dim_inactive_colors.unfocused #000000FF
          dim_inactive_colors.urgent #900000FF
          ";

          extraConfig = "
          exec mako

          exec wl-paste --type text --watch cliphist store &
          exec wl-paste --type image --watch cliphist store &

          include /etc/sway/config.d/*
          ";
        };
      };

      ### swayidle configuration:
      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 600;
            command = "swagmsg \"output * power off\"";
            resumeCommand = "swaymsg \"output * power on\"";
          }
        ];
      };

      ### wofi configuration:
      programs.wofi = {
        enable = true;
        style = "
window {
    margin: 0px;
    border: 2px solid ${border};
    border-radius: 10px;
    background-color: ${background};
}

#input {
    margin: 5px;
    border: none;
    color: #a3e8e8;
    background-color: ${background-light};
}

#inner-box {
    margin: 5px;
    border: none;
    background-color: ${background};
}

#outer-box {
    margin: 5px;
    border: none;
    background-color: ${background};
}

#scroll {
    margin: 0px;
    border: none;
}

#text {
    margin: 5px;
    border: none;
    color: ${cyan};
} 

#entry.activatable #text {
    color: ${background};
}

#entry > * {
    color: ${cyan};
}

#entry:selected {
    background-color: ${background-light};
}

#entry:selected #text {
    font-weight: bold;
}
"
      };

      ### waybar configuration:
      # Based on sway config by https://github.com/arkboix
      # Found here: https://github.com/arkboix/sway/
      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            positon = "top";
            height = 30;
            modules-left = [ "sway/workspaces" "sway/mode" "custom/quote" ];
            modules-center = [ "clock" ];
            modules-right = [ "pulseaudio" "backlight" "network" "bluetooth" "cpu" "memory" "battery" "tray" ];

            "sway/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
              format = "{name}";
              format-icons = {
                "1" = "󰖟";
                "2" = "";
                "3" = "";
                "4" = "󰭹";
                "5" = "󰕧";
                "6" = "";
                "7" = "";
                "8" = "󰣇";
                "9" = "";
                "10" = "";
              };
              persistent_workspaces = {
                "1" = [];
                "2" = [];
                "3" = [];
                "4" = [];
                "5" = [];
              };
            };
            "sway/mode" = {
              format = "<span style=\"italic\">{}</span>";
            };
            "custom/playerctl" = {
              format = " 󰐊 {}";
              return-type = "json";
              max-length = 40;
              exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{artist}} - {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
              on-click = "playerctl play-pause";
              on-click-right = "playerctl next";
            };
            "custom/power" = {
              format = " 󰐥 ";
              on-click = "swaynag -t warning -m 'Do you really want to shut down?' -B 'Yes, shutdown' 'poweroff'";
              on-click-right = "swaynag -t warning -m 'Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
              tooltip = false;
            };
            "custom/quote" = {
              format = "{}";
              interval = 3600;
              exec = "fortune -s";
              on-click = "fortune | yad --text-info --width=400 --height=200 --title='Fortune'";
              tooltip = true;
            };
            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                "activated" = "󰈈";
                "deactivated" = "󰈉";
              };
              tooltip = true;
            };
            "clock" = {
              format = "󰃮 {:%d-%m-%Y 󰥔 %H:%M}";
              format-alt = "󰃮 {:%A %d %B, %Y}";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              calendar = {
                mode = "month";
                mode-mon-col = 3;
                weeks-pos = "right";
                on-scroll = 1;
                on-click-right = "mode";
                format = {
                  "months" = "<span color='#d3c6aa'><b>{}</b></span>";
                  "days" = "<span color='#e67e80'>{}</span>";
                  "weeks" = "<span color='#a7c080'><b>W{}</b></span>";
                  "weekdays" = "<span color='#7fbbb3'><b>{}</b></span>";
                  "today" = "<span color='#dbbc7f'><b><u>{}</u></b></span>";
                };
              };
              actions = {
                on-click-right = "mode";
                on-click-forward = "tz_up";
                on-click-backward = "tz_down";
                on-scroll-up = "shift_up";
                on-scroll-down = "shift_down";
              };
            };
            "cpu" = {
              format = "󰘚 {usage}%";
              tooltip = true;
              interval = 1;
              on-click = "kitty -e btop";
            };
            "memory" = {
              format = "󰍛 {}%";
              interval = 1;
              on-click = "kitty -e btop";
            };
            "battery" = {
              states = {
                good = 95;
                warning = 30;
                critical = 15;
              };
              format = "{icon} {capacity}%";
              format-charging = "󰂄 {capacity}%";
              format-plugged = "󰚥 {capacity}%";
              format-alt = "{icon} {time}";
              format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
            };
            "network" = {
              format-wifi = "󰖩 {essid} ({signalStrength}%)";
              format-ethernet = "󰈀 {ifname}";
              format-linked = "󰈀 {ifname} (No IP)";
              format-disconnected = "󰖪 Disconnected";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
              tooltip-format = "{ifname}: {ipaddr}";
              on-click = "kitty -e nmtui";
            };
            "bluetooth" = {
              format = " {status}";
              format-disabled = "󰂲";
              format-connected = " {device_alias}";
              format-connected-battery = " {device_alias} {device_battery_percentage}%";
              tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
              tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
              tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
              tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
            };
            "pulseaudio" = {
              format = "{icon} {volume}%";
              format-bluetooth = "󰂰 {volume}%";
              format-bluetooth-muted = "󰂲 {icon}";
              format-muted = "󰝟";
              format-icons = {
                "headphone" = "󰋋";
                "hands-free" = "󰥰";
                "headset" = "󰋎";
                "phone" = "󰏲";
                "portable" = "󰄝";
                "car" = "󰄋";
                "default" = [ "󰕿" "󰖀" "󰕾" ];
              };
              on-click = "pavucontrol";
              on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
              on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +2%";
              on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -2%";
            };
            "backlight" = {
              format = "{icon} {percent}%";
              format-icons = [ "󰃞" "󰃟" "󰃠" ];
              on-scroll-up = "brightnessctl set +5%";
              on-scroll-down = "brightnessctl set 5%-";
            };
            "disk" = {
              interval = 30;
              format = "󰋊 {percentage_used}%";
              path = "/";
              on-click = "kitty -e gdu /";
            };
            "tray" = {
              icon-size = 10;
              spacing = 5;
            };
          };
        };
        style = "
/* Module-specific colors */
@define-color workspaces-color ${foreground};
@define-color workspaces-focused-bg ${green};
@define-color workspaces-focused-fg ${cyan};
@define-color workspaces-urgent-bg ${red};
@define-color workspaces-urgent-fg ${black};

/* Text and border colors for modules */
@define-color mode-color ${orange};
@define-color mpd-color ${magenta};
@define-color weather-color ${magenta};
@define-color playerctl-color ${magenta};
@define-color clock-color ${blue};
@define-color cpu-color ${green};
@define-color memory-color ${magenta};
@define-color temperature-color ${yellow};
@define-color temperature-critical-color ${red};
@define-color battery-color ${cyan};
@define-color battery-charging-color ${green};
@define-color battery-warning-color ${yellow};
@define-color battery-critical-color ${red};
@define-color network-color ${blue};
@define-color network-disconnected-color ${crimson};
@define-color pulseaudio-color ${orange};
@define-color pulseaudio-muted-color ${red};
@define-color backlight-color ${yellow};
@define-color disk-color ${cyan};
@define-color uptime-color ${green};
@define-color updates-color ${orange};
@define-color quote-color ${green};
@define-color idle-inhibitor-color ${foreground};
@define-color idle-inhibitor-active-color ${red};
@define-color power-color ${crimson};
@define-color bluetooth-color ${blue};
@define-color bluetooth-disconnected-color ${crimson};

* {
    /* Base styling for all modules */
    border: none;
    border-radius: 0;
    font-family: "Iosevka Nerd Font";
    font-size: 14px;
    min-height: 0;
}

window#waybar {
    background-color: ${background};
    color: ${foreground};
}

/* Common module styling with border-bottom */
#mode, #mpd, #custom-weather, #custom-playerctl, #clock, #cpu,
#memory, #temperature, #battery, #network, #pulseaudio,
#backlight, #disk, #custom-uptime, #custom-updates, #custom-quote,
#idle_inhibitor, #tray, #bluetooth {
    padding: 0 10px;
    margin: 0 2px;
    border-bottom: 2px solid transparent;
    background-color: transparent;
}

/* Workspaces styling */
#workspaces button {
    padding: 0 10px;
    background-color: transparent;
    color: @workspaces-color;
    margin: 0;
}

#workspaces button:hover {
    background: ${background-light};
    box-shadow: inherit;
}

#workspaces button.focused {
    box-shadow: inset 0 -2px @workspaces-focused-fg;
    color: @workspaces-focused-fg;
    font-weight: 900;
}

#workspaces button.urgent {
    background-color: @workspaces-urgent-bg;
    color: @workspaces-urgent-fg;
}

/* Module-specific styling */
#custom-power {
    font-size: 16px;
    color: @power-color;
    border-bottom-color: @power-color;
}

#mode {
    color: @mode-color;
    border-bottom-color: @mode-color;
}

#mpd {
    color: @mpd-color;
    border-bottom-color: @mpd-color;
}

#mpd.disconnected,
#mpd.stopped {
    color: @foreground;
    border-bottom-color: transparent;
}

#custom-weather {
    color: @weather-color;
    border-bottom-color: @weather-color;
}

#custom-playerctl {
    color: @playerctl-color;
    border-bottom-color: @playerctl-color;
}

#custom-playerctl.Playing {
    color: @cyan;
    border-bottom-color: @cyan;
}

#custom-playerctl.Paused {
    color: @orange;
    border-bottom-color: @orange;
}

#clock {
    color: @clock-color;
    border-bottom-color: @clock-color;
}

#cpu {
    color: @cpu-color;
    border-bottom-color: @cpu-color;
}

#memory {
    color: @memory-color;
    border-bottom-color: @memory-color;
}

#temperature {
    color: @temperature-color;
    border-bottom-color: @temperature-color;
}

#temperature.critical {
    color: @temperature-critical-color;
    border-bottom-color: @temperature-critical-color;
}

#battery {
    color: @battery-color;
    border-bottom-color: @battery-color;
}

#battery.charging, #battery.plugged {
    color: @battery-charging-color;
    border-bottom-color: @battery-charging-color;
}

#battery.warning:not(.charging) {
    color: @battery-warning-color;
    border-bottom-color: @battery-warning-color;
}

#battery.critical:not(.charging) {
    color: @battery-critical-color;
    border-bottom-color: @battery-critical-color;
}

#network {
    color: @network-color;
    border-bottom-color: @network-color;
}

#network.disconnected {
    color: @network-disconnected-color;
    border-bottom-color: @network-disconnected-color;
}

#bluetooth {
    color: @bluetooth-color;
    border-bottom-color: @bluetooth-color;
}

#bluetooth.disabled {
    color: @bluetooth-disconnected-color;
    border-bottom-color: @bluetooth-disconnected-color;
}

#pulseaudio {
    color: @pulseaudio-color;
    border-bottom-color: @pulseaudio-color;
}

#pulseaudio.muted {
    color: @pulseaudio-muted-color;
    border-bottom-color: @pulseaudio-muted-color;
}

#backlight {
    color: @backlight-color;
    border-bottom-color: @backlight-color;
}

#disk {
    color: @disk-color;
    border-bottom-color: @disk-color;
}

#custom-uptime {
    color: @uptime-color;
    border-bottom-color: @uptime-color;
}

#custom-updates {
    color: @updates-color;
    border-bottom-color: @updates-color;
}

#custom-quote {
    color: @quote-color;
    border-bottom-color: @quote-color;
}

#idle_inhibitor {
    color: @idle-inhibitor-color;
    border-bottom-color: transparent;
}

#idle_inhibitor.activated {
    color: @idle-inhibitor-active-color;
    border-bottom-color: @idle-inhibitor-active-color;
}

#tray {
    background-color: transparent;
    padding: 0 10px;
    margin: 0 2px;
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    color: ${red};
    border-bottom-color: ${red};
}
"
      };

      ### mako configuration:
      # Based on sway config by https://github.com/arkboix
      # Found here: https://github.com/arkboix/sway/
      services.mako = {
        enable = true;
        font = "Iosevka Nerd Font 11";
        sort = "-time";
        layer = "overlay";
        anchor = "top-right";
        background-color = "${background}";
        width = 300;
        height = 110;
        margin = 5;
        padding = "0,5,10";
        border-size = 2;
        border-color = "${border}";
        border-radius = 10;
        icons = true;
        max-icon-size = 64;
        default-timeout = 5000;
        ignore-timeout = true;
        extraConfig = "
[urgency=high]
border-color=${crimson}
default-timeout=0

[summary~=\"log-.*\"]
border-color=${red}
"
      };

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

      ### Automatically link any external configuration files into .config
      # Less prefereable than directly managing via home manager but necessary for some which are missing modules.
      #xdg.configFile."sway/config".source = "/home/${user}/nixos-config/dotfiles/sway/config";
      #xdg.configFile."waybar/style.css".source = "/home/${user}/nixos-config/dotfiles/waybar/style.css";
      #xdg.configFile."waybar/config.jsonc".source = "/home/${user}/nixos-config/dotfiles/waybar/config.jsonc";
      #xdg.configFile."mako/config".source = "/home/${user}/nixos-config/dotfiles/mako/config";
      #xdg.configFile."wofi/style.css".source = "/home/${user}/nixos-config/dotfiles/wofi/style.css";
      xdg.configFile."xfce/helpers.rc".source = "/home/${user}/nixos-config/dotfiles/xfce4/helpers.rc";
      #xdg.configFile."kitty/kitty.conf".source = "/home/${user}/nixos-config/dotfiles/kitty/kitty.conf";

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

  #Thunar file manager extensions and thumbnail support
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.tumbler.enable = true;
  programs.file-roller.enable = true;

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      corefonts
      liberation_ttf
      nerdfonts
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Serif" "Source Han Serif" ];
      sansSerif = [ "Noto Sans" "Sans" "Source Han Sans" ];
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
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
