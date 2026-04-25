{ self, inputs, ... }:

{
  flake.nixosModules.video =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.video;
    in
    {
      options.video = with lib; {
        users = mkOption { type = types.listOf types.str; };
      };

      config = {
        users.users = lib.genAttrs cfg.users (user: {
          extraGroups = [ "video" ];
        });

        programs.dconf.enable = true;
        hardware = {
          acpilight.enable = true;
          graphics = {
            enable = true;
            enable32Bit = true;
          };
        };
      };
    };
}
