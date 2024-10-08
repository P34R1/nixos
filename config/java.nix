{ config, pkgs, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.java.enable
  programs.java = {
    enable = true;
    
  };
}
