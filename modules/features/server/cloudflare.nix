{ self, inputs, ... }:

{
  flake.nixosModules.ddns =
    { config, lib, ... }:
    {
      age.secrets.cloudflare-cred.file = ./cloudflare.age;

      services.cloudflare-ddns = {
        enable = true;
        domains = [ "dc.${config.nginx.domain}" ];
        credentialsFile = config.age.secrets.cloudflare-cred.path;
      };
    };
}
