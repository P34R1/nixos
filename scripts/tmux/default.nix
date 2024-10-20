{ pkgs, repoPaths ? "~/repos" }:

# https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer
# https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-windowizer

# https://nixos.wiki/wiki/Shell_Scripts
pkgs.stdenv.mkDerivation {
  name = "tmux-scripts";

  src = builtins.path { path = ./.; };
  buildInputs = [ pkgs.tmux ];

  installPhase = ''
    # Replace Variables
    sed -i "s|__REPOSITORY_PATHS__|${repoPaths}|g" tmux-sessionizer

    # Setup Environment
    mkdir -p $out/bin
    cp tmux-* $out/bin
  '';

  meta = with pkgs.lib; {
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
