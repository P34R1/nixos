{ self, inputs, ... }:

{
  flake.nixosModules.hmSetup =
    {
      config,
      pkgs,
      lib,
      ...
    }:

    {
      options.hmSetup = {
        user = lib.mkOption {
          type = lib.types.str;
        };
      };

      imports = [
        inputs.home-manager.nixosModules.default # Import home manager module

        # https://discourse.nixos.org/t/configuring-a-module-alias-for-home-manager/12914/2
        # This creates an alias hm = home-manager.users.${config.user} (pearl)
        # Use as config.hm.packages.git = { enable = true; };
        (lib.mkAliasOptionModule
          [ "hm" ]
          [
            "home-manager"
            "users"
            config.hmSetup.user
          ]
        )
      ];

      config = {
        home-manager = {
          useGlobalPkgs = true;
          backupFileExtension = "backup";

          # Also pass inputs to home manager modules
          extraSpecialArgs = {
            inherit inputs;
          };
        };

        hm = {
          programs.home-manager.enable = true;
          home.username = "${config.hmSetup.user}";
          home.homeDirectory = "/home/${config.hmSetup.user}";
          home.stateVersion = "25.05"; # Don't Change.
        };
      };
    };
}
