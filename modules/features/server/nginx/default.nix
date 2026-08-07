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

            virtualHosts."${config.nginx.domain}" = sslCommon // {
              default = true;
              basicAuthFile = pkgs.writeText ".htpasswd" "pearl:$2y$05$9JCX99LgyUgC6yHI8NTdeuPUVeIlBsBn8IUFoSJbkrSFXRkjMn2U2";
            };

            virtualHosts."cloud.${config.nginx.domain}" = sslCommon;
            virtualHosts."10.0.0.1" = sslCommon // {
              locations."/".extraConfig = "if ($scheme = https) { return 301 http://$host$request_uri; }";
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
            "dc.${config.nginx.domain}"
          ];
        };
      };
    };
}
