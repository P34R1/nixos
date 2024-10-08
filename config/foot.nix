{ config, pkgs, ... }:

{
  # https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.foot.enable
  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "${pkgs.fish}/bin/fish";
        #font = "JetBrains Mono:size=11";
      };

      colors = with config.colorScheme.palette; {
        alpha = "0.5";

        foreground = base05;
        background = base00;

        # Normal/regular colors (color palette 0-7)
        regular0 = base00;  # black
        regular1 = base01;  # red
        regular2 = base02;  # green
        regular3 = base03;  # yellow
        regular4 = base04;  # blue
        regular5 = base05;  # magenta
        regular6 = base06;  # cyan
        regular7 = base07;  # white

        # Bright colors (color palette 8-15)
        bright0 = base08;   # bright black
        bright1 = base09;   # bright red
        bright2 = base0A;   # bright green
        bright3 = base0B;   # bright yellow
        bright4 = base0C;   # bright blue
        bright5 = base0D;   # bright magenta
        bright6 = base0E;   # bright cyan
        bright7 = base0F;   # bright white
      };
    };
  };
}
