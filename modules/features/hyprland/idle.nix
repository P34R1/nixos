{ self, inputs, ... }:

{
  flake.nixosModules.hypridle =
    { config, pkgs, ... }:
    {
      services.hypridle = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.hypridle;
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.hypridle = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        let
          gen = self.lib.generators;
          conf = pkgs.writeText "hypridle.conf" (
            gen.toHyprconf {
              attrs = {
                general = {
                  before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
                  after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
                  lock_cmd = "pidof hyprlock || hyprlock";
                };

                listener = [
                  {
                    timeout = 300; # 5min
                    on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
                  }
                  {
                    timeout = 600; # 10min
                    on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
                    on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
                  }
                ];
              };
            }
          );
        in
        {
          inherit pkgs;
          # TODO: wait for v0.1.8 https://github.com/hyprwm/hypridle
          # https://github.com/hyprwm/hypridle/commit/4de8bc0f7eb83e0039e057f991672fd91356bb56
          package = pkgs.hypridle.overrideAttrs (old: {
            src = pkgs.fetchFromGitHub {
              owner = "hyprwm";
              repo = "hypridle";
              rev = "main";
              hash = "sha256-iI1orcQNEQAwAyRHHRogC68E3nls710wwbaD1X6RRKI=";
            };
          });

          # https://github.com/ericmurphyxyz/dotfiles/blob/master/.config/hypr/hypridle.conf
          flags = {
            "-c" = "${conf}";
          };
        }
      );
    };
}
