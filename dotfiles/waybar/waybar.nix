{ config, pkgs, ... }:

let
  colors = import ./../../user/colors.nix {};
  profile = import ./../../user/profile.nix {};
in
{
  home-manager = {
    users.${profile.user} = { pkgs, ... }: {
      ### waybar configuration:
      # Based on sway config by https://github.com/arkboix
      # Found here: https://github.com/arkboix/sway/
      programs.waybar = {
        enable = true;
        systemd = {
          enable = false;
          target = "sway-session.target";
        };
        settings = {
          mainBar = {
            layer = "top";
            positon = "top";
            height = 30;
            modules-left = [ "clock" "sway/workspaces" "sway/mode" ];
            modules-center = [ "sway/window" ];
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
              format-wifi = "󰖩 ";
              format-ethernet = "󰈀 ";
              format-linked = "󰈀 (No IP)";
              format-disconnected = "󰖪 ";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
              tooltip-format = "{essid} ({signalStrength}%)\n{ifname}: {ipaddr}";
              on-click-right = "kitty -e nmtui";
            };
            "bluetooth" = {
              format = " ";
              format-disabled = "";
              format-connected = "󰂱 ";
              format-connected-battery = "󰂱 ";
              tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
              tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
              tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
              tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
              on-click = "blueman-manager";
            };
            "pulseaudio" = {
              format = "{icon} {volume}% {format_source}";
              format-bluetooth = "󰂰 {volume}% {format_source}";
              format-bluetooth-muted = "󰂲 {icon} {format_source}";
              format-muted = "󰝟  {format_source}";
              format-source = " {volume}%";
              format-source-muted = "󰍭";
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
              on-scroll-up = "brightnessctl set +2%";
              on-scroll-down = "brightnessctl set 2%-";
            };
            "disk" = {
              interval = 30;
              format = "󰋊 {percentage_used}%";
              path = "/";
              on-click = "kitty -e gdu /";
            };
            "tray" = {
              icon-size = 18;
              spacing = 5;
            };
          };
        };
        style = "
/* Module-specific colors */
@define-color workspaces-color ${colors.foreground};
@define-color workspaces-focused-bg ${colors.green};
@define-color workspaces-focused-fg ${colors.cyan};
@define-color workspaces-urgent-bg ${colors.red};
@define-color workspaces-urgent-fg ${colors.black};

/* Text and border colors for modules */
@define-color mode-color ${colors.orange};
@define-color mpd-color ${colors.magenta};
@define-color weather-color ${colors.magenta};
@define-color playerctl-color ${colors.magenta};
@define-color clock-color ${colors.blue};
@define-color cpu-color ${colors.green};
@define-color memory-color ${colors.magenta};
@define-color temperature-color ${colors.yellow};
@define-color temperature-critical-color ${colors.red};
@define-color battery-color ${colors.cyan};
@define-color battery-charging-color ${colors.green};
@define-color battery-warning-color ${colors.yellow};
@define-color battery-critical-color ${colors.red};
@define-color network-color ${colors.blue};
@define-color network-disconnected-color ${colors.crimson};
@define-color pulseaudio-color ${colors.orange};
@define-color pulseaudio-muted-color ${colors.red};
@define-color backlight-color ${colors.yellow};
@define-color disk-color ${colors.cyan};
@define-color uptime-color ${colors.green};
@define-color updates-color ${colors.orange};
@define-color quote-color ${colors.green};
@define-color idle-inhibitor-color ${colors.foreground};
@define-color idle-inhibitor-active-color ${colors.red};
@define-color power-color ${colors.crimson};
@define-color bluetooth-color ${colors.blue};
@define-color bluetooth-disconnected-color ${colors.crimson};

* {
    /* Base styling for all modules */
    border: none;
    border-radius: 10;
    font-family: \"Iosevka Nerd Font\";
    font-size: 14px;
    min-height: 0;
}

window#waybar {
    background-color: transparent;
    color: ${colors.foreground};
}

/* Module Styling */
.modules-right {
    background-color: ${colors.background};
    padding: 1px 6px 0 6px;
    margin: 2px 10px 0 0;
    border: 2px solid ${colors.border};
}
.modules-center {
    background-color: transparent;
    padding: 1px 6px 0 6px;
    margin: 2px 0 0;
}
.modules-left {
    background-color: ${colors.background};
    padding: 1px 6px 0 6px;
    margin: 2px 0 0 10px;
    border: 2px solid ${colors.border};
}

/* Common module styling with border-top */
#mode, #mpd, #custom-weather, #custom-playerctl, #clock, #cpu,
#memory, #temperature, #battery, #network, #pulseaudio,
#backlight, #disk, #custom-uptime, #custom-updates, #custom-quote,
#idle_inhibitor, #tray, #bluetooth {
    border-radius: 0px;
    padding: 0 10px;
    margin: 3px 2px;
    border-top: 2px solid transparent;
    background-color: transparent;
}

/* Workspaces styling */
#workspaces button {
    border-radius: 0px;
    padding: 0 10px;
    background-color: transparent;
    color: @workspaces-color;
    margin: 3px;
    border-top: 2px solid transparent;
}

