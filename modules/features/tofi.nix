{ self, inputs, ... }:

{
  flake.nixosModules.tofi =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.tofi
      ];
    };

  perSystem =
    { pkgs, lib, ... }:
    {
      packages.tofi = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        let
          conf = pkgs.writeText "config" (
            lib.generators.toINIWithGlobalSection { } {
              globalSection = with self.theme; {
                font = "${pkgs.nerd-fonts.roboto-mono}/share/fonts/truetype/NerdFonts/RobotoMonoNerdFontPropo-Medium.ttf";
                # #282828 alpha 75%
                background-color = "${base00}BF";
                border-color = base0E;
                text-color = base06;
                selection-color = base09;

                prompt-text = "> ";

                border-width = 3;
                height = "50%";
                width = "50%";
                corner-radius = 25;
                num-results = 10;
                outline-width = 0;
                result-spacing = 0;
              };
            }
          );
        in
        {
          inherit pkgs;
          package = pkgs.tofi;

          flags = {
            "--config" = "${conf}";
          };
        }
      );
    };
}
