{ self, inputs, ... }:

{

  flake.nixosModules.dwm =
    { pkgs, lib, ... }:
    {
      loginScreen.window-managers = [
        {
          name = "dwm";
          command = "sx dwm";
          indicator = "d";
        }
      ];

      services.xserver = {
        enable = true;

        displayManager.sx.enable = true;
        windowManager.dwm = {
          enable = true;
          # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/window-managers/dwm/default.nix
          package = inputs.dwm.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };
      };

      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.slstatus
        self.packages.${pkgs.stdenv.hostPlatform.system}.picom
        pkgs.dmenu
        pkgs.hsetroot
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.slstatus = pkgs.slstatus.overrideAttrs (old: {
        src = pkgs.fetchFromGitHub {
          owner = "P34R1";
          repo = "slstatus";
          rev = "main";
          hash = "sha256-99NUaF3gQurfm6aQK07RWhyJVyCv2gJiz3aJLQh1vvg=";
        };
      });

      packages.picom = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        {
          inherit pkgs;
          package = pkgs.picom;
          flags = {
            "--backend" = "xrender";
          };
        }
      );
    };
}
