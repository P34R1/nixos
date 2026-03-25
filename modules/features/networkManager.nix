{ self, inputs, ... }:

{
  flake.nixosModules.networkManager =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      cfg = config.networkManager;
    in
    {
      options.networkManager = with lib; {
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
