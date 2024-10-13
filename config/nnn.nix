{ config, pkgs, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nnn.enable
  programs.nnn = {
    enable = true;

    bookmarks = {
      r = "~/repos/";
    };

    plugins.src = (pkgs.fetchFromGitHub {
      owner = "jarun";
      repo = "nnn";
      rev = "master";
      sha256 = "sha256-P/kvZHcpFk4LgQ41lxwsSrsm4WoSSzFD3gNblsuYDzo=";
    }) + "/plugins";

    package = pkgs.nnn.override ({
      withNerdIcons = true; 
    });
  };
}
