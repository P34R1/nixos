{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

# let
#   slstatusPackage = pkgs.dwmblocks.overrideAttrs (old: {
#     src = /home/pearl/repos/slstatus;
#     src = inputs.slstatus;
#     nativeBuildInputs = buildInputs;
#   });
# in
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
        package = pkgs.dwm.overrideAttrs (old: {
          src = pkgs.fetchFromGitHub {
            owner = "P34R1";
            repo = "dwm";
            rev = "master";
            hash = "sha256-1ztudlYYCJRTnL7tQe8BMdsJA9lQ7fGiXxfqjPDMkYc=";
          };
        });
      };
    };

    # https://nix-community.github.io/home-manager/options.xhtml#opt-services.picom.enable
    hm.services.picom = {
      enable = true;

      backend = "xrender"; # Not hardware accelerated
    };

    environment.systemPackages = [
      # slstatusPackage
      pkgs.dmenu
      pkgs.hsetroot
    ];
  };
}
