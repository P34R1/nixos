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
      musicPath = "/mnt/Music";
    in
    {
      imports = [ self.nixosModules.nginxSlskd ];
      services.nginx.virtualHosts."music.${config.nginx.domain}".locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.navidrome.settings.Port}";
        proxyWebsockets = true;
      };

      systemd.services.navidrome.serviceConfig.BindReadOnlyPaths = [ "/home/pearl/Music:${musicPath}" ];
      services.navidrome = {
        enable = true;
        group = "music";

        settings.PlaylistsPath = "${musicPath}/playlists";
      };
    };
}
