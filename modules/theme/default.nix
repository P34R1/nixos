{ self, ... }:

let
  theme = self.gruvbox;
  stripHash =
    str:
    if builtins.substring 0 1 str == "#" then
      builtins.substring 1 (builtins.stringLength str - 1) str
    else
      str;
in
{
  flake.theme = theme;
  flake.themeNoHash = builtins.mapAttrs (_: v: stripHash v) theme;
}
