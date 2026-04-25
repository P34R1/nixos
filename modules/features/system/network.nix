{ self, inputs, ... }:

{
  flake.nixosModules.network =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      cfg = config.network;
    in
    {
      options.network = with lib; {
        hostName = mkOption { type = types.str; };
        users = mkOption { type = types.listOf types.str; };
      };

      config = {
        networking = {
          hostName = cfg.hostName;
          networkmanager.enable = true;
        };

        users.users = lib.genAttrs cfg.users (user: {
          extraGroups = [ "networkmanager" ];
        });
      };
    };

}
