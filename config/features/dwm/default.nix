{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  # startup = pkgs.writeShellScriptBin "start" ''
  #   ${pkgs.udiskie}/bin/udiskie &
  #   ${pkgs.dunst}/bin/dunst &
  #   ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store &
  #   sleep 2
  #   ${pkgs.waybar}/bin/waybar & disown
  #   ${pkgs.hypridle}/bin/hypridle &
  #   ${pkgs.swww}/bin/swww-daemon & disown
  # '';
  filesIn = dir: (map (fname: dir + "/${fname}") (builtins.attrNames (builtins.readDir dir)));
  patches = (filesIn ./patches);

  buildInputs = with pkgs; [
    xorg.libX11.dev
    xorg.libXft
    imlib2
    xorg.libXinerama
  ];

in
# slstatusPackage = pkgs.dwmblocks.overrideAttrs (old: {
# src = /home/pearl/repos/slstatus;
# src = inputs.slstatus;
# nativeBuildInputs = buildInputs;
# });
{
  options = {
    dwm.enable = lib.mkEnableOption "enables dwm";
  };

  config = lib.mkIf config.dwm.enable {

    # tofi.enable = true;
    # dunst.enable = true;
    # foot.enable = true;

    services.xserver = {
      enable = true;

      displayManager.sx.enable = true;
      windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.overrideAttrs (old: {
          # src = inputs.dwm;
          patches = patches;
          nativeBuildInputs = buildInputs;
        });
      };
    };

    environment.systemPackages = [
      # slstatusPackage
      pkgs.dmenu
      pkgs.picom
      pkgs.alacritty
    ];
  };
}
