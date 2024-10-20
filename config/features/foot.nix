{ config, pkgs, lib, ... }:

{
  options = {
    foot.enable =
      lib.mkEnableOption "enables foot";
  };

  config = lib.mkIf config.foot.enable {

    # https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.foot.enable
    hm.programs.foot = {
      enable = true;
      settings = {
        main = {
          shell = "${pkgs.fish}/bin/fish";
          font = "JetBrainsMonoNF:size=11";
        };

        # https://codeberg.org/dnkl/foot/src/branch/master/themes/gruvbox-dark
        colors = with config.colours; {
          alpha = "0.75";

          # Normal/regular colors (color palette 0-7)
          background = "${base00}";
          foreground = "${base06}";
          regular0 = "${base02}"; # black
          regular1 = "${base08}"; # red
          regular2 = "${base0B}"; # green
          regular3 = "${base09}"; # yellow
          regular4 = "${base0D}"; # blue
          regular5 = "${base0E}"; # purple
          regular6 = "${base0C}"; # aqua/cyan
          regular7 = "${base07}"; # white

          # Bright colors (color palette 8-15)
          bright0 = "${base04}";
          bright1 = "${base12}"; # bright red
          bright2 = "${base14}"; # green
          bright3 = "${base13}"; # yellow
          bright4 = "${base16}"; # blue
          bright5 = "${base17}"; # purple
          bright6 = "${base15}"; # aqua/cyan
          bright7 = "${base07}"; # white
        };
      };
    };
  };
}
