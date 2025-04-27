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
in
{
  home-manager = {
    users.${user} = { pkgs, ... }: {
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
    font-family: \"Iosevka Nerd Font\";
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
";
      };
    };
  };
}