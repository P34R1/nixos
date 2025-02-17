{ config, lib, ... }:

{
  options = with lib; {
    irssi.enable = mkEnableOption "enables irssi";
  };

  config.hm = lib.mkIf config.irssi.enable {
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.enable
    programs.irssi = {
      enable = true;
    };
  };
}
