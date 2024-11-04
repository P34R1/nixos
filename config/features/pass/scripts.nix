{
  lib,
  config,
  pkgs,
}:

# based on: https://git.zx2c4.com/password-store/tree/contrib/dmenu/passmenu

# https://nixos.wiki/wiki/Shell_Scripts
pkgs.stdenv.mkDerivation {
  name = "pass-scripts";

  src = builtins.path { path = ./.; };
  buildInputs = [
    pkgs.pass
    pkgs.coreutils
  ] ++ lib.optional config.hyprland.enable [ pkgs.tofi ]
  # ++ lib.optional config.dwm.enable [ pkgs.dmenu ]
  ;

  installPhase = ''
    # Setup Environment
    mkdir -p $out/bin
    cp *.fish $out/bin
  '';

  meta = with pkgs.lib; {
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
