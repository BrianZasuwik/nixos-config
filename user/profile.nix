{
  ...
}:
### User configuration and preferences
let
  user = "bzas";
  name = "Brian Zasuwik";
  timezone = "Europe/London";
  locale = "en_GB.UTF-8";

  # Keys
  modifier = "Mod4";
  up = "i";
  left = "j";
  down = "k";
  right = "l";
in
{
  inherit user;
  inherit name;
  inherit timezone;
  inherit locale;

  inherit modifier;
  inherit up;
  inherit down;
  inherit left;
  inherit right;
}