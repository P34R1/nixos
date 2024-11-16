{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

# let
#   startup = pkgs.writeShellScriptBin "start" ''
#     ${pkgs.udiskie}/bin/udiskie &
#     ${pkgs.dunst}/bin/dunst &
#     ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store &
#     sleep 2
#     ${pkgs.waybar}/bin/waybar & disown
#     ${pkgs.hypridle}/bin/hypridle &
#     ${pkgs.swww}/bin/swww-daemon & disown
#   '';
#
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
        package = pkgs.dwm.overrideAttrs (old: {
          src = pkgs.fetchFromGitHub {
            owner = "P34R1";
            repo = "dwm";
            rev = "master";
            hash = "sha256-lnCoSDusBfwnA0URW3+t+muN2E+IMnBd2vh4SMbxfy8=";
          };
        });
      };
    };

    environment.systemPackages = [
      # slstatusPackage
      pkgs.dmenu
      pkgs.picom
    ];
  };
}
