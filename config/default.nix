{ config, pkgs, lib, ... }:

# https://github.com/vimjoyer/nixconf/tree/main/nixosModules
let
  filesIn = dir: (map (fname: dir + "/${fname}")
    (builtins.attrNames (builtins.readDir dir)));

  features = (filesIn ./features);
in
{
  options = {
    user = lib.mkOption {
      type = lib.types.str;
    };
  };

  imports = [
    # https://discourse.nixos.org/t/configuring-a-module-alias-for-home-manager/12914/2
    # This creates an alias hm = home-manager.users.${config.user} (pearl)
    # Use as config.hm.packages.git = { enable = true; };
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.user])
  ] ++ features;
}
