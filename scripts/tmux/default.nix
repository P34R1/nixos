{ pkgs }:

# https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer
# https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-windowizer

# https://nixos.wiki/wiki/Shell_Scripts
pkgs.stdenv.mkDerivation {
  name = "tmux-scripts";

  src = builtins.path { path = ./.; };
  buildInputs = [ pkgs.tmux ];

  installPhase = ''
    mkdir -p $out/bin
    cp tmux-* $out/bin
  '';

  meta = with pkgs.lib; {
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
