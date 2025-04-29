{ config, pkgs, ... }:

let
  colors = import ./../../user/colors.nix {};
  profile = import ./../../user/profile.nix {};
in
{
  home-manager = {
    users.${profile.user} = { pkgs, ... }: {      
      ### wofi configuration:
      programs.wofi = {
        enable = true;
        style = "
window {
    margin: 0px;
    border: 2px solid ${colors.border};
    border-radius: 10px;
    background-color: ${colors.background};
}

#input {
    margin: 5px;
    border: none;
    color: #a3e8e8;
    background-color: ${colors.background-light};
}

#inner-box {
    margin: 5px;
    border: none;
    background-color: ${colors.background};
}

#outer-box {
    margin: 5px;
    border: none;
    background-color: ${colors.background};
}

#scroll {
    margin: 0px;
    border: none;
}

#text {
    margin: 5px;
    border: none;
    color: ${colors.cyan};
} 

#entry.activatable #text {
    color: ${colors.background};
}

#entry > * {
    color: ${colors.cyan};
}

#entry:selected {
    background-color: ${colors.background-light};
}

#entry:selected #text {
    font-weight: bold;
}
";
      };
    };
  };
}