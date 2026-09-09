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
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        hostName = mkOption { type = types.str; };
        users = mkOption { type = types.listOf types.str; };
      };

      config = lib.mkIf (cfg.enable) {
        environment.systemPackages = [ pkgs.miniupnpc ];
        networking = {
          hostName = cfg.hostName;
          networkmanager.enable = true;
          nftables.enable = true;
        };

        users.users = lib.genAttrs cfg.users (user: {
          extraGroups = [ "networkmanager" ];
        });
      };
    };
}
