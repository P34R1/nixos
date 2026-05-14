{ self, inputs, ... }:

{
  flake.nixosModules.nginxSlskd =
    { config, lib, ... }:
    let
      cfg = config.slskd;
      music = "/home/${cfg.user}/Music";
    in
    {
      options.slskd = with lib; {
        user = mkOption { type = types.str; };
      };

      config = {
        age.secrets.slskd.file = ./slskd.age;

        systemd.services.slskd.serviceConfig = {
          ProtectHome = lib.mkForce "tmpfs";
          BindPaths = [ music ];
        };

        services.slskd = {
          enable = true;
          user = cfg.user;

          domain = "www.${config.nginx.domain}";
          environmentFile = config.age.secrets.slskd.path;
          settings = {
            web.url_base = "/slskd";
            shares.directories = [ "${music}/library/" ];
            directories = {
              downloads = "${music}/downloads/";
              incomplete = "${music}/incomplete/";
            };
          };
        };
      };
    };
}
