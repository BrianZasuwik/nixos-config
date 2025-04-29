{ config, pkgs, ... }:
let
  colors = import ./../../user/colors.nix {};
  profile = import ./../../user/profile.nix {};
in
{
  home-manager = {
    users.${profile.user} = { pkgs, ... }: {
      ### mako configuration:
      # Based on sway config by https://github.com/arkboix
      # Found here: https://github.com/arkboix/sway/
      services.mako = {
        enable = true;
        font = "Iosevka Nerd Font 11";
        sort = "-time";
        layer = "overlay";
        anchor = "top-right";
        backgroundColor = "${colors.background}";
        width = 300;
        height = 110;
        margin = "5";
        padding = "0,5,10";
        borderSize = 2;
        borderColor = "${colors.border}";
        borderRadius = 10;
        icons = true;
        maxIconSize = 64;
        defaultTimeout = 15000;
        ignoreTimeout = true;
        extraConfig = "
[urgency=high]
border-color=${colors.crimson}
default-timeout=0

[summary~=\"log-.*\"]
border-color=${colors.red}
";
      };
    };
  };
}