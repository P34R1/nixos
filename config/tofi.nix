{ config, pkgs, lib, ... }:

{
  options = {
    tofi.enable =
      lib.mkEnableOption "enable tofi configuration";
  };

  config = lib.mkIf config.tofi.enable {

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.tofi.enable
    hm.programs.tofi = {
      enable = true;
      settings = with config.hm.colorScheme.palette; {
        # RobotoMonoNerdFontProportional
        font = "${pkgs.nerdfonts}/share/fonts/truetype/NerdFonts/RobotoMonoNerdFontPropo-Medium.ttf";
        # #282828 alpha 75%
        background-color = "#${base00}BF";
        border-color = "#${base0E}";
        text-color = "#${base06}";
        selection-color = "#${base09}";

        prompt-text = "> ";

        border-width = 3;
        height = "50%";
        width = "50%";
        corner-radius = 25;
        num-results = 10;
        outline-width = 0;
        result-spacing = 0;
      };
    };
  };
}
