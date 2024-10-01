{ pkgs, ... }:

let
  dwm = pkgs.dwm.overrideAttrs (old: {
    src = builtins.fetchTarball https://github.com/P34R1/dwm/tarball/main;
    nativeBuildInputs = with pkgs; [ #writing once works for both currently, sort of bug and featur
      xorg.libX11.dev
      xorg.libXft
      imlib2
      xorg.libXinerama
    ];
  });

  dwmblocks = pkgs.dwmblocks.overrideAttrs (old: {
    src = builtins.fetchTarball https://github.com/P34R1/dwmblocks/tarball/main;
  });
in
{
  dwmPackages = [ dwm dwmblocks ];
}
