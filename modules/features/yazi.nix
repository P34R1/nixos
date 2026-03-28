{ self, inputs, ... }:

{

  flake.nixosModules.yazi =
    { pkgs, ... }:
    {
      programs.yazi = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.yazi;
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      self,
      ...
    }:
    {
      packages.yazi = inputs.wrapper-modules.wrappers.yazi.wrap {
        inherit pkgs;

        settings = {
          keymap = {

          };

          yazi.plugin.prepend_previewers = [
            {
              url = "*.md";
              run = "piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark \"$1\"";
            }
            {
              mime = "audio/ogg";
              run = "piper -- vorbiscomment \"$1\" | grep -iE '^(TITLE|ALBUM|ARTIST|ALBUMARTIST)='";
            }
          ];

          yazi.plugins = with pkgs; {
            piper = yaziPlugins.piper;
            smart-paste = yaziPlugins.smart-paste;
          };
        };

        extraPackages = with pkgs; [
          glow
          vorbis-tools
          gnugrep
        ];
      };
    };
}
