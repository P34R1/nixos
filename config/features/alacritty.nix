{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    alacritty.enable = lib.mkEnableOption "enables alacritty";
  };

  config = lib.mkIf config.alacritty.enable {

    # https://alacritty.org/config-alacritty.html
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alacritty.enable
    hm.programs.alacritty = {
      enable = true;
      settings = {
        terminal.shell = "${pkgs.fish}/bin/fish";
        general.live_config_reload = false;

        window = {
          decorations = "None";
          dynamic_title = false;
          opacity = 0.75;
        };

        font = {
          normal = {
            family = "JetBrainsMonoNF";
            style = "Regular";
          };

          size = 11.0;
        };

        # Normal/regular colors (color palette 0-7)
        colors = with config.colours; {
          primary.background = "${base00}";
          primary.foreground = "${base06}";

          normal = {
            black = "${base01}"; # black
            red = "${base08}"; # red
            green = "${base0B}"; # green
            yellow = "${base09}"; # yellow
            blue = "${base0D}"; # blue
            purple = "${base0E}"; # purple
            cyan = "${base0C}"; # aqua/cyan
            white = "${base07}"; # white
          };

          # Bright colors (color palette 8-15)
          bright = {
            black = "${base04}";
            red = "${base12}"; # bright red
            green = "${base14}"; # green
            yellow = "${base13}"; # yellow
            blue = "${base16}"; # blue
            purple = "${base17}"; # purple
            cyan = "${base15}"; # aqua/cyan
            white = "${base07}"; # white
          };
        };
      };
    };
  };
}
