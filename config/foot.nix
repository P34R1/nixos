{ config, pkgs, ... }:

{
  # https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.foot.enable
  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "${pkgs.fish}/bin/fish";
        font = "JetBrainsMonoNF:size=11";
      };

      # https://codeberg.org/dnkl/foot/src/branch/master/themes/gruvbox-dark
      colors = with config.colorScheme.palette; {
        alpha = "0.5";

        # Normal/regular colors (color palette 0-7)
        background = "282828";
        foreground = "ebdbb2";
        regular0 = "282828";
        regular1 = "cc241d";
        regular2 = "98971a";
        regular3 = "d79921";
        regular4 = "458588";
        regular5 = "b16286";
        regular6 = "689d6a";
        regular7 = "a89984";

        # Bright colors (color palette 8-15)
        bright0 = "928374";
        bright1 = "fb4934";
        bright2 = "b8bb26";
        bright3 = "fabd2f";
        bright4 = "83a598";
        bright5 = "d3869b";
        bright6 = "8ec07c";
        bright7 = "ebdbb2";
      };
    };
  };
}
