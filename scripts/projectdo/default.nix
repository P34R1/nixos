{ pkgs }:

# https://github.com/paldepind/projectdo/blob/main/projectdo

pkgs.stdenv.mkDerivation {
  name = "projectdo";

  src = builtins.path { path = ./.; };
  buildInputs = [];

  installPhase = ''
    mkdir -p $out/bin
    cp projectdo.sh $out/bin/projectdo
  '';

  # meta = with pkgs.lib; {
  #   license = licenses.gpl3;
  #   platforms = platforms.linux;
  # };
}

