{ config, pkgs, lib, ... }:

{
  options = {
    nnn.enable =
      lib.mkEnableOption "enables nnn";
  };

  config = lib.mkIf config.nnn.enable {

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nnn.enable
    home-manager.users.pearl.programs.nnn = {
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
  };
}
