{ self, lib, ... }:

let
  stripHashes = builtins.mapAttrs (_: lib.removePrefix "#");
in
{
  flake.theme = self.gruvbox;

  flake.themeNoHash = stripHashes self.theme;
}
