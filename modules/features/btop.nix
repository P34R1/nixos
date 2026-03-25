{ self, inputs, ... }:

{
  flake.nixosModules.btop =
    { pkgs, lib, ... }:
    let
      selfPackages = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      environment.systemPackages = [ selfPackages.btop ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.btop = inputs.wrapper-modules.wrappers.btop.wrap {
        inherit pkgs;

        # https://github.com/aristocratos/btop#configurability
        settings = {
          color_theme = "TTY";
          theme_background = false;
        };
      };
    };
}
