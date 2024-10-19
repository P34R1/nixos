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
    #./yazi.nix
    #./spicetify.nix
    #./fish/fish.nix
    ./hypr/hyprland.nix
    #./tmux/tmux.nix
    #./dunst/dunst.nix

    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.user])
  ];
}
