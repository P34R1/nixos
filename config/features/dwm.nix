{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  dwm = pkgs.dwm.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "P34R1";
      repo = "dwm";
      rev = "master";
      hash = "sha256-FJ7RO/bdprWL6IgN+9iEfDp0pqc2YO8JP98eNZd7+Yk=";
    };
  });

  slstatus = pkgs.slstatus.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "P34R1";
      repo = "slstatus";
      rev = "main";
      hash = "sha256-d+/kngpR4c5Z91lh2RZ+r5RoJWr0LU7lbscJrGaJN68=";
    };
  });
in
{
  options = {
    dwm.enable = lib.mkEnableOption "enables dwm";
  };

  config = lib.mkIf config.dwm.enable {

    # tofi.enable = true;
    dunst.enable = true;
    alacritty.enable = true;

    services.xserver = {
      enable = true;

      displayManager.sx.enable = true;
      windowManager.dwm = {
        enable = true;

        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/window-managers/dwm/default.nix
        package = dwm;
      };
    };

    # https://nix-community.github.io/home-manager/options.xhtml#opt-services.picom.enable
    hm.services.picom = {
      enable = true;

      backend = "xrender"; # Not hardware accelerated
    };

    environment.systemPackages = [
      slstatus
      pkgs.dmenu
      pkgs.hsetroot
    ];
  };
}