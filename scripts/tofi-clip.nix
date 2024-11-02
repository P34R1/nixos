{ pkgs }:

# clipboard manager using tofi
# requires tofi, cliphist and wl-clipboard to function

pkgs.writeShellScriptBin "tofi-clip" ''
  ${pkgs.cliphist}/bin/cliphist list | ${pkgs.tofi}/bin/tofi | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
''
