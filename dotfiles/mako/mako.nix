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
      ### mako configuration:
      # Based on sway config by https://github.com/arkboix
      # Found here: https://github.com/arkboix/sway/
      services.mako = {
        enable = true;
        font = "Iosevka Nerd Font 11";
        sort = "-time";
        layer = "overlay";
        anchor = "top-right";
        backgroundColor = "${background}";
        width = 300;
        height = 110;
        margin = "5";
        padding = "0,5,10";
        borderSize = 2;
        borderColor = "${border}";
        borderRadius = 10;
        icons = true;
        maxIconSize = 64;
        defaultTimeout = 15000;
        ignoreTimeout = true;
        extraConfig = "
[urgency=high]
border-color=${crimson}
default-timeout=0

[summary~=\"log-.*\"]
border-color=${red}
";
      };
    };
  };
}