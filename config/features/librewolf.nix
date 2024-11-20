{ config, lib, ... }:

{
  options = with lib; {
    librewolf.enable = mkEnableOption "enables git configuration";

  };

  config.hm = lib.mkIf config.librewolf.enable {

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.librewolf.enable
    programs.librewolf = {
      enable = true;

      settings = {
        "privacy.resistFingerprinting" = false;
      };
    };
  };
}
