{ self, inputs, ... }:

{
  flake.window-managers = [
    {
      name = "dwm";
      command = "sx dwm";
      indicator = "d";
    }
  ];

  flake.nixosModules.dwm =
    { pkgs, lib, ... }:
    {
      services.xserver = {
        enable = true;

        displayManager.sx.enable = true;
        windowManager.dwm = {
          enable = true;
          # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/window-managers/dwm/default.nix
          package = inputs.dwm.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };
      };

      # https://nix-community.github.io/home-manager/options.xhtml#opt-services.picom.enable
      services.picom = {
        enable = true;
        backend = "xrender"; # Not hardware accelerated
      };

      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.slstatus
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
          hash = "sha256-EeLlLJTh9WLzKyPZmNsZFPhkk82jVI96xw1fPQPkCVQ=";
        };
      });
    };
}
