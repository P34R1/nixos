{ self, inputs, ... }:

{
  flake.nixosModules.brightness =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      cfg = config.brightness;
    in
    {
      options.brightness = with lib; {
        users = mkOption { type = types.listOf types.str; };
      };

      config = {
        users.users = lib.genAttrs cfg.users (user: {
          extraGroups = [ "video" ];
        });

        hardware.acpilight = {
          enable = true;
        };
      };
    };
}
