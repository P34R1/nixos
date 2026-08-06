{ self, inputs, ... }:

{
  flake.nixosModules.nginxSlskd =
    { config, lib, ... }:
    let
      cfg = config.slskd;
      musicPath = "/home/${cfg.musicOwner}/Music";

      group = "music";
    in
    {
      options.slskd = with lib; {
        musicOwner = mkOption { type = types.str; };
      };

      config = {
        age.secrets.slskd.file = ./slskd.age;

        users = {
          groups.${group}.gid = 55333;
          users = {
            ${cfg.musicOwner}.extraGroups = [ group ];
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

        services.slskd = {
          enable = true;
          group = group;

          domain = config.nginx.domain;
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
