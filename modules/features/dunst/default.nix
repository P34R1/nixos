{ self, inputs, ... }:

{
  flake.nixosModules.dunst =
    { pkgs, lib, ... }:
    {
      services.dunst = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.dunst;
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.dunst = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        {
          inherit pkgs;
          package = pkgs.dunst;

          env.ICONS = ./icons;
          flags = {
            # https://github.com/ericmurphyxyz/dotfiles/blob/master/.config/dunst/dunstrc
            "--config" = ./dunstrc;
          };
        }
      );
    };
}
