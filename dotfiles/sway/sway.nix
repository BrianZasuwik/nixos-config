{ config, pkgs, ... }:

let
  user = "bzas";

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

  # Navigation keys
  up = "i";
  left = "j";
  down = "k";
  right = "l";

  # Sway basic apps
  modifier = "Mod4";
  terminal = "kitty";
  menu = "wofi --allow-images --show=drun | xargs swaymsg exec --";
in
{
  # Window Manager install on system level, configured by home-manager.
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    xwayland.enable = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    configPackages = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.gnome-session
    ];
    config = {
      common = {
        default = [ "wlr" "gtk" ];
      };
    };
  };

  home-manager = {
    users.${user} = { pkgs, lib, ... }: {

      home.packages = with pkgs; [
        # Packages for wm:
        dconf
        brightnessctl
        grim
        slurp
        swaybg
        swayidle
        wl-clipboard
        gdu
        btop
        pavucontrol
      ];

      ### sway wm configuration:
      # Based on sway config by https://github.com/arkboix
      # Found here: https://github.com/arkboix/sway/
      wayland.systemd.target = "sway-session.target";
      wayland.windowManager.sway = {
        checkConfig = false;
        # Used to bypass an error in SwayFX that causes a build failure, see terminal output below:
          # 00:00:00.001 [wlr] [render/fx_renderer/fx_renderer.c:601] Cannot create GLES2 renderer: no DRM FD available
          # 00:00:00.001 [sway/server.c:150] Failed to create fx_renderer

        enable = true;
        package = null;
        wrapperFeatures = {
          base = true;
          gtk = true;
        };
        
        systemd = {
          enable = true;
          variables = [
            "--all"
          ];
        };

        xwayland = true;
        extraOptions = [ "--unsupported-gpu" ];
        config = {
          defaultWorkspace = "workspace number 1";

          terminal = "${terminal}";
          menu = "${menu}";
          modifier = "${modifier}";

          focus = {
            followMouse = true;
            wrapping = "no";
          };

          bars = [
            {
              command = "waybar";
            }
          ];

          gaps = {
            inner = 10;
          };

          up = "${up}";
          down = "${down}";
          left = "${left}";
          right = "${right}";

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

          keybindings = with lib; lib.mkOptionDefault {
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
            "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
            "XF86MonBrightnessUp" = "exec brightnessctl set +5%";

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
              bg = "/home/${user}/nixos-config/wallpapers/${wallpaper} fill";
            };
          };
        };

        extraConfigEarly = "
        corner_radius 10

        blur on
        blur_xray off
        blur_passes 2
        blur_radius 5
          
        shadows on
        shadows_on_csd off
        shadow_blur_radius 20
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

      # exec ${pkgs.swayidle}/bin/swayidle -w \ timeout 5 '${pkgs.brightnessctl}/bin/brightnessctl set 5% -s' resume '${pkgs.brightnessctl}/bin/brightnessctl -r' \ timeout 10 '${pkgs.swayfx}/bin/swaymsg \"output * power off\"' resume '${pkgs.swayfx}/bin/swaymsg \"output * power on\"'

      ### swayidle configuration:
      services.swayidle = {
        enable = true;
        systemdTarget = "sway-session.target";
        extraArgs = [
          "-w"
        ];
        timeouts = [
          {
            timeout = 300;
            command = "/run/current-system/sw/bin/brightnessctl set 5% -s";
            resumeCommand = "/run/current-system/sw/bin/brightnessctl -r";
          }
          {
            timeout = 600;
            command = "${pkgs.swayfx}/bin/swaymsg 'output * power off'";
            resumeCommand = "${pkgs.swayfx}/bin/swaymsg 'output * power on'";
          }
        ];
      };
    };
  };
}