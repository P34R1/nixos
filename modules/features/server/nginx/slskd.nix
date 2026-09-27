{ self, inputs, ... }:

{
  flake.nixosModules.nginxSlskd =
    { config, lib, ... }:
    let
      slskd = config.services.slskd.settings;
      musicPath = "/mnt/Music";
      group = "music";
    in
    {
      imports = [ self.nixosModules.beets ];

      config = {
        age.secrets.slskd.file = ./slskd.age;

        users = {
          groups.${group}.gid = 55333;
          users.pearl.extraGroups = [ group ];
          users.slskd = {
            extraGroups = [ group ];
            isSystemUser = true;
          };
        };

        services.nginx.virtualHosts.${config.nginx.domain}.locations.${slskd.web.url_base} = {
          proxyPass = "http://127.0.0.1:${toString slskd.web.port}";
          proxyWebsockets = true;
        };

        systemd.services.slskd.serviceConfig.BindPaths = [ "/home/pearl/Music:${musicPath}" ];
        services.slskd = {
          enable = true;
          group = group;

          environmentFile = config.age.secrets.slskd.path;
          settings = {
            web.url_base = "/slskd";
            soulseek.listen_port = 55333;
            downloads.rename = false;
            shares.directories = [ "${musicPath}/library/" ];
            directories = {
              downloads = "${musicPath}/downloads/";
              incomplete = "${musicPath}/incomplete/";
            };
          };
        };
      };
    };
}
