{ config, pkgs, lib, ... }:

{
  options = {
    user = lib.mkOption {
      type = lib.types.str;
    };
  };

  imports = [
    ./git.nix
    ./nnn.nix
    ./foot.nix
    ./tofi.nix
    ./yazi.nix
    ./spicetify.nix
    ./fish/default.nix
    ./hypr/default.nix
    ./tmux/default.nix
    ./dunst/default.nix

    # https://discourse.nixos.org/t/configuring-a-module-alias-for-home-manager/12914/2
    # This creates an alias hm = home-manager.users.${config.user} (pearl)
    # Use as config.hm.packages.git = { enable = true; };
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.user])
  ];
}
