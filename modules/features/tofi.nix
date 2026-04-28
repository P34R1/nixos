{ self, inputs, ... }:

{
  flake.nixosModules.tofi =
    { pkgs, lib, ... }:
    {
      environment.systemPackages =
        let
          selfPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
        in
        with pkgs;
        with lib;
        [
          selfPkgs.tofi
          (writeShellScriptBin "tofi-clip" ''
            ${getExe cliphist} list | ${getExe selfPkgs.tofi} | ${getExe cliphist} decode | ${getExe' wl-clipboard "wl-copy"}
          '')
        ];
    };

  perSystem =
    { pkgs, lib, ... }:
    {
      packages.tofi = inputs.wrapper-modules.lib.wrapPackage (
        { config, ... }:
        {
          inherit pkgs;
          package = pkgs.tofi;

          constructFiles.config = {
            relPath = "config";
            content = lib.generators.toINIWithGlobalSection { } {
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
            };
          };

          flags = {
            "--config" = "${config.constructFiles.config.path}";
          };
        }
      );
    };
}
