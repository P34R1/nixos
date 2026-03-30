{ self, inputs, ... }:

{
  flake.nixosModules.audio =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.audio;
    in
    {
      options.audio = with lib; {
        users = mkOption { type = types.listOf types.str; };
      };

      config = {
        users.users = lib.genAttrs cfg.users (user: {
          extraGroups = [ "audio" ];
        });

        security.rtkit.enable = true;
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
        };

        environment.systemPackages = [
          self.packages.${pkgs.stdenv.hostPlatform.system}.volume-script
        ];
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.volume-script = (
        pkgs.stdenv.mkDerivation {
          name = "volume-script";

          src = builtins.path { path = ./.; };
          buildInputs = with pkgs; [
            wireplumber
            dunst
          ];

          installPhase = ''
            mkdir -p $out/bin
            cp volume $out/bin
          '';

          meta = with pkgs.lib; {
            license = licenses.mit;
            platforms = platforms.linux;
          };
        }
      );
    };
}
