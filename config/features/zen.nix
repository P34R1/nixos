{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  options = with lib; {
    zen.enable = mkEnableOption "enables zen";
  };

  config = lib.mkIf config.zen.enable {
    # https://wiki.nixos.org/wiki/Zen_Browser
    environment.systemPackages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
