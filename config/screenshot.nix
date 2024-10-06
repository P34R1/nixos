{ pkgs }:

pkgs.writeShellScriptBin "screenshot" ''
  ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy
'';
