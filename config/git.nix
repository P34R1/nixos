{ config, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.enable
  programs.git = {
    enable = true;
    userEmail = "undeadgamer279@gmail.com";
    userName = "p34r1";

    extraConfig = {
      # Use main instead of master
      init.defaultBranch = "main";

      # Use SSH
      url."ssh://git@github.com/".insteadOf = "https://github.com/";      
    };
  };
}
