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
";
      };
    };
  };
}