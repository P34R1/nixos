{ self, inputs, ... }:

{
  flake.nixosModules.nginx =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
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
            forceSSL = true;
            useACMEHost = config.nginx.domain;

            locations."/".return = "301 https://www.${config.nginx.domain}$request_uri";
          };

          virtualHosts."www.${config.nginx.domain}" = {
            forceSSL = lib.mkForce true;
            useACMEHost = lib.mkForce config.nginx.domain;
            basicAuthFile =
              "pearl:$2y$05$9JCX99LgyUgC6yHI8NTdeuPUVeIlBsBn8IUFoSJbkrSFXRkjMn2U2"
              |> pkgs.writeText ".htpasswd"
              |> lib.mkForce;
          };
        };

        security.acme = {
          acceptTerms = true;
          defaults = {
            email = "vincent.fortin279@gmail.com";
            webroot = "/var/lib/acme/acme-challenge";
            group = "nginx";
          };
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

          domain = "www.${config.nginx.domain}";
          environmentFile = "${music}/credentials.env";
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
