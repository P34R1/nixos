{ config, pkgs, lib, inputs, ... }:

# https://github.com/vimjoyer/nixconf/tree/main/nixosModules
let
  # https://github.com/Goxore/nixconf/blob/22d969809cbfdad01133d5bbafa47617d0427c24/myLib/default.nix#L40-L41
  filesIn = dir: (map (fname: dir + "/${fname}")
    (builtins.attrNames (builtins.readDir dir)));

  bundles = (filesIn ./bundles);
  features = (filesIn ./features);
in
{
  options = {
    user = lib.mkOption {
      type = lib.types.str;
    };
  };

  imports = [
    inputs.home-manager.nixosModules.default # Home Manager

    # https://discourse.nixos.org/t/configuring-a-module-alias-for-home-manager/12914/2
    # This creates an alias hm = home-manager.users.${config.user} (pearl)
    # Use as config.hm.packages.git = { enable = true; };
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.user])
    (lib.mkAliasOptionModule ["colours"] ["hm" "colorScheme" "palette"])
  ] ++ bundles ++ features;

  config.hm.imports = [
    inputs.nix-colors.homeManagerModules.default # Nix Colors
  ];
}
