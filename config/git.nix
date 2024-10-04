{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "undeadgamer279@gmail.com";
    userName = "p34r1";

    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "oauth";
    };
  };
}
