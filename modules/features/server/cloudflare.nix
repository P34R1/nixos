{ self, inputs, ... }:

{
  flake.nixosModules.ddns =
    { config, lib, ... }:
    {
      age.secrets.cloudflare-cred.file = ./cloudflare.age;

      services.cloudflare-ddns = {
        enable = true;
        ip6Domains = [ config.nginx.domain ];
        credentialsFile = config.age.secrets.cloudflare-cred.path;
      };
    };
}
