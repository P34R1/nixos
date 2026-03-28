{ self, inputs, ... }:

{
  flake.nixosModules.keyd =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    let
      cfg = config.keyd;
    in
    {
      options.keyd = with lib; {
        users = mkOption { type = types.listOf types.str; };
        settings = mkOption { };
      };

      config = {
        users.users = lib.genAttrs cfg.users (user: {
          extraGroups = [ "keyd" ];
        });

        environment.systemPackages = with pkgs; [
          keyd
        ];

        # https://wiki.nixos.org/wiki/Keyd
        services.keyd = {
          enable = true;
          keyboards.default = {
            ids = [ "*" ];
            settings.main = cfg.settings;
          };
        };
      };
    };
}
