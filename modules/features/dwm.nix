{ self, inputs, ... }:

{

  flake.nixosModules.dwm =
    { pkgs, lib, ... }:
    {
      imports = with self.nixosModules; [
        alacritty
      ];

      loginScreen.window-managers = [
        {
          key = "d";
          name = "dwm";
          command = "sx dwm";
        }
      ];

      services.xserver = {
        enable = true;

        displayManager.sx.enable = true;
        windowManager.dwm = {
          enable = true;
          # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/window-managers/dwm/default.nix
          package = self.packages.${pkgs.stdenv.hostPlatform.system}.dwm;
        };
      };

      environment.systemPackages = with pkgs; [
        self.packages.${pkgs.stdenv.hostPlatform.system}.slstatus
        self.packages.${pkgs.stdenv.hostPlatform.system}.picom
        dmenu
        hsetroot
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.dwm = inputs.dwm.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
