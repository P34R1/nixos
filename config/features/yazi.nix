{ config, pkgs, lib, ... }:

{
  options = {
    yazi.enable =
      lib.mkEnableOption "enable yazi configurations";
  };

  config = lib.mkIf config.yazi.enable {

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.enable
    hm.programs.yazi = {
      enable = true;

      keymap = {

      };

      settings = {

      };

      plugins = {
        glow = pkgs.fetchFromGitHub {
          owner = "Reledia";
          repo = "glow.yazi";
          rev = "main";
          sha256 = "sha256-fKJ5ld5xc6HsM/h5j73GABB5i3nmcwWCs+QSdDPA9cU=";
        };
      };
    };
  };
}
