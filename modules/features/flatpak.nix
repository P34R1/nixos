{ self, inputs, ... }:

{
  flake.nixosModules.flatpak =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      services.flatpak.enable = true;
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common.default = [ "gtk" ];
      };
    };
}
