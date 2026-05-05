{ self, inputs, ... }:

{
  flake.nixosModules.nginxDashy =
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
}
