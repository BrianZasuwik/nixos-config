{ config, pkgs, ... }:

let
  colors = import ./../../user/colors.nix {};
  profile = import ./../../user/profile.nix {};

  # Wallpaper
  wallpaper = "M31_IRAC-MIPS.jpg";

  # Sway basic apps
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
    wlr.enable = true;
  };

  home-manager = {
    users.${profile.user} = { pkgs, lib, ... }: {

      home.packages = with pkgs; [
        # Packages for wm:
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
          modifier = "${profile.modifier}";

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

          colors = {
            focused = {
              background = "${colors.border}";
              border = "${colors.border}";
              childBorder = "${colors.border}";
              indicator = "${colors.blue}";
              text = "${colors.white}";
            };
            unfocused = {
              background = "${colors.background-light}";
              border = "${colors.background}";
              childBorder = "${colors.background}";
              indicator = "${colors.background-light}";
              text = "${colors.white}";
            };
          };

          up = "${profile.up}";
          down = "${profile.down}";
          left = "${profile.left}";
          right = "${profile.right}";

          window = {
            border = 2;
            titlebar = true;
            commands = [
              {
                command = "foating enable, move position center, resize 600 400";
                criteria = {
                  title = "Volume Control";
                };
              }
              {
                command = "foating enable, move position center, resize 600 400";
                criteria = {
                  title = "Bluetooth Devices";
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
            criteria = [
              { title = "Volume Control"; }
              { title = "Bluetooth Devices"; }
              { app_id = "org.pulseaudio.pavucontrol"; }
              { title = "Steam Settings"; }
              { title = "Friends List"; }
              { app_id = "yad"; }
            ];
          };

          keybindings = with lib; lib.mkOptionDefault {
            # Start a terminal
            "${profile.modifier}+Return" = "exec ${terminal}";
            "${profile.modifier}+F1" = "exec ${terminal}";
              # The Mod+F(Key) binds are held over from my Gnome setup
              # as I am used to them.

            # Start a web browser
            "XF86HomePage" = "exec firefox";
            "${profile.modifier}+F2" = "exec firefox";

            # Start a file manager
            "${profile.modifier}+F3" = "exec thunar";

            # Kill focused window
            "${profile.modifier}+Shift+q" = "kill";

            # Start your launcher
            "${profile.modifier}+d" = "exec ${menu}";

            # Reload the config file
            "${profile.modifier}+Shift+c" = "reload";
              # Won't be reloading any changes on the fly as Sway's managed by
              # home maanger, but it might come in handy in case something breaks
              # ¯\_(ツ)_/¯

            # Exit sway
            "${profile.modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";

            ### Moving around
            # Moving your focus around
            "${profile.modifier}+Left" = "focus left";
            "${profile.modifier}+Down" = "focus down";
            "${profile.modifier}+Up" = "focus up";
            "${profile.modifier}+Right" = "focus right";
            "${profile.modifier}+${profile.left}" = "focus left";
            "${profile.modifier}+${profile.down}" = "focus down";
            "${profile.modifier}+${profile.up}" = "focus up";
            "${profile.modifier}+${profile.right}" = "focus right";
            # Moving the focused window
            "${profile.modifier}+Shift+Left" = "move left";
            "${profile.modifier}+Shift+Down" = "move down";
            "${profile.modifier}+Shift+Up" = "move up";
            "${profile.modifier}+Shift+Right" = "move right";
            "${profile.modifier}+Shift+${profile.left}" = "move left";
            "${profile.modifier}+Shift+${profile.down}" = "move down";
            "${profile.modifier}+Shift+${profile.up}" = "move up";
            "${profile.modifier}+Shift+${profile.right}" = "move right";

            ### Workspaces
            # Switch to workspace
            "${profile.modifier}+1" = "workspace number 1";
            "${profile.modifier}+2" = "workspace number 2";
            "${profile.modifier}+3" = "workspace number 3";
            "${profile.modifier}+4" = "workspace number 4";
            "${profile.modifier}+5" = "workspace number 5";
            "${profile.modifier}+6" = "workspace number 6";
            "${profile.modifier}+7" = "workspace number 7";
            "${profile.modifier}+8" = "workspace number 8";
            "${profile.modifier}+9" = "workspace number 9";
            "${profile.modifier}+0" = "workspace number 10";
            # Move focused container to workspace
            "${profile.modifier}+Shift+1" = "move container to workspace number 1";
            "${profile.modifier}+Shift+2" = "move container to workspace number 2";
            "${profile.modifier}+Shift+3" = "move container to workspace number 3";
            "${profile.modifier}+Shift+4" = "move container to workspace number 4";
            "${profile.modifier}+Shift+5" = "move container to workspace number 5";
            "${profile.modifier}+Shift+6" = "move container to workspace number 6";
            "${profile.modifier}+Shift+7" = "move container to workspace number 7";
            "${profile.modifier}+Shift+8" = "move container to workspace number 8";
            "${profile.modifier}+Shift+9" = "move container to workspace number 9";
            "${profile.modifier}+Shift+0" = "move container to workspace number 10";

            ### Layout controls
            # Split
            "${profile.modifier}+b" = "splith";
            "${profile.modifier}+v" = "splitv";
            # Switch current container between different layout styles
            "${profile.modifier}+s" = "layout stacking";
            "${profile.modifier}+w" = "layout tabbed";
            "${profile.modifier}+e" = "layout toggle split";
            # Make current window fullscreen
            "${profile.modifier}+f" = "fullscreen";
            # Toggle floating for current window
            "${profile.modifier}+Shift+space" = "floating toggle";
            # Swap focus between tiling area and floating area
            "${profile.modifier}+space" = "focus mode_toggle";
            # Move focus to parent container
            "${profile.modifier}+a" = "focus parent";

            ### Scratchpad
            # Move currently focused window to the scratchpad
            "${profile.modifier}+Shift+minus" = "move scratchpad";
            # Cycle through the scratchpad
            "${profile.modifier}+minus" = "scratchpad show";

            ### Modes
            # Resize mode
            "${profile.modifier}+r" = "mode resize";

            # Brightness Control
            "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
            "XF86MonBrightnessUp" = "exec brightnessctl set +5%";

            # Volume Controls
            "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
            "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
            "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
            "${profile.modifier}+XF86AudioRaiseVolume" = "exec 'pactl set-source-volume @DEFAULT_SOURCE@ +1%'";
            "${profile.modifier}+XF86AudioLowerVolume" = "exec 'pactl set-source-volume @DEFAULT_SOURCE@ -1%'";
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
              "${profile.up}" = "resize shrink height 10px";
              "${profile.down}" = "resize grow height 10px";
              "${profile.left}" = "resize shrink width 10px";
              "${profile.right}" = "resize grow width 10px";
              Return = "mode default";
              Escape = "mode default";
            };
          };

          output = {
            "*" = {
              bg = "/home/${profile.user}/nixos-config/wallpapers/${wallpaper} fill";
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
            command = "${pkgs.brightnessctl}/bin/brightnessctl set 0 -d tpacpi::kbd_backlight -s && ${pkgs.brightnessctl}/bin/brightnessctl set 5% -s";
            resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -d tpacpi::kbd_backlight -r && ${pkgs.brightnessctl}/bin/brightnessctl -r";
          }
          {
            timeout = 600;
            command = "${pkgs.swayfx}/bin/swaymsg 'output * power off'";
            resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -d tpacpi::kbd_backlight -r && ${pkgs.swayfx}/bin/swaymsg 'output * power on'";
          }
        ];
      };
    };
  };
}