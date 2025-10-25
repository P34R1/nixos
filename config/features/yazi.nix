{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    yazi.enable = lib.mkEnableOption "enable yazi configurations";
  };

  config = lib.mkIf config.yazi.enable {

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.enable
    hm.programs.yazi = {
      enable = true;

      keymap = {

      };

      settings = {
        plugin.prepend_previewers = [
          {
            url = "*.md";
            run = "piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark \"$1\"";
          }
          {
            mime = "audio/ogg";
            run = "piper -- vorbiscomment \"$1\" | grep -iE '^(TITLE|ALBUM|ARTIST|ALBUMARTIST)='";
          }
        ];
      };

      plugins = with pkgs; {
        piper = yaziPlugins.piper;
        smart-paste = yaziPlugins.smart-paste;
      };

      extraPackages = with pkgs; [
        glow
        vorbis-tools
        gnugrep
      ];
    };
  };
}
