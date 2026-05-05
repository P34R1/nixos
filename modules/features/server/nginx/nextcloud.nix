{ self, inputs, ... }:

{
  flake.nixosModules.nginxNextcloud =
    { config, pkgs, ... }:
    {
      # https://wiki.nixos.org/wiki/Nextcloud
      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud33;

        hostName = "cloud.${config.nginx.domain}";
        database.createLocally = true;

        https = true;
        config = {
          dbtype = "mysql";
          adminuser = null;
        };

        extraApps = {
          files_3dmodelviewer = pkgs.fetchNextcloudApp {
            url = "https://github.com/WARP-LAB/files_3dmodelviewer/releases/download/v0.0.16/files_3dmodelviewer.tar.gz";
            hash = "sha256-vYW5KskBko/1fH0rODm5qaxieLPgL5MVz9tFSNLYA7k=";
            license = "agpl3Only";
          };
        };
      };
    };
}
