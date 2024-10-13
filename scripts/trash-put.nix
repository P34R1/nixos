{ pkgs }:

# script to fix use with nnn and trashy

pkgs.writeShellScriptBin "trash-put" ''
  ${pkgs.trashy}/bin/trash "$@"
''

