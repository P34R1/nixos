{ self, inputs, ... }:

{
  flake.nixosModules.nginx =
    { config, lib, ... }:
    {
      imports = [ self.nixosModules.acme ];
      options.nginx.domain = lib.mkOption {
        type = lib.types.str;
        default = "smegmail.org";
      };

      config = {
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        services.nginx = {
          enable = true;
          enableReload = true;

          recommendedGzipSettings = true;
          recommendedOptimisation = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;

          defaultListenAddresses = [
            "0.0.0.0"
            "[::0]"
          ];

          virtualHosts."${config.nginx.domain}" = {
            default = true;
            locations."/".return = "404";
          };
        };
      };
    };

  flake.nixosModules.acme =
    { config, lib, ... }:
    let
      domain = config.nginx.domain;
    in
    {
      # https://discourse.nixos.org/t/use-mapattrs-with-nixos-modules/22692
      options.services.nginx.virtualHosts = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { ... }:
            {
              useACMEHost = lib.mkDefault domain;
              forceSSL = lib.mkDefault true;
            }
          )
        );
      };

      config.security.acme = {
        acceptTerms = true;
        defaults = {
          email = "vincent.fortin279@gmail.com";
          webroot = "/var/lib/acme/acme-challenge";
          group = "nginx";
        };
      };
    };

  flake.nixosModules.dashy =
    { config, lib, ... }:
    {
      services.dashy = {
        enable = true;
        virtualHost = {
          enableNginx = true;
          domain = "www.${config.nginx.domain}";
        };

        settings = { };
      };
    };

  flake.nixosModules.slskd =
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
        systemd.services.slskd.serviceConfig = {
          ProtectHome = lib.mkForce "tmpfs";
          BindPaths = [ music ];
        };

        services.slskd = {
          enable = true;
          user = cfg.user;

          domain = "slskd.${config.nginx.domain}";
          nginx = {
            useACMEHost = config.nginx.domain;
            forceSSL = true;
          };

          environmentFile = "${music}/credentials.env";
          settings = {
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
