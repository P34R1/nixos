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
      imports = with self.nixosModules; [
        nginxDashy
        nginxSlskd
        nginxNavidrome
        nginxNextcloud
      ];

      options.nginx.domain = lib.mkOption {
        type = lib.types.str;
        default = "smegmail.org";
      };

      config = {
        networking.firewall.allowedTCPPorts = with config.services.nginx; [
          defaultHTTPListenPort
          defaultSSLListenPort
        ];

        services.nginx =
          let
            sslCommon = {
              forceSSL = true;
              useACMEHost = config.nginx.domain;
            };

            redirect = new: { locations."/".return = "301 ${new}"; };
            auth = {
              basicAuthFile = pkgs.writeText ".htpasswd" "pearl:$2y$05$9JCX99LgyUgC6yHI8NTdeuPUVeIlBsBn8IUFoSJbkrSFXRkjMn2U2";
            };
          in
          {
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

            virtualHosts = {
              "_" = redirect "https://${config.nginx.domain}$request_uri" // {
                default = true;
              };

              "${config.nginx.domain}" = sslCommon // auth;
              "cloud.${config.nginx.domain}" = sslCommon;
              "music.${config.nginx.domain}" = sslCommon;
              "10.0.0.1" = sslCommon // redirect "http://$host$request_uri";
            };
          };

        security.acme = {
          acceptTerms = true;
          defaults = {
            email = "vincent.fortin279@gmail.com";
            webroot = "/var/lib/acme/acme-challenge";
            group = "nginx";
          };

          certs.${config.nginx.domain}.extraDomainNames = [
            "cloud.${config.nginx.domain}"
            "music.${config.nginx.domain}"
            "dc.${config.nginx.domain}"
          ];
        };
      };
    };
}
