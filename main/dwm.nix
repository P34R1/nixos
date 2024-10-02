{ config, pkgs, ... }:

let
  buildInputs = with pkgs; [
    xorg.libX11.dev
    xorg.libXft
    imlib2
    xorg.libXinerama
  ];

  slstatusPackage = pkgs.dwmblocks.overrideAttrs (old: {
    src = /home/pearl/slstatus;
    nativeBuildInputs = buildInputs;
  });
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


  environment.systemPackages = [ slstatusPackage dmenu ];
}
