{ config, pkgs, ... }:

let
  buildInputs = with pkgs; [
    xorg.libX11.dev
    xorg.libXft
    imlib2
    xorg.libXinerama
  ];
in
{
  services.xserver = {
    enable = true;
    autorun = false;
    displayManager.startx.enable = true;
    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs (old: {
        src = /home/pearl/dwm;
        nativeBuildInputs = buildInputs;
      });
    };
  };

  slstatusPackage = pkgs.dwmblocks.overrideAttrs (old: {
    src = /home/pearl/slstatus; # Path to your local dwmblocks source
    nativeBuildInputs = buildInputs;
  });
}