#workspaces button:hover {
    background: ${colors.background-light};
}

#workspaces button.focused {
    color: @workspaces-focused-fg;
    border-top-color: @worldspaces-focused-fg;
    font-weight: 900;
}

#workspaces button.urgent {
    background-color: @workspaces-urgent-bg;
    color: @workspaces-urgent-fg;
    border-top-color: @worldspaces-urgent-fg;
}

/* Module-specific styling */
#custom-power {
    font-size: 16px;
    color: @power-color;
    border-top-color: @power-color;
}

#mode {
    color: @mode-color;
    border-top-color: @mode-color;
}

#mpd {
    color: @mpd-color;
    border-top-color: @mpd-color;
}

#mpd.disconnected,
#mpd.stopped {
    color: @foreground;
    border-top-color: transparent;
}

#custom-weather {
    color: @weather-color;
    border-top-color: @weather-color;
}

#custom-playerctl {
    color: @playerctl-color;
    border-top-color: @playerctl-color;
}

#custom-playerctl.Playing {
    color: @cyan;
    border-top-color: @cyan;
}

#custom-playerctl.Paused {
    color: @orange;
    border-top-color: @orange;
}

#clock {
    color: @clock-color;
    border-top-color: @clock-color;
}

#cpu {
    color: @cpu-color;
    border-top-color: @cpu-color;
}

#memory {
    color: @memory-color;
    border-top-color: @memory-color;
}

#temperature {
    color: @temperature-color;
    border-top-color: @temperature-color;
}

#temperature.critical {
    color: @temperature-critical-color;
    border-top-color: @temperature-critical-color;
}

#battery {
    color: @battery-color;
    border-top-color: @battery-color;
}

#battery.charging, #battery.plugged {
    color: @battery-charging-color;
    border-top-color: @battery-charging-color;
}

#battery.warning:not(.charging) {
    color: @battery-warning-color;
    border-top-color: @battery-warning-color;
}

#battery.critical:not(.charging) {
    color: @battery-critical-color;
    border-top-color: @battery-critical-color;
}

#network {
    color: @network-color;
    border-top-color: @network-color;
}

#network.disconnected {
    color: @network-disconnected-color;
    border-top-color: @network-disconnected-color;
}

#bluetooth {
    color: @bluetooth-color;
    border-top-color: @bluetooth-color;
}

#bluetooth.disabled {
    color: @bluetooth-disconnected-color;
    border-top-color: @bluetooth-disconnected-color;
}

#pulseaudio {
    color: @pulseaudio-color;
    border-top-color: @pulseaudio-color;
}

#pulseaudio.muted {
    color: @pulseaudio-color;
    border-top-color: @pulseaudio-color;
}

#backlight {
    color: @backlight-color;
    border-top-color: @backlight-color;
}

#disk {
    color: @disk-color;
    border-top-color: @disk-color;
}

#custom-uptime {
    color: @uptime-color;
    border-top-color: @uptime-color;
}

#custom-updates {
    color: @updates-color;
    border-top-color: @updates-color;
}

#custom-quote {
    color: @quote-color;
    border-top-color: @quote-color;
}

#idle_inhibitor {
    color: @idle-inhibitor-color;
    border-top-color: transparent;
}

#idle_inhibitor.activated {
    color: @idle-inhibitor-active-color;
    border-top-color: @idle-inhibitor-active-color;
}

#tray {
    background-color: transparent;
    padding: 0 10px;
    margin: 3px 2px;
    border-top: 2px solid ${colors.border};
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    color: ${colors.red};
    border-top-color: ${colors.red};
}
";
      };
    };
  };
}