{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "undeadgamer279@gmail.com";
    userName = "p34r1";

    extraConfig = {
      init.defaultBranch = "main";
      #credential.helper = "ssh";
      url."ssh://git@github.com/".insteadOf = "https://github.com/";      
      #credential.credentialStore = "gpg";
    };
  };

  home.packages = [
#    pkgs.git-credential-oauth
#    pkgs.git-credential-manager
  ];
}
