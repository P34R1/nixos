{ self, inputs, ... }:

{
  flake.nixosModules.nginxNavidrome =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      musicOwner = config.slskd.musicOwner;
      musicPath = "/home/${musicOwner}/Music";
      group = "music";

      navidrome = config.services.navidrome.settings;
    in
    {
      imports = [ self.nixosModules.nginxSlskd ];
      services.nginx.virtualHosts.${config.nginx.domain}.locations.${navidrome.BaseUrl} = {
        proxyPass = "http://127.0.0.1:${toString navidrome.Port}";
        proxyWebsockets = true;
      };

      systemd.services.navidrome.serviceConfig = {
        ProtectHome = lib.mkForce "tmpfs";
        BindPaths = [ musicPath ];
      };

      services.navidrome = {
        enable = true;
        group = group;
        settings.BaseUrl = "/music";
      };
    };
}
