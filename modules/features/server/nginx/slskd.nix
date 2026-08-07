{ self, inputs, ... }:

{
  flake.nixosModules.nginxSlskd =
    { config, lib, ... }:
    let
      slskd = config.services.slskd.settings;
      musicOwner = config.slskd.musicOwner;
      musicPath = "/home/${musicOwner}/Music";
      group = "music";
    in
    {
      options.slskd.musicOwner = with lib; mkOption { type = types.str; };

      config = {
        age.secrets.slskd.file = ./slskd.age;

        users = {
          groups.${group}.gid = 55333;
          users = {
            ${musicOwner}.extraGroups = [ group ];
            slskd = {
              extraGroups = [ group ];
              isSystemUser = true;
            };
          };
        };

        systemd.services.slskd.serviceConfig = {
          UMask = "0002"; # makes music group have write
          ProtectHome = lib.mkForce "tmpfs";
          BindPaths = [ musicPath ];
        };

        services.nginx.virtualHosts.${config.nginx.domain}.locations.${slskd.web.url_base} = {
          proxyPass = "http://127.0.0.1:${toString slskd.web.port}";
          proxyWebsockets = true;
        };

        services.slskd = {
          enable = true;
          group = group;

          environmentFile = config.age.secrets.slskd.path;
          settings = {
            web.url_base = "/slskd";
            soulseek.listen_port = 55333;
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
