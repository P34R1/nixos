{ config, pkgs, ... }:

{
  # https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
  programs.foot = {
    enable = true;
    settings = {
      colors.alpha = 0.5;
    };
  };

  environment.systemPackages = [
    pkgs.foot
  ];
}
