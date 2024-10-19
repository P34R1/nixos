{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./nnn.nix
    ./foot.nix
    #./tofi.nix
    #./yazi.nix
    #./spicetify.nix
    #./fish/fish.nix
    ./hypr/hyprland.nix
    #./tmux/tmux.nix
    #./dunst/dunst.nix
  ];
}
