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
        user = mkOption { type = types.str; };
      };

      config = {
        systemd.services.mpd.environment.XDG_RUNTIME_DIR = "/run/user/${
          toString config.users.users.${cfg.user}.uid
        }";
        services.mpd = {
          enable = true;
          startWhenNeeded = true;
          user = cfg.user;
          settings = {
            music_directory = "/home/${cfg.user}/Music";
            audio_output = [
              {
                name = "PipeWire Output";
                type = "pipewire";
              }
            ];
          };
        };

        systemd.user.services.mpdris2-rs = {
          description = "Music Player Daemon D-Bus Bridge";
          wantedBy = [ "default.target" ];
          after = [ "mpd.service" ];

          serviceConfig = {
            ExecStart = "${lib.getExe pkgs.mpdris2-rs}";
            Restart = "on-failure";
          };
        };

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
