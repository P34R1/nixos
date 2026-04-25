{ self, inputs, ... }:

{
  flake.nixosModules.nginx =
    { pkgs, ... }:
    {
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
      };

      security.acme = {
        acceptTerms = true;
        defaults.email = "vincent.fortin279@gmail.com";
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

          environmentFile = "${music}/credentials.env";
          domain = "slskd.smegmail.org";

          settings = {
            shares.directories = [ "${music}/library/" ];
            directories = {
              downloads = "${music}/downloads/";
              incomplete = "${music}/incomplete/";
            };
          };

          nginx = {
            enableACME = true;
            forceSSL = true;
          };
        };
      };
    };
}
