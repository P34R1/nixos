{ self, inputs, ... }:

{
  flake.nixosModules.mpd =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.mpd;
    in
    {
      options.mpd = with lib; {
        musicPath = mkOption { type = types.str; };
      };

      config = {
        # https://nix-community.github.io/home-manager/options.xhtml#opt-services.mpd.enable
        hm.services.mpd = {
          enable = true;
          musicDirectory = cfg.musicPath;

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

        environment.systemPackages = with pkgs; [
          playerctl
          mpc
          self.packages.${pkgs.stdenv.hostPlatform.system}.mpdlrc
        ];
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.mpdlrc = pkgs.buildGoModule rec {
        pname = "mpdlrc";
        version = "0.7.4";

        src = pkgs.fetchFromGitHub {
          owner = "eNV25";
          repo = pname;
          rev = "v${version}";
          sha256 = "sha256-b/aj+kgovErp7zqzE53/ZfwkxFstOQ8GNl5fUSwIkTQ=";
        };

        vendorHash = "sha256-j9YzFnwdi3ZtNVy+uQET0S+sHbOkaNCfFC/B/a720HE=";
        env.GOWORK = "off";
      };
    };
}
