{ self, inputs, ... }:

{
  flake.nixosModules.openssh =
    { config, lib, ... }:
    let
      cfg = config.openssh;
    in
    {
      options.openssh = with lib; {
        user = mkOption { type = types.str; };
      };

      config = {
        users.users.${cfg.user}.openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH97h8jvSFDbZPR4/KKhAUf8mtrgeIqWGzB9S0ATunDs undeadgamer279@gmail.com"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPCAtzH4xk6DyVHj61pl4VzLS2uFaG8s45Xr6u0uX2MA undeadgamer279@gmail.com"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICvavh5rpoj12Ywi5lXT6hCn38KZuZaU8Ln5Rh3OxsPb vincent.fortin279@gmail.com"
        ];

        services.openssh = {
          enable = true;
          listenAddresses = [
            {
              addr = "0.0.0.0";
              port = 22;
            }
            {
              addr = "[::]";
              port = 22;
            }
          ];

          settings = {
            PasswordAuthentication = false;
            AllowUsers = [ cfg.user ];
            PermitRootLogin = "no";
          };
        };

      };
    };

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
