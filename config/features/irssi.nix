{ config, lib, ... }:

{
  options = with lib; {
    irssi.enable = mkEnableOption "enables irssi";
  };

  config.hm = lib.mkIf config.irssi.enable {
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.irssi.enable
    programs.irssi = {
      enable = true;

      extraConfig = ''
        settings = {
          core = {
            real_name = "pearl";
          };
        };
      '';

      networks = {
        liberachat = {
          nick = "pear1";
          saslExternal = true;

          server = {
            address = "irc.libera.chat";
            port = 6697;
            autoConnect = true;

            ssl.certificateFile = "${config.hm.home.homeDirectory}/.irssi/certs/libera.pem";
          };

          channels = {
            nixos.autoJoin = false;
            edctf.autoJoin = true;
          };
        };
      };
    };
  };
}
