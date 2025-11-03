{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    mpd.enable = lib.mkEnableOption "enable mpd configuration";
  };

  config = lib.mkIf config.mpd.enable {

    # https://nix-community.github.io/home-manager/options.xhtml#opt-services.mpd.enable
    hm.services.mpd = {
      enable = true;
      musicDirectory = "${config.hm.home.homeDirectory}/Music/";

      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire Output"
        }
      '';

      network = {
        # listenAddress = "any"; # if you want to allow non-localhost connections
        # port = 6600;
        startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
      };
    };

    # https://nix-community.github.io/home-manager/options.xhtml#opt-services.mpdris2.enable
    hm.services.mpdris2.enable = true;

    environment.systemPackages = [
      pkgs.mpc
      (pkgs.callPackage ./mpdlrc.nix { })
    ];
  };
}
