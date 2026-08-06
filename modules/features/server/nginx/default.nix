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
            default = lib.mkForce true;
            forceSSL = lib.mkForce true;
            useACMEHost = lib.mkForce config.nginx.domain;
            basicAuthFile =
              "pearl:$2y$05$9JCX99LgyUgC6yHI8NTdeuPUVeIlBsBn8IUFoSJbkrSFXRkjMn2U2"
              |> pkgs.writeText ".htpasswd"
              |> lib.mkForce;
          };

          virtualHosts."cloud.${config.nginx.domain}" = {
            forceSSL = lib.mkForce true;
            useACMEHost = lib.mkForce config.nginx.domain;
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
